import express from "express";

import {
  getTodos,
  createTodo,
  toggleTodo,
  deleteTodo,
} from "../controllers/todoController.js";

import authMiddleware from "../middleware/authMiddleware.js";

const router = express.Router();

// Todas as rotas abaixo exigem token JWT
router.use(authMiddleware);

// Listar tarefas
router.get("/", getTodos);

// Criar tarefa
router.post("/", createTodo);

// Alternar done
router.put("/:id/toggle", toggleTodo);

// Deletar tarefa
router.delete("/:id", deleteTodo);

export default router;
