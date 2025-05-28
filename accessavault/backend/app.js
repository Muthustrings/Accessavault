const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
app.use(bodyParser.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'root',
  database: 'accessavault_db'
});

db.connect((err) => {
  if (err) throw err;
  console.log('Connected to MySQL');
});

// USERS CRUD
app.get('/users', (req, res) => {
  db.query('SELECT * FROM users', (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results);
  });
});

app.post('/users', (req, res) => {
  const { name, email, role, status } = req.body;
  // Correcting the column name for full name in the database to 'fullName' based on the error
  db.query('INSERT INTO users (fullName, email, role, status) VALUES (?, ?, ?, ?)', [name, email, role, status], (err, result) => {
    if (err) return res.status(500).json({ error: err });
    // Return the inserted user data, using 'name' as it's sent from the frontend
    res.json({ id: result.insertId, name, email, role, status });
  });
});

app.get('/users/:id', (req, res) => {
  db.query('SELECT * FROM users WHERE id = ?', [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results[0]);
  });
});

app.put('/users/:id', (req, res) => {
  const { name, email, role, status } = req.body;
  db.query('UPDATE users SET name=?, email=?, role=?, status=? WHERE id=?', [name, email, role, status, req.params.id], (err) => {
    if (err) return res.status(500).json({ error: err });
    res.json({ id: req.params.id, name, email, role, status });
  });
});

app.delete('/users/:id', (req, res) => {
  db.query('DELETE FROM users WHERE id=?', [req.params.id], (err) => {
    if (err) return res.status(500).json({ error: err });
    res.json({ success: true });
  });
});

// ROLES CRUD
app.get('/roles', (req, res) => {
  db.query('SELECT * FROM roles', (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results);
  });
});

app.post('/roles', (req, res) => {
  const { name, description } = req.body;
  db.query('INSERT INTO roles (name, description) VALUES (?, ?)', [name, description], (err, result) => {
    if (err) return res.status(500).json({ error: err });
    res.json({ id: result.insertId, name, description });
  });
});

// GROUPS CRUD
app.get('/groups', (req, res) => {
  db.query('SELECT * FROM `groups`', (err, results) => {
    if (err) return res.status(500).json({ error: err });
    res.json(results);
  });
});

app.post('/groups', (req, res) => {
  const { group_name, description } = req.body;
  db.query('INSERT INTO `groups` (group_name, description) VALUES (?, ?)', [group_name, description], (err, result) => {
    if (err) return res.status(500).json({ error: err });
    res.json({ id: result.insertId, group_name, description });
  });
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
