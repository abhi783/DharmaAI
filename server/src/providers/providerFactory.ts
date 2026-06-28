import Provider from './provider';
import MockProvider from './mockProvider';
import OpenAIProvider from './openaiProvider';
import GeminiProvider from './geminiProvider';
import OllamaProvider from './ollamaProvider';

const registry: Record<string, Provider> = {
  mock: new MockProvider(),
  openai: new OpenAIProvider(),
  gemini: new GeminiProvider(),
  ollama: new OllamaProvider(),
};

export default {
  getProvider(id: string) {
    return registry[id] || registry['mock'];
  },
  listProviders() {
    return Object.keys(registry);
  }
};
