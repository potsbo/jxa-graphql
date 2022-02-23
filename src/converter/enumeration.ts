import { EnumTypeDefinitionNode, EnumValueDefinitionNode, Kind, StringValueNode } from "graphql";
import camelCase from "camelcase";
import { EnumDefinition, Environment } from "./sdef";

export class EnumBuilder {
  private e: EnumDefinition;
  constructor(e: EnumDefinition) {
    this.e = e;
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  build = (_: Environment): EnumTypeDefinitionNode[] => {
    const values: EnumValueDefinitionNode[] = this.e.enumerator.map((e) => {
      const desc: StringValueNode | undefined = e.$.description
        ? {
            kind: Kind.STRING,
            value: e.$.description,
            block: true,
          }
        : undefined;
      return {
        kind: Kind.ENUM_VALUE_DEFINITION,
        description: desc,
        name: {
          kind: Kind.NAME,
          value: e.$.name.replace(/ /g, "_").replace(/&/g, "_AND_").toUpperCase(),
        },
      };
    });
    return [
      {
        kind: Kind.ENUM_TYPE_DEFINITION,
        name: {
          kind: Kind.NAME,
          value: camelCase(this.e.$.name, { pascalCase: true }),
        },
        values,
      },
    ];
  };
}
