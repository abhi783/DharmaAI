import responseValidator from './responseValidator';
import formatter from './formatter';
import intentDetector from './intentDetector';
import emotionDetector from './emotionDetector';
import categoryEngine from './categoryEngine';
import { PreprocessResult, PostprocessResult } from './types';
import MemoryManager from '../memory/memoryManager';
import RAGManager from '../rag/ragManager';

const memory = new MemoryManager();
const rag = new RAGManager();

export async function preprocess(params: { userMessage: string; language?: string; personalityId?: string; conversationHistory?: any[] }): Promise<PreprocessResult> {
  const language = params.language || 'te';
  const intent = intentDetector.detect(params.userMessage);
  const emotion = emotionDetector.detect(params.userMessage);
  const category = categoryEngine.detect(params.userMessage);
  const memorySnapshot = await memory.filteredMemoryForPrompt();
  const ragResults = await rag.searchRelevant(params.userMessage);

  return {
    userMessage: params.userMessage,
    language,
    intent,
    emotion,
    category,
    memory: memorySnapshot,
    ragResults,
    personalityId: params.personalityId,
  } as PreprocessResult;
}

export async function postprocess(responseText: string, context?: { previousAssistant?: string; language?: string }): Promise<PostprocessResult> {
  // run validator
  const validation = responseValidator.validate(responseText, { previousAssistant: context?.previousAssistant });
  // format final text for presentation
  const formatted = formatter.format(validation.finalText, { language: context?.language, keepEmoji: true });
  // replace finalText and return combined result
  validation.finalText = formatted;
  return validation;
}

export default { preprocess, postprocess };
