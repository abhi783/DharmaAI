import request from 'supertest';
import express from 'express';
import chatRouter from '../routes/chat';

const app = express();
app.use(express.json());
app.use('/v1/chat', chatRouter);

describe('chat route', () => {
  it('returns 401 without token on /', async () => {
    const res = await request(app).post('/v1/chat').send({ userMessage: 'hello' });
    expect(res.status).toBe(401);
  });
});
