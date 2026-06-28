import {LearningStyle} from './types';

// Lightweight learning style detection. Uses heuristics and request metadata.
export function detectLearningStyle(text: string | undefined, explicit?: string): LearningStyle {
  if (explicit) {
    const s = explicit.toLowerCase();
    if (s.includes('quick')) return 'Quick';
    if (s.includes('detailed')) return 'Detailed';
    if (s.includes('story')) return 'Story';
    if (s.includes('teacher')) return 'Teacher';
    if (s.includes('practical')) return 'Practical';
    if (s.includes('kids')) return 'Kids';
    if (s.includes('visual')) return 'Visual';
  }
  const t = (text || '').toLowerCase();
  if (t.includes('story') || t.includes('కథ')) return 'Story';
  if (t.includes('simple') || t.includes('quick') || t.includes('సరళ')) return 'Quick';
  if (t.includes('practical') || t.includes('use') || t.includes('ఉపాయ')) return 'Practical';
  if (t.includes('kids') || t.includes('children') || t.includes('పిల్లలు')) return 'Kids';
  // default
  return 'Detailed';
}
