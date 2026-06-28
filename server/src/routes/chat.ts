import express from 'express';
import { verifyToken } from '../middleware/auth';
import ProviderFactory from '../providers/providerFactory';
import promptBuilder from '../prompt/promptBuilder';
import MemoryManager from '../memory/memoryManager';
import RAGManager from '../rag/ragManager';

const router = express.Router();

const memory = new MemoryManager();
const rag = new RAGManager();

// Non-streaming chat endpoint (returns final response)
router.post('/', verifyToken, async (req, res) => {
  try {
    const { userMessage, options, conversationHistory, personalityId, language } = req.body;
    // Build prompt server-side
    const personality = (personalityId) ? await (await import('../personality/personalityEngine')).default.personalityForId(personalityId) : undefined;
    const memorySnapshot = await memory.filteredMemoryForPrompt();
    const ragResults = await rag.searchRelevant(userMessage);
    const prompt = await promptBuilder.build({
      userMessage,
      language: language || 'te',
      conversationHistory: conversationHistory || [],
      personality: personality || undefined,
      memory: memorySnapshot,
      ragResults,
      options: options || {},
    });

    const provider = ProviderFactory.getProvider(process.env.DEFAULT_PROVIDER || 'mock');
    const response = await provider.sendMessage(prompt, { options });
    res.json({ provider: provider.providerId, assistant: response });
  } catch (err) {
    console.error('chat error', err);
    res.status(500).json({ error: 'server_error', message: String(err) });
  }
});

// Streaming endpoint using SSE-like chunked transfer
router.post('/stream', verifyToken, async (req, res) => {
  try {
    const { userMessage, options, conversationHistory, personalityId, language } = req.body;
    const personality = (personalityId) ? await (await import('../personality/personalityEngine')).default.personalityForId(personalityId) : undefined;
    const memorySnapshot = await memory.filteredMemoryForPrompt();
    const ragResults = await rag.searchRelevant(userMessage);
    const prompt = await promptBuilder.build({
      userMessage,
      language: language || 'te',
      conversationHistory: conversationHistory || [],
      personality: personality || undefined,
      memory: memorySnapshot,
      ragResults,
      options: options || {},
    });

    const provider = ProviderFactory.getProvider(process.env.DEFAULT_PROVIDER || 'mock');

    // Set headers for chunked transfer
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');

    // Stream from provider and flush to client
    const stream = provider.streamMessage(prompt, { options });

    const onData = (chunk: string) => {
      try {
        res.write(`data: ${chunk}\n\n`);
      } catch (e) {
        console.error('stream write failed', e);
      }
    };

    const onError = (err: any) => {
      try { res.write(`event: error\ndata: ${String(err)}\n\n`); } catch (_) {}
    };

    const end = () => {
      try { res.write(`event: done\ndata: [DONE]\n\n`); res.end(); } catch (_) {}
    };

    stream.on('data', onData);
    stream.on('error', onError);
    stream.on('end', end);

    // If client disconnects, cancel provider if possible
    req.on('close', () => {
      try { if (typeof provider.cancel === 'function') provider.cancel(); } catch (_) {}
    });
  } catch (err) {
    console.error('streaming error', err);
    res.status(500).json({ error: 'server_error', message: String(err) });
  }
});

// Memory endpoints
router.get('/memory', verifyToken, async (_req, res) => {
  const data = await memory.getAll();
  res.json({ memory: data });
});

router.post('/memory', verifyToken, async (req, res) => {
  const { key, value } = req.body;
  if (!key) return res.status(400).json({ error: 'invalid_request', message: 'key required' });
  await memory.remember(key, value);
  res.json({ ok: true });
});

router.delete('/memory/:key', verifyToken, async (req, res) => {
  await memory.delete(req.params.key);
  res.json({ ok: true });
});

export default router;
