import request from 'supertest';
import app from '../src/server';
import {Readable} from 'stream';

// Helper to parse SSE stream into events
async function collectSse(url: string, payload: any) {
  const res = await request(app).post(url).send(payload).buffer(true);
  const text = res.text;
  const events: any[] = [];
  const lines = text.split(/\r?\n/);
  let currentEvent: any = { event: null, data: '' };
  for (const line of lines) {
    if (line.startsWith('event:')) {
      currentEvent.event = line.replace(/^event:\s*/, '').trim();
    } else if (line.startsWith('data:')) {
      currentEvent.data += line.replace(/^data:\s*/, '') + '\n';
    } else if (line.trim() === '') {
      if (currentEvent.data) {
        try {
          events.push({ event: currentEvent.event, data: JSON.parse(currentEvent.data) });
        } catch (e) {
          // ignore parse errors
        }
      }
      currentEvent = { event: null, data: '' };
    }
  }
  return events;
}

describe('Teaching stream server', () => {
  test('rejects non-teaching intent', async () => {
    const res = await request(app).post('/v1/teaching-stream').send({ query: 'Tell me a joke' });
    expect(res.status).toBe(400);
    expect(res.body.intent).toBeDefined();
  });

  test('streams teaching sections in order and includes scripture meta', async () => {
    const events = await collectSse('/v1/teaching-stream', { query: 'Explain Gita 2.47 and teach me', style: 'Detailed' });
    // Ensure we have multiple section events and a final
    const sectionEvents = events.filter(e => e.event === 'section');
    const finalEvent = events.find(e => e.event === 'final');
    expect(sectionEvents.length).toBeGreaterThanOrEqual(6);
    expect(finalEvent).toBeDefined();
    // check that at least one section includes meta.source for scripture
    const hasScripture = sectionEvents.some(e => e.data && e.data.meta && e.data.meta.source && e.data.meta.source.id === 'gita_2_47');
    expect(hasScripture).toBe(true);
  }, 20000);
});
