const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const { pool } = require('./db/pool');
const { notFoundHandler, errorHandler } = require('./middleware/errorHandler');

const app = express();

app.use(cors());
app.use(morgan(process.env.NODE_ENV === 'production' ? 'combined' : 'dev'));
app.use(express.json());

app.get('/health', async (req, res, next) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok', db: 'connected' });
  } catch (err) {
    next(err);
  }
});

// Feature routes are mounted here as each phase lands:
//   app.use('/api/v1/auth', require('./routes/auth.routes'));
//   app.use('/api/v1/complaints', require('./routes/complaints.routes'));
//   app.use('/api/v1/feedback', require('./routes/feedback.routes'));
//   app.use('/api/v1/content', require('./routes/content.routes'));

app.use(notFoundHandler);
app.use(errorHandler);

module.exports = { app };
