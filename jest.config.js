module.exports = {
  roots: ["<rootDir>/src"],
  preset: "ts-jest",
  testEnvironment: "node",
  snapshotSerializers: ["jest-serializer-graphql-schema"],
  // jxalib will be passed to `eval`. Without ignoring, jest will insert code that can't work with `eval`
  // related issue: https://github.com/facebook/jest/issues/7962#issuecomment-466647531
  coveragePathIgnorePatterns: ["<rootDir>/node_modules/", "<rootDir>/src/compiler/jxalib/"],
};
