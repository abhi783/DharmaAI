import nock from 'nock';
import { generateSectionFromProvider } from '../src/provider';

describe('Provider integration (mocked)', () => {
  const openaiHost = 'https://api.openai.com';
  const path = '/v1/chat/completions';

  afterEach(() => {
    nock.cleanAll();
  });

  test('successful provider response returns text', async () => {
    const mockResp = {
      id: 'resp',
      object: 'chat.completion',
      choices: [{ message: { role: 'assistant', content: 'This is a generated section text.' } }]
    };

    nock(openaiHost).post(path).reply(200, mockResp);

    const result = await generateSectionFromProvider('Tell me about dharma', 'Simple Answer', 'Detailed');
    expect(result.text).toContain('This is a generated');
  });

  test('invalid api key produces ProviderError', async () => {
    nock(openaiHost).post(path).reply(401, { error: 'invalid_api_key' });
    await expect(generateSectionFromProvider('q', 'Simple Answer', 'Quick')).rejects.toThrow();
  });

  test('rate limit leads to ProviderError after retries', async () => {
    // simulate 429 responses exceeding retry limit
    nock(openaiHost)
      .post(path)
      .times(3)
      .reply(429, { error: 'rate_limited' });

    await expect(generateSectionFromProvider('q', 'Explanation', 'Quick')).rejects.toThrow();
  });

  test('malformed response is handled', async () => {
    nock(openaiHost).post(path).reply(200, { no_choices: true });
    await expect(generateSectionFromProvider('q', 'Example', 'Quick')).rejects.toThrow();
  });
});
