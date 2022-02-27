import { runJXACode } from "@jxa/run";
import { ApolloServer, ServerInfo } from "apollo-server";
import { build } from "./converter";
import { buildRootValue } from "./rootValue";
import { basename } from "path";
import yargs from "yargs";
import { hideBin } from "yargs/helpers";

const startServer = async (options: Readonly<{ appPath: string; port: number }>) => {
  const typeDefs = await build(options.appPath);
  const appName = basename(options.appPath).split(".").slice(0, -1).join(".");
  const rootValue = buildRootValue(appName, runJXACode);

  const server = new ApolloServer({ typeDefs, resolvers: { Query: rootValue } });
  return server.listen({ port: options.port });
};

export const run = (process: NodeJS.Process) => {
  return new Promise<ServerInfo>((resolve) => {
    yargs
      .command(
        "serve <appPath>",
        "start a GraphQL server for the given Application",
        (yargs) => {
          return yargs
            .positional("appPath", {
              describe: "Application path",
              demandOption: true,
              type: "string",
            })
            .option("port", {
              alias: "p",
              type: "number",
              default: 4000,
              description: "port number of the GraphQL server",
            });
        },
        async (argv) => {
          const info = await startServer(argv);
          process.stdout.write(`🚀  Server ready at ${info.url}`);
          resolve(info);
        }
      )
      .demandCommand(1)
      .parse(hideBin(process.argv));
  });
};
