import { PostprocessResult } from './types';

export default {
  format: (text: string, opts?: { language?: string; keepEmoji?: boolean }): string => {
    const lang = opts?.language || 'te';
    let out = text.trim();

    // For Telugu language preference, break into short paragraphs (~40-60 words)
    if (lang === 'te') {
      const words = out.split(/\s+/);
      const chunks: string[] = [];
      let cur: string[] = [];
      for (let i = 0; i < words.length; i++) {
        cur.push(words[i]);
        if (cur.length >= 45) { chunks.push(cur.join(' ')); cur = []; }
      }
      if (cur.length > 0) chunks.push(cur.join(' '));
      out = chunks.join('\n\n');
    } else {
      // For English or mixed, keep paragraphs but trim long ones
      const paras = out.split(/\n{2,}/).map(p => p.trim());
      out = paras.map(p => p.split(' ').length > 120 ? p.split(' ').slice(0, 120).join(' ') + '...' : p).join('\n\n');
    }

    // Light emoji policy: add a smile at end if not present and short answer
    if (opts?.keepEmoji ?? true) {
      if (out.length < 140 && !/[\u{1F600}-\u{1F64F}]/u.test(out)) out = out + ' 🙂';
    }

    // Enforce conversation style: Understand - Explain - Example - Follow-up
    // Try to split into sentences and structure
    const sentences = out.split(/(?<=[.?!])\s+/);
    if (sentences.length > 3) {
      const first = sentences.slice(0, Math.min(2, sentences.length)).join(' ');
      const second = sentences.slice(2, Math.min(6, sentences.length)).join(' ');
      const rest = sentences.slice(6).join(' ');
      out = [first, second, rest].filter(s => s.trim().length > 0).join('\n\n');
    }

    return out;
  }
};
