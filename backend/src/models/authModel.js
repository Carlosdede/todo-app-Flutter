import { query } from "../db.js";

export async function getUserByEmail(email) {
  const result = await query(
    "SELECT id, name, email, password_hash FROM users WHERE email = $1",
    [email]
  );
  return result.rows[0];
}

export async function createUser(name, email, passwordHash) {
  const result = await query(
    "INSERT INTO users (name, email, password_hash) VALUES ($1, $2, $3) RETURNING id, name, email",
    [name, email, passwordHash]
  );
  return result.rows[0];
}
