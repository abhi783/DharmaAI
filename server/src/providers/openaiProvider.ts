import { EventEmitter } from 'events';

class OpenAIProvider {
  providerId = 'openai';

  async sendMessage(_prompt: string, _opts?: any): Promise<string> {
    // NOTE: This is a stub. Real implementation should use axios/fetch with API key from process.env
    await new Promise((r) => setTimeout(r, 450));
    return '[OpenAI Stub] Dharma: response';
  }

  streamMessage(prompt: string, _opts?: any): EventEmitter {
    // For stub, return chunked emitter similar to MockProvider
    const e = new EventEmitter();
    const text = `[OpenAI Stub streaming] ${prompt}`;
    const parts = text.split(' ');
    let i = 0;
    const t = setInterval(() => {
      if (i >= parts.length) {
        clearInterval(t);
        e.emit('end');
      } else {
        e.emit('data', parts[i] + (i === parts.length - 1 ? '' : ' '));
      }
      i++;
    }, 70);
    return e;
  }

  async cancel() {}
}

export default OpenAIProvider;
