import { FieldDefinitionNode, ObjectTypeDefinitionNode, Kind } from "graphql";
import { name } from "./name";
import { stringValue } from "./string";
import { named } from "./types";

export const objectType = (
  typeName: string,
  fields: FieldDefinitionNode[],
  opts: {
    interfaces?: string[];
    description?: string;
    directives?: string[];
  } = {}
): ObjectTypeDefinitionNode => {
  return {
    kind: Kind.OBJECT_TYPE_DEFINITION,
    name: name(typeName, { pascalCase: true }),
    interfaces: opts.interfaces?.map((n) => named(n)),
    fields,
    description: stringValue(opts.description),
    directives: opts.directives?.map((n) => ({
      kind: Kind.DIRECTIVE,
      name: {
        kind: Kind.NAME,
        value: n,
      },
    })),
  };
};
