// Load environment variables from .env file
require('dotenv').config();

const express = require('express');
const mysql = require('mysql2');  // Using mysql2 for better compatibility
const app = express();

// Logging environment variables to ensure they are loaded correctly
console.log('Database Host:', process.env.DB_HOST);
console.log('Database User:', process.env.DB_USER);
console.log('Database Password:', process.env.DB_PASS);
console.log('Database Name:', process.env.DB_NAME);

// MySQL connection setup using environment variables from the .env file
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME
});

// Connect to the database and handle any connection errors
db.connect((err) => {
  if (err) {
    console.error('Database connection failed: ' + err.stack);
    return;
  }
  console.log('Connected to database.');
});

// Middleware to parse JSON requests
app.use(express.json());

// Question 1: Retrieve all patients
app.get('/patients', (req, res) => {
  const sql = 'SELECT patient_id, first_name, last_name, date_of_birth FROM patients';
  db.query(sql, (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(result);
  });
});

// Question 2: Retrieve all providers
app.get('/providers', (req, res) => {
  const sql = 'SELECT first_name, last_name, provider_specialty FROM providers';
  db.query(sql, (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(result);
  });
});

// Question 3: Filter patients by first name
app.get('/patients/filter', (req, res) => {
  const firstName = req.query.first_name;
  const sql = 'SELECT patient_id, first_name, last_name, date_of_birth FROM patients WHERE first_name = ?';
  db.query(sql, [firstName], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(result);
  });
});

// Question 4: Retrieve all providers by specialty
app.get('/providers/filter', (req, res) => {
  const specialty = req.query.provider_specialty;
  const sql = 'SELECT first_name, last_name, provider_specialty FROM providers WHERE provider_specialty = ?';
  db.query(sql, [specialty], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(result);
  });
});

// Listen to the server using the PORT from the .env file or default to 3000
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
