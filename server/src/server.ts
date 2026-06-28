import express from 'express';
import cors from 'cors';
import { detectIntent } from './intent';
import { detectLearningStyle } from './styleDetector';
import { generateSectionFromProvider, validateSection } from './provider';
import { TeachingResponse, TeachingSection, ScriptureSource } from './types';

const app = express();
app.use(cors());
app.use(express.json());

// Helper: send SSE event
function sendSse(res: express.Response, event: string | null, data: any) {
  if (event) res.write(`event: ${event}\n`);
  res.write(`data: ${JSON.stringify(data)}\n\n`);
}

// Sections order we will generate and stream
const SECTION_ORDER = [
  'Simple Answer',
  'Explanation',
  'Example',
  // optional scripture sections: Verified Teaching, Traditional Interpretation, Modern Application
  'Summary',
  'Reflection',
  'Suggested Next Topic'
];

// Max one automatic retry per section
const MAX_RETRIES = 1;

app.post('/v1/teaching-stream', async (req, res) => {
  const { query, style: explicitStyle } = req.body || {};
  if (!query) return res.status(400).json({ error: 'Missing query' });

  const intent = detectIntent(query);
  if (intent !== 'Teaching') {
    return res.status(400).json({ error: 'Intent not Teaching', intent });
  }

  const style = detectLearningStyle(query, explicitStyle);

  // Setup SSE response
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.flushHeaders?.();

  // Stage start
  sendSse(res, 'stage', { type: 'stage', stage: 'thinking', message: '🧠 Dharma is understanding...' });

  // For scripture detection simplistic rule
  const isScripture = /gita|భగవద్గీత|ramayan|ramayanam|mahabharatam|తమ/i.test(query.toLowerCase());

  const sectionsToEmit: TeachingSection[] = [];

  // Generate sections in order; for scripture include sections
  const generationOrder = [...SECTION_ORDER];
  if (isScripture) {
    // insert scripture sections after 'Example' (position 3)
    generationOrder.splice(3, 0, 'Verified Teaching', 'Traditional Interpretation', 'Modern Application');
  }

  // Iterate and generate/validate/stream per section
  for (const title of generationOrder) {
    // generate
    let section = await generateSectionFromProvider(query, title, style);

    // validate
    let result = validateSection(section);
    let retries = 0;
    if (!result.valid && retries < MAX_RETRIES) {
      // retry generation for this section only
      retries++;
      section = await generateSectionFromProvider(query, title, style + '_retry');
      result = validateSection(section);
    }

    // If still invalid, log internally and continue with best available
    if (!result.valid) {
      console.error(`Section ${title} failed validation after ${retries} retries. Issues: ${result.issues}`);
    }

    // Stream section event
    sendSse(res, 'section', { type: 'section', index: sectionsToEmit.length, title: section.title, text: section.text, meta: section.meta || null });

    // progress event
    sendSse(res, 'progress', { type: 'progress', completedIndex: sectionsToEmit.length, totalSections: generationOrder.length });

    sectionsToEmit.push(section);

    // small delay to emulate generation latency and allow client to speak
    await new Promise((r) => setTimeout(r, 350));
  }

  // final event with structured TeachingResponse
  const finalObj: TeachingResponse = {
    simpleAnswer: sectionsToEmit[0],
    explanation: sectionsToEmit[1],
    example: sectionsToEmit[2],
    verifiedTeaching: sectionsToEmit.find((s) => s.title === 'Verified Teaching') || undefined,
    traditionalInterpretation: sectionsToEmit.find((s) => s.title === 'Traditional Interpretation') || undefined,
    modernApplication: sectionsToEmit.find((s) => s.title === 'Modern Application') || undefined,
    summary: sectionsToEmit.find((s) => s.title === 'Summary')!,
    reflectionQuestion: sectionsToEmit.find((s) => s.title === 'Reflection')!,
    relatedSuggestion: sectionsToEmit.find((s) => s.title === 'Suggested Next Topic') || undefined
  };

  sendSse(res, 'final', { type: 'final', teaching: finalObj });

  // close stream
  res.write('event: done\n');
  res.write('data: {}\n\n');
  res.end();
});

const PORT = process.env.PORT || 8090;
app.listen(PORT, () => console.log(`Dharma Brain teaching server listening on ${PORT}`));

export default app;
