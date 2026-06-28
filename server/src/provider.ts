import {TeachingResponse, TeachingSection, ScriptureSource, TeachingSection as TS} from './types';

// Mock provider integration. In production, replace these with calls to an LLM or RAG + LLM.
export async function generateSectionFromProvider(query: string, section: string, style: string): Promise<TeachingSection> {
  // For production, invoke the provider with a prompt template that includes the
  // desired section and learning style. Here we return deterministic placeholders.
  const base = `${section}: (Generated for query) ${query} [style=${style}]`;
  // If the query mentions Gita, attach mock scripture meta for demo
  if (query.toLowerCase().includes('gita') || query.toLowerCase().includes('భగవద్గీత')) {
    const source: ScriptureSource = {
      id: 'gita_2_47',
      title: 'Bhagavad Gita 2.47',
      type: 'scripture_gita',
      chapter: 2,
      verse: 47,
      citation: 'Chapter 2, Verse 47',
      language: 'sanskrit',
      translation: 'Telugu translation placeholder',
      translator: 'Anonymous',
      verified: true,
      confidence: 0.98,
      copyright: '',
      url: ''
    };
    // For scripture-related sections we return a specific text
    if (section === 'Verified Teaching') {
      return { title: section, text: `Verified excerpt: Bhagavad Gita 2.47 - తప్పుడు తీరుతో కాకుండా కర్తవ్యంపై ఫలాన్ని ఆశించకుండానే చేయండ` , meta: { source } };
    }
    if (section === 'Traditional Interpretation') {
      return { title: section, text: `Traditional: ఇది శ్రద్ధతో చేయాల్సిన కర్తవ్య భావనని సూచిస్తుంది.`, meta: { source } };
    }
    if (section === 'Modern Application') {
      return { title: section, text: `Modern: ఫలాన్ని ఎదురుచూస్తూ కాకుండా కర్తవ్యానికి దృష్టి పెట్టండి.`, meta: { source } };
    }
  }

  return { title: section, text: base, meta: null };
}

export function validateSection(section: TeachingSection): { valid: boolean; score: number; issues?: string[] } {
  // Lightweight validation: ensure text length and not empty. In production run safety and source checks.
  const len = (section.text || '').trim().length;
  const valid = len > 20; // must be non-trivial
  const score = Math.min(1.0, len / 400.0 + 0.2);
  const issues = [] as string[];
  if (!valid) issues.push('too_short');
  return { valid, score, issues };
}
