import { PostprocessResult } from './types';

function countLongParagraphs(text: string) {
  finalParagraphs:
  {
    const paras = text.split(/\n{2,}/);
    let count = 0;
    for (const p of paras) {
      if (p.split(' ').length > 120) count++;
    }
    return count;
  }
}

function hasBrokenCodeFence(text: string) {
  const fences = (text.match(/```/g) || []).length;
  return fences % 2 !== 0;
}

function isRepeated(prev: string | undefined, current: string) {
  if (!prev) return false;
  return prev.trim() === current.trim();
}

export default {
  validate: (responseText: string, context?: { previousAssistant?: string }): PostprocessResult => {
    const issues: string[] = [];
    let validated = true;
    const text = responseText || '';

    if (text.trim().length == 0) {
      issues.push('empty_response');
      validated = false;
    }

    // very naive hallucination risk: presence of fabricated verse markers like "Verse 3.12" without source
    if (/verse\s*\d+/i.test(text) && !/bhagavad|gita|mahabharat|ramayan/i.test(text)) {
      issues.push('possible_hallucination');
    }

    if (hasBrokenCodeFence(text)) {
      issues.push('broken_markdown');
      validated = false;
    }

    if (countLongParagraphs(text) > 0) {
      issues.push('long_paragraphs');
    }

    if (isRepeated(context?.previousAssistant, text)) {
      issues.push('repeated_response');
      validated = false;
    }

    // safety: simple banned words list (expand in prod)
    const banned = ['hate speech sample'];
    for (const b of banned) if (text.toLowerCase().includes(b)) { issues.push('unsafe_content'); validated = false; }

    // Attempt mild rewrites for readability if only minor issues
    let finalText = text;
    if (!validated && issues.indexOf('broken_markdown') !== -1) {
      // try to close code fences by appending ```
      if ((text.match(/```/g) || []).length % 2 !== 0) finalText = text + '\n```';
    }

    // shorten very long paragraphs
    if (issues.includes('long_paragraphs')) {
      const paras = finalText.split(/\n{2,}/).map(p => p.trim());
      const shortened = paras.map(p => p.split(' ').length > 90 ? p.split(' ').slice(0, 90).join(' ') + '...' : p);
      finalText = shortened.join('\n\n');
    }

    // if still invalid and critical, replace with safe fallback
    if (!validated && issues.includes('empty_response')) {
      finalText = 'I\'m sorry, I could not generate a response. Could you please rephrase?';
    }

    // Build quality metrics (naive heuristics)
    const quality = {
      accuracy: issues.includes('possible_hallucination') ? 0.5 : 0.9,
      helpfulness: 0.8,
      friendliness: 0.9,
      safety: issues.includes('unsafe_content') ? 0.2 : 0.95,
      readability: issues.includes('long_paragraphs') ? 0.6 : 0.95,
      overall: 0.0,
    };
    // weighted overall
    quality.overall = (quality.accuracy * 0.35 + quality.helpfulness * 0.25 + quality.friendliness * 0.15 + quality.safety * 0.15 + quality.readability * 0.1);

    return { finalText, validated: validated && issues.length === 0, issues, quality } as PostprocessResult;
  }
};
