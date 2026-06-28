import { IntentResult } from './types';

const intents = [
  'Question',
  'Advice',
  'Emotional Support',
  'Career',
  'Relationship',
  'Health',
  'Education',
  'Programming',
  'Spiritual',
  'Finance',
  'Motivation',
  'Casual Chat',
  'Greeting',
  'Summarization',
  'Translation',
  'Creative Writing',
  'General Knowledge',
];

function scoreFromMatch(matches: number, total: number) {
  if (total == 0) return 0.0;
  return Math.max(0.2, Math.min(1.0, matches / total));
}

export default {
  detect: (text: string): IntentResult => {
    const t = text.toLowerCase();
    let best: IntentResult = { intent: 'General Knowledge', confidence: 0.35 };

    // simple keyword heuristics
    const mapping: Record<string, string[]> = {
      Question: ['what', 'who', 'when', 'where', 'why', 'how', '?'],
      Advice: ['should i', 'how do i', 'advice', 'recommend'],
      'Emotional Support': ['i am sad', "i'm sad", 'depressed', 'lonely', 'upset', 'help me'],
      Career: ['resume', 'interview', 'job', 'career', 'promotion'],
      Relationship: ['partner', 'relationship', 'breakup', 'marriage', 'wife', 'husband'],
      Health: ['fever', 'diet', 'exercise', 'doctor', 'health'],
      Education: ['study', 'exam', 'homework', 'learn', 'course'],
      Programming: ['flutter', 'dart', 'python', 'javascript', 'code', 'bug', 'compile'],
      Spiritual: ['bhagavad', 'gita', 'ramayan', 'mahabharata', 'ramayanam'],
      Finance: ['money', 'invest', 'stock', 'income', 'salary'],
      Motivation: ['motivate', 'motivated', 'inspire', 'inspiration'],
      Greeting: ['namaste', 'hello', 'hi', 'hey'],
      Summarization: ['summarize', 'summary', 'tl;dr', 'shortly'],
      Translation: ['translate', 'meaning of', 'meaning'],
      'Creative Writing': ['poem', 'story', 'write', 'compose'],
    };

    for (const k of Object.keys(mapping)) {
      const keywords = mapping[k];
      let matches = 0;
      for (const kw of keywords) if (t.includes(kw)) matches++;
      if (matches > 0) {
        const conf = Math.min(0.99, 0.3 + matches / keywords.length);
        best = { intent: k, confidence: conf };
        break;
      }
    }

    return best;
  }
};
