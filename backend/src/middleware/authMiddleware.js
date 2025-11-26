import jwt from "jsonwebtoken";
import dotenv from "dotenv";

dotenv.config();

const JWT_SECRET = process.env.JWT_SECRET;

export default function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader)
    return res.status(401).json({ message: "Token não fornecido." });

  const [bearer, token] = authHeader.split(" ");

  if (bearer !== "Bearer" || !token)
    return res.status(401).json({ message: "Token mal formatado." });

  try {
    const decoded = jwt.verify(token, JWT_SECRET);

    // ID do usuário disponível nas rotas
    req.userId = decoded.id;

    return next();
  } catch (err) {
    return res.status(401).json({ message: "Token inválido ou expirado." });
  }
}
