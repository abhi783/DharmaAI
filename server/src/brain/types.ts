export type IntentResult = {
  intent: string;
  confidence: number;
};

export type EmotionResult = {
  emotion: string;
  confidence: number;
};

export type CategoryResult = {
  category: string;
  confidence: number;
};

export type PreprocessResult = {
  userMessage: string;
  language: string;
  intent: IntentResult;
  emotion: EmotionResult;
  category: CategoryResult;
  memory: Record<string, any>;
  ragResults: Array<{ sourceId: string; type: string; excerpt: string }>;
  personalityId?: string;
};

export type PostprocessResult = {
  finalText: string;
  validated: boolean;
  issues: string[];
  quality: {
    accuracy: number;
    helpfulness: number;
    friendliness: number;
    safety: number;
    readability: number;
    overall: number;
  };
};
