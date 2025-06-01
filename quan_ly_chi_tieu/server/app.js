const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const expensesRouter = require('./routes/expenses');
const authRouter = require('./routes/auth'); // Import routes from auth.js
const userRouter = require('./routes/user'); // Import routes from user.js
const config = require('./config');

const app = express();

// Kết nối đến MongoDB
mongoose.connect(config.mongoURI, {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => console.log('MongoDB connected...'))
.catch(err => console.log(err));

app.use(cors());
app.use(bodyParser.json());
app.use('/expenses', expensesRouter);
app.use('/auth', authRouter); // Use auth routes
app.use('/user', userRouter); // Use user routes

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server started on port ${PORT}`));
