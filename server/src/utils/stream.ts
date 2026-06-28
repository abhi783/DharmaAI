import { Readable } from 'stream';
import EventEmitter from 'events';

// Small helper to convert async iterator to Node stream-like EventEmitter
export function streamFromAsyncIterator(it: AsyncIterable<string>) {
  const emitter = new EventEmitter();
  (async () => {
    try {
      for await (const chunk of it) {
        emitter.emit('data', chunk);
      }
      emitter.emit('end');
    } catch (e) {
      emitter.emit('error', e);
    }
  })();
  return emitter;
}
