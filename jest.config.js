module.exports = {
  roots: ["<rootDir>/src"],
  preset: "ts-jest",
  testEnvironment: "node",
  snapshotSerializers: ["jest-serializer-graphql-schema"],
};
