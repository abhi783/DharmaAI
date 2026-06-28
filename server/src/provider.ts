import axios, { AxiosError } from 'axios';
import { TeachingSection, ScriptureSource } from './types';

const OPENAI_API_KEY = process.env.OPENAI_API_KEY || process.env.PROVIDER_API_KEY;
const OPENAI_API_URL = process.env.OPENAI_API_URL || 'https://api.openai.com/v1/chat/completions';

// Provider-level retry policy for transient errors
const MAX_PROVIDER_RETRIES = 2; // retry up to 2 times on transient errors
const PROVIDER_TIMEOUT_MS = 20000; // 20s timeout for provider calls

class ProviderError extends Error {
  public code?: string;
  public status?: number;
  constructor(message: string, code?: string, status?: number) {
    super(message);
    this.code = code;
    this.status = status;
  }
}

function isTransientAxiosError(err: AxiosError) {
  if (!err) return false;
  if (err.code === 'ECONNABORTED') return true; // timeout
  if (!err.response) return true; // network error
  const status = err.response.status;
  if (status >= 500) return true; // server errors
  if (status === 429) return true; // rate limit - treat as transient (with caution)
  return false;
}

async function callProvider(prompt: string): Promise<string> {
  if (!OPENAI_API_KEY) {
    throw new ProviderError('Missing provider API key', 'invalid_api_key', 401);
  }

  let attempt = 0;
  while (true) {
    try {
      const resp = await axios.post(
        OPENAI_API_URL,
        {
          model: process.env.OPENAI_MODEL || 'gpt-4o-mini',
          messages: [
            { role: 'system', content: 'You are Dharma, an assistant that returns concise teaching sections. When asked, output only the content for the requested section in plain text. If the user asked about scripture and the provider can quote scripture, include a JSON object with a `source` field containing metadata.' },
            { role: 'user', content: prompt }
          ],
          temperature: 0.25,
          max_tokens: 800
        },
        {
          headers: {
            Authorization: `Bearer ${OPENAI_API_KEY}`,
            'Content-Type': 'application/json'
          },
          timeout: PROVIDER_TIMEOUT_MS
        }
      );

      // Expect structure: resp.data.choices[0].message.content
      const content = resp.data?.choices?.[0]?.message?.content;
      if (!content) throw new ProviderError('Provider returned malformed response (no content)', 'malformed_response', resp.status);
      return content as string;
    } catch (err: any) {
      if (axios.isAxiosError(err)) {
        const aerr = err as AxiosError;
        const status = aerr.response?.status;
        if (status === 401 || status === 403) {
          throw new ProviderError('Invalid provider API key or forbidden', 'invalid_api_key', status);
        }
        if (status === 429) {
          // rate limit - may retry
          attempt++;
          if (attempt > MAX_PROVIDER_RETRIES) {
            throw new ProviderError('Provider rate limit exceeded', 'rate_limited', 429);
          }
          // backoff
          await new Promise((r) => setTimeout(r, 500 * attempt));
          continue;
        }
        if (isTransientAxiosError(aerr)) {
          attempt++;
          if (attempt > MAX_PROVIDER_RETRIES) {
            throw new ProviderError('Provider unavailable or network error', 'provider_unavailable', status);
          }
          await new Promise((r) => setTimeout(r, 400 * attempt));
          continue;
        }
        // Non-transient - rethrow as ProviderError
        throw new ProviderError(aerr.message, 'provider_error', status);
      }

      // Unknown error
      throw new ProviderError(err?.toString() ?? 'Unknown provider error', 'provider_error');
    }
  }
}

function tryParseJsonSection(content: string): { text: string; meta?: { source?: ScriptureSource } } | null {
  // The provider may return either plain text or a JSON snippet.
  // Attempt to detect a JSON object in the response and parse it.
  const trimmed = content.trim();
  if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
    try {
      const obj = JSON.parse(trimmed);
      if (obj && typeof obj === 'object') {
        // Expect fields like text and meta.source optional
        const text = typeof obj.text === 'string' ? obj.text : (obj.content || '');
        const meta = obj.meta && typeof obj.meta === 'object' ? obj.meta : undefined;
        return { text, meta };
      }
    } catch (_) {
      return null;
    }
  }
  return null;
}

export async function generateSectionFromProvider(query: string, section: string, style: string): Promise<TeachingSection> {
  // Build a simple prompt template that instructs the provider to output the
  // requested section clearly. The prompt requests JSON only if the section is
  // scripture-related and asks for metadata.
  const isScripture = /gita|భగవద్గీత|ramayan|ramayanam|mahabharatam/i.test(query.toLowerCase());

  const prompt = isScripture
    ? `User query: "${query}"
Task: Produce a ${section} section in Telugu (or the query language). If the section contains a scripture quote, include a JSON object with 'text' and 'meta' fields where meta.source includes id, title, type, chapter, verse, citation, language, translation, translator, verified (boolean), confidence (0..1), copyright, url. Output only JSON when including the metadata.`
    : `User query: "${query}"
Task: Produce a ${section} section in a concise, clear style (${style}). Return only the text for the section.`;

  const raw = await callProvider(prompt);

  // If provider returned JSON, parse into structured object
  const parsed = tryParseJsonSection(raw);
  if (parsed) {
    return { title: section, text: parsed.text, meta: parsed.meta || null };
  }

  // Not JSON — use the plain text content
  // Fallback: ensure non-empty
  const text = raw.trim();
  return { title: section, text, meta: null };
}

export function validateSection(section: TeachingSection): { valid: boolean; score: number; issues?: string[] } {
  // Lightweight validation remains — production can add safety/attribution checks.
  const len = (section.text || '').trim().length;
  const valid = len > 20; // must be non-trivial
  const score = Math.min(1.0, len / 600.0 + 0.1);
  const issues = [] as string[];
  if (!valid) issues.push('too_short');
  return { valid, score, issues };
}
