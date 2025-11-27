import pg from "pg";

const { Pool } = pg;

export const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  database: process.env.DB_NAME,
  password: process.env.DB_PASS,
  port: process.env.DB_PORT,
  ssl: {
    rejectUnauthorized: false,
  },
});

export function query(text, params) {
  return pool.query(text, params);
}
