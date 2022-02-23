import { Kind, NameNode } from "graphql";
import camelCase from "camelcase";

export const name = (n: string, opts: { pascalCase?: boolean } = {}): NameNode => {
  return {
    kind: Kind.NAME,
    value: camelCase(n, opts),
  };
};
