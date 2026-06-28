export type Intent =
  | 'Conversation'
  | 'Teaching'
  | 'Story'
  | 'Reflection'
  | 'Quick Answer'
  | 'Motivation'
  | 'Translation'
  | 'Coding'
  | 'Search'
  | 'Creative Writing'
  | 'Life Guidance'
  | 'Prayer'
  | 'Meditation';

export type LearningStyle =
  | 'Quick'
  | 'Detailed'
  | 'Story'
  | 'Teacher'
  | 'Practical'
  | 'Kids'
  | 'Visual';

export interface ScriptureSource {
  id: string;
  title: string;
  type: string;
  chapter: number;
  verse: number;
  citation: string;
  language: string;
  translation?: string;
  translator?: string;
  verified: boolean;
  confidence: number; // 0..1
  copyright?: string;
  url?: string;
}

export interface TeachingSection {
  title: string;
  text: string;
  meta?: { source?: ScriptureSource } | null;
}

export interface TeachingResponse {
  simpleAnswer: TeachingSection;
  explanation: TeachingSection;
  example: TeachingSection;
  // optional scripture-related sections
  verifiedTeaching?: TeachingSection | null;
  traditionalInterpretation?: TeachingSection | null;
  modernApplication?: TeachingSection | null;
  summary: TeachingSection;
  reflectionQuestion: TeachingSection;
  relatedSuggestion?: TeachingSection | null;
}
