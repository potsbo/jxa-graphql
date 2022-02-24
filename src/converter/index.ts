import execa from "execa";
import { parseStringPromise } from "xml2js";
import { print, lexicographicSortSchema, buildASTSchema, DocumentNode, DefinitionNode } from "graphql";
import { pruneSchema } from "@graphql-tools/utils";
import { Sdef } from "./sdef";
import { ConnectionInterface, EdgeInterface, NodeInterface } from "./constants";
import gql from "graphql-tag";
import { normalize } from "../normalize";
import { parseSuites } from "./suite";

const getBuilders = async (appPath: string) => {
  const sdefCmdResult = await execa("sdef", [appPath]);
  const sdef = (await parseStringPromise(sdefCmdResult.stdout)) as Sdef;
  return parseSuites(sdef);
};

const getBuildersFromFile = async (filepath: string) => {
  const content = await execa("cat", [filepath]);
  const sdef = (await parseStringPromise(content.stdout)) as Sdef;
  return parseSuites(sdef);
};

export const build = async (appPath: string, override?: DocumentNode) => {
  let { builders, includes } = await getBuilders(appPath);
  while (includes.length > 0) {
    for (const i of includes) {
      const { builders: bs, includes: is } = await getBuildersFromFile(i);
      includes = is;
      builders = [...builders, ...bs];
    }
  }

  const env = { builders, override };

  const definitions: DefinitionNode[] = [ConnectionInterface, EdgeInterface, NodeInterface];
  builders.forEach((b) => {
    definitions.push(...b.build(env));
  });

  const schema = gql`
    type Query {
      application: Application!
    }
    type Mutation

    ${definitions.map(print).join("\n")}

    # https://relay.dev/graphql/connections.htm#sec-undefined.PageInfo
    type PageInfo {
      hasPreviousPage: Boolean!
      hasNextPage: Boolean!
      startCursor: String!
      endCursor: String!
    }

    directive @recordType on OBJECT
    directive @extractFromObjectDisplayName on FIELD_DEFINITION

    input Condition {
      enabled: Boolean! = true
      field: String
      operands: [Condition!]
      operator: String! = "="
      value: String! = "true"
    }

    ${override ? print(override) : ""}
  `;

  return lexicographicSortSchema(pruneSchema(buildASTSchema(normalize(schema))));
};
