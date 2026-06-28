import {Intent} from './types';

// Very small intent classifier using keywords. Replaceable with ML model.
export function detectIntent(text: string): Intent {
  const t = text.toLowerCase();
  if (/teach|explain|శిక్ష|బోసో|ఉపాధ్యాయ/i.test(t) || t.includes('teach') || t.includes('explain') || t.includes('వివర') ) return 'Teaching';
  if (/story|కథ|రచన/.test(t)) return 'Story';
  if (/reflect|reflection|how was your day|రెఫ్లెక్షన్/.test(t)) return 'Reflection';
  if (/quick|short|సరళ/ .test(t)) return 'Quick Answer';
  if (/motivat|ఉత్సాహ|ప్రేరణ/.test(t)) return 'Motivation';
  if (/translate|అనువాద|translate to|translate from/.test(t)) return 'Translation';
  if (/code|program|function|class/.test(t)) return 'Coding';
  if (/search|find|సోధన/.test(t)) return 'Search';
  if (/write|story|poem|రచన|create/.test(t)) return 'Creative Writing';
  if (/guide|advice|salvation|జీవిత|life/.test(t)) return 'Life Guidance';
  if (/prayer|ప్రార్థన/.test(t)) return 'Prayer';
  if (/meditat|ధ్యానం|calm/.test(t)) return 'Meditation';
  return 'Conversation';
}
