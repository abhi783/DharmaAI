/**
 * Minimal personality engine for backend parity with client.
 */

class PersonalityEngine {
  private map: Record<string, any> = {};

  constructor() {
    this.map['dharma_default'] = { id: 'dharma_default', systemPrompt: `You are Dharma, a friendly Telugu AI companion. Use simple Telugu, be emotionally aware, humorous when appropriate, wise and respectful. Never invent verses.` };
    this.map['study_mode'] = { id: 'study_mode', systemPrompt: `You are Dharma in Study Mode. Provide step-by-step explanations.` };
    this.map['spiritual_mode'] = { id: 'spiritual_mode', systemPrompt: `You are Dharma in Spiritual Mode. Be reverent when discussing scriptures.` };
  }

  personalityForId(id: string) { return this.map[id] || this.map['dharma_default']; }
}

export default new PersonalityEngine();
