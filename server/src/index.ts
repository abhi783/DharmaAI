import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';
import chatRouter from './routes/chat';
import authRouter from './routes/auth';

dotenv.config();

const app = express();
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '512kb' }));
app.use(morgan('combined'));

const WINDOW = parseInt(process.env.RATE_LIMIT_WINDOW_MS || '60000', 10);
const MAX = parseInt(process.env.RATE_LIMIT_MAX || '60', 10);
app.use(rateLimit({ windowMs: WINDOW, max: MAX }));

app.use('/v1/auth', authRouter);
app.use('/v1/chat', chatRouter);

app.get('/', (_req, res) => res.json({ status: 'ok', service: 'DharmaAI Backend' }));

const port = parseInt(process.env.PORT || '8080', 10);
app.listen(port, () => console.log(`DharmaAI backend listening on ${port}`));
