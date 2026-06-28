import { EmotionResult } from './types';

const emotions = [
  'Happy',
  'Sad',
  'Stressed',
  'Confused',
  'Motivated',
  'Excited',
  'Lonely',
  'Angry',
  'Fear',
  'Hopeful',
];

export default {
  detect: (text: string): EmotionResult => {
    const t = text.toLowerCase();
    // heuristics
    if (/[!]{2,}/.test(text)) return { emotion: 'Excited', confidence: 0.6 };
    if (t.includes('happy') || t.contains?.('😊') || t.includes('😀')) return { emotion: 'Happy', confidence: 0.7 } as EmotionResult;

    const map: Record<string, string[]> = {
      Happy: ['happy', 'good', 'great', '😊', '😀'],
      Sad: ['sad', 'depressed', 'unhappy', '😢', '😭'],
      Stressed: ['stress', 'stressed', 'overwhelmed'],
      Confused: ['confused', "don't understand", 'how?'],
      Motivated: ['motivated', 'lets', 'let\'s do', 'i will'],
      Excited: ['excited', 'thrilled', 'wow', '!!'],
      Lonely: ['lonely', 'alone'],
      Angry: ['angry', 'mad', 'furious'],
      Fear: ['afraid', 'scared', 'fear'],
      Hopeful: ['hope', 'hopeful'],
    };

    for (const e of Object.keys(map)) {
      for (const kw of map[e]) {
        if (t.includes(kw)) return { emotion: e, confidence: 0.6 } as EmotionResult;
      }
    }

    return { emotion: 'Neutral', confidence: 0.3 } as EmotionResult;
  }
};
