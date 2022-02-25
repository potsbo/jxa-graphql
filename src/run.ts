import express from "express";
import { graphqlHTTP } from "express-graphql";
import { basename } from "path";
import { runJXACode } from "@jxa/run";
import { build } from "./converter";
import { buildRootValue } from "./rootValue";

export const run = async (options: Readonly<{ appPath: string; port: number; graphiql: boolean }>) => {
  const schema = await build(options.appPath);
  const appName = basename(options.appPath).split(".").slice(0, -1).join(".");
  const rootValue = buildRootValue(appName, runJXACode);

  const app = express();
  app.use("/graphql", graphqlHTTP({ schema, rootValue, graphiql: options.graphiql }));
  app.listen(options.port);
  console.log(`Running a GraphQL API server at http://localhost:${options.port}/graphql`);
};
