import { CategoryResult } from './types';

const categories = ['General AI', 'Scripture', 'Coding', 'Career', 'Learning', 'Health', 'Business', 'Motivation', 'Entertainment'];

export default {
  detect: (text: string): CategoryResult => {
    const t = text.toLowerCase();
    if (t.includes('gita') || t.includes('bhagavad') || t.includes('ramayan')) return { category: 'Scripture', confidence: 0.92 };
    if (t.includes('flutter') || t.includes('dart') || t.includes('python') || t.includes('code')) return { category: 'Coding', confidence: 0.95 };
    if (t.includes('job') || t.includes('resume') || t.includes('interview')) return { category: 'Career', confidence: 0.9 };
    if (t.includes('study') || t.includes('exam') || t.includes('learn')) return { category: 'Learning', confidence: 0.9 };
    if (t.includes('health') || t.includes('diet') || t.includes('exercise')) return { category: 'Health', confidence: 0.9 };
    if (t.includes('business') || t.includes('startup') || t.includes('invest')) return { category: 'Business', confidence: 0.85 };
    if (t.includes('motivate') || t.includes('inspire')) return { category: 'Motivation', confidence: 0.85 };
    return { category: 'General AI', confidence: 0.5 };
  }
};
