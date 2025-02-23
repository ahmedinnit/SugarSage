const express = require("express");
const { loginUser } = require("../controllers/auth/loginController");
const { signupUser } = require("../controllers/auth/signupController");

const router = express.Router();

// Login Route
router.post("/login", loginUser);

// Signup Route
router.post("/signup", signupUser);

module.exports = router;
