import {
  getTodosByUser,
  createTodo as createTodoModel,
  toggleTodoById,
  deleteTodoById,
} from "../models/todoModel.js";

export async function getTodos(req, res) {
  try {
    const todos = await getTodosByUser(req.userId);
    return res.json(todos);
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: "Erro ao buscar tarefas." });
  }
}

export async function createTodo(req, res) {
  try {
    const { title } = req.body;

    if (!title || title.trim() === "") {
      return res.status(400).json({ message: "Título é obrigatório." });
    }

    const todo = await createTodoModel(title, req.userId);
    return res.status(201).json(todo);
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: "Erro ao criar tarefa." });
  }
}

export async function toggleTodo(req, res) {
  try {
    const { id } = req.params;

    const updated = await toggleTodoById(id, req.userId);
    if (!updated) {
      return res.status(404).json({ message: "Tarefa não encontrada." });
    }

    return res.json(updated);
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: "Erro ao atualizar tarefa." });
  }
}

export async function deleteTodo(req, res) {
  try {
    const { id } = req.params;

    const deleted = await deleteTodoById(id, req.userId);
    if (!deleted) {
      return res.status(404).json({ message: "Tarefa não encontrada." });
    }

    return res.json({ success: true });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: "Erro ao deletar tarefa." });
  }
}
