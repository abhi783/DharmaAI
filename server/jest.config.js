module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/server/src', '<rootDir>/server/tests'],
  testMatch: ['**/?(*.)+(spec|test).ts']
};
