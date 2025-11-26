import { query } from "../db.js";

export async function getTodosByUser(userId) {
  const result = await query(
    "SELECT id, title, done, created_at FROM todo WHERE user_id = $1 ORDER BY id DESC",
    [userId]
  );
  return result.rows;
}

export async function createTodo(title, userId) {
  const result = await query(
    "INSERT INTO todo (title, user_id) VALUES ($1, $2) RETURNING id, title, done, created_at",
    [title, userId]
  );
  return result.rows[0];
}

export async function toggleTodoById(id, userId) {
  const result = await query(
    `UPDATE todo 
     SET done = NOT done 
     WHERE id = $1 AND user_id = $2 
     RETURNING id, title, done, created_at`,
    [id, userId]
  );
  return result.rows[0];
}

export async function deleteTodoById(id, userId) {
  const result = await query(
    "DELETE FROM todo WHERE id = $1 AND user_id = $2 RETURNING id",
    [id, userId]
  );
  return result.rows[0];
}
