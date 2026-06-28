import { RAGResult } from '../rag/ragManager';

interface PromptBuilderParams {
  userMessage: string;
  language: string;
  conversationHistory: Array<any>;
  personality?: any;
  memory: Record<string, any>;
  ragResults: RAGResult[];
  options?: Record<string, any>;
}

const promptBuilder = {
  build: async (params: PromptBuilderParams) => {
    const { userMessage, language, conversationHistory, personality, memory, ragResults, options } = params;
    const lines: string[] = [];
    lines.push('Assistant: Dharma');
    lines.push(`Language: ${language}`);
    if (personality && personality.id) lines.push(`Personality: ${personality.id}`);
    lines.push('Instructions:');
    if (personality && personality.systemPrompt) lines.push(personality.systemPrompt.replace(/\n/g, ' '));

    if (Object.keys(memory || {}).length > 0) {
      lines.push('Memory:');
      for (const k of Object.keys(memory)) lines.push(`- ${k}: ${JSON.stringify(memory[k])}`);
    }

    if ((ragResults || []).length > 0) {
      lines.push('Relevant sources:');
      for (const r of ragResults) {
        lines.push(`Source: ${r.sourceId} (${r.type})`);
        lines.push(r.excerpt);
      }
    }

    if ((conversationHistory || []).length > 0) {
      lines.push('Conversation history:');
      const recent = conversationHistory.slice(-6);
      for (const m of recent) {
        const who = m.fromUser ? 'User' : 'Assistant';
        lines.push(`${who}: ${m.text}`);
      }
    }

    lines.push(`User: ${userMessage}`);
    const pref = options?.preferred_length || 'medium';
    const mood = options?.mood || 'neutral';
    lines.push(`Preferences: length=${pref}, mood=${mood}`);
    lines.push('Safety: When discussing scriptures (Bhagavad Gita, Ramayanam, Mahabharatam) separate verified scripture, traditional interpretation, and modern explanation. Do not invent verses.');

    return lines.join('\n');
  }
};

export default promptBuilder;
