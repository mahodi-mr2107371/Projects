const mongoose = require('mongoose');
const UserRepository = require('./repositories/userRepository');
const users = require('./data/users');

mongoose.connect('mongodb://localhost:27017/conference_management', { useNewUrlParser: true, useUnifiedTopology: true });

const userRepository = new UserRepository();

async function seed() {
  try {
    await userRepository.createIndexes(); 
    for (const userData of users) {
      const existingUser = await userRepository.findUserByEmail(userData.email);
      if (!existingUser) {
        await userRepository.createUser(userData);
      }
    }

    console.log('Database seeded successfully');
    process.exit();
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

seed();