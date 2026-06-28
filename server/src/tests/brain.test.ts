import request from 'supertest';
import express from 'express';
import brain from '../brain/index';

describe('brain preprocess', () => {
  it('detects intent and emotion', async () => {
    const res = await brain.preprocess({ userMessage: 'Namaste, I am feeling sad today and need advice', language: 'te' });
    expect(res.intent.intent).toBeDefined();
    expect(res.emotion.emotion).toBeDefined();
    expect(res.memory).toBeDefined();
  });
});
