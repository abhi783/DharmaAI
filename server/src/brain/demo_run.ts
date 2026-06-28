import { preprocess, postprocess } from '../brain/index';

(async () => {
  const pre = await preprocess({ userMessage: 'How do I prepare for interviews?', language: 'en' });
  console.log('Preprocess:', pre.intent, pre.emotion, pre.category);
  const post = await postprocess('This is a mock response. It is long and contains many words.\n\nIt might have too long paragraphs that need wrapping.', { language: 'en' });
  console.log('Postprocess:', post);
})();
