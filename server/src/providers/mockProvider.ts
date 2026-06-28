import { EventEmitter } from 'events';

class MockProvider {
  providerId = 'mock';

  async sendMessage(prompt: string, _opts?: any): Promise<string> {
    await new Promise((r) => setTimeout(r, 300));
    return `[Mock] Dharma: I heard you. (${prompt.length} chars)`;
  }

  streamMessage(prompt: string, _opts?: any): EventEmitter {
    const e = new EventEmitter();
    // simulate streaming words
    const words = (`Mock streaming response for: ${prompt}`).split(' ');
    let i = 0;
    const t = setInterval(() => {
      if (i >= words.length) {
        clearInterval(t);
        e.emit('end');
      } else {
        e.emit('data', words[i] + (i === words.length - 1 ? '' : ' '));
      }
      i++;
    }, 80);
    return e;
  }

  async cancel() {
    // no-op for mock
  }
}

export default MockProvider;
