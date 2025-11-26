import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

import { getUserByEmail, createUser } from "../models/authModel.js";

const JWT_SECRET = process.env.JWT_SECRET;

function generateToken(userId) {
  return jwt.sign({ id: userId }, JWT_SECRET, { expiresIn: "7d" });
}

export async function register(req, res) {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password)
      return res
        .status(400)
        .json({ message: "Nome, email e senha são obrigatórios." });

    const existing = await getUserByEmail(email);
    if (existing)
      return res.status(400).json({ message: "Email já está em uso." });

    const passwordHash = await bcrypt.hash(password, 10);

    const user = await createUser(name, email, passwordHash);
    const token = generateToken(user.id);

    return res.status(201).json({ user, token });
  } catch (err) {
    console.error("Erro no registro:", err);
    return res.status(500).json({ message: "Erro ao registrar usuário." });
  }
}

export async function login(req, res) {
  try {
    const { email, password } = req.body;

    const user = await getUserByEmail(email);
    if (!user)
      return res.status(400).json({ message: "Credenciais inválidas." });

    const valid = await bcrypt.compare(password, user.password_hash);
    if (!valid)
      return res.status(400).json({ message: "Credenciais inválidas." });

    const token = generateToken(user.id);

    delete user.password_hash;

    return res.json({ user, token });
  } catch (err) {
    console.error("Erro no login:", err);
    return res.status(500).json({ message: "Erro ao fazer login." });
  }
}
