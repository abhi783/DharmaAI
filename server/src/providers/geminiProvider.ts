import { EventEmitter } from 'events';

class GeminiProvider {
  providerId = 'gemini';

  async sendMessage(_prompt: string, _opts?: any): Promise<string> {
    await new Promise((r) => setTimeout(r, 420));
    return '[Gemini Stub] Dharma: response';
  }

  streamMessage(prompt: string, _opts?: any): EventEmitter {
    const e = new EventEmitter();
    const text = `[Gemini Stub streaming] ${prompt}`;
    const parts = text.split(' ');
    let i = 0;
    const t = setInterval(() => {
      if (i >= parts.length) { clearInterval(t); e.emit('end'); } else { e.emit('data', parts[i] + (i === parts.length - 1 ? '' : ' ')); }
      i++;
    }, 90);
    return e;
  }

  async cancel() {}
}

export default GeminiProvider;
