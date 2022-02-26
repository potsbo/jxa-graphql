#!/usr/bin/env node

import yargs from "yargs/yargs";
import { hideBin } from "yargs/helpers";
import { run } from "./run";

yargs(hideBin(process.argv))
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
    run
  )
  .demandCommand(1)
  .parse();
