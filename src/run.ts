import { runJXACode } from "@jxa/run";
import { ApolloServer } from "apollo-server";
import { build } from "./converter";
import { buildRootValue } from "./rootValue";
import { basename } from "path";

export const run = async (options: Readonly<{ appPath: string; port: number }>) => {
  const typeDefs = await build(options.appPath);
  const appName = basename(options.appPath).split(".").slice(0, -1).join(".");
  const rootValue = buildRootValue(appName, runJXACode);

  const server = new ApolloServer({ typeDefs, resolvers: { Query: rootValue } });
  const { url } = await server.listen({ port: options.port });

  console.log(`🚀  Server ready at ${url}`);
};
