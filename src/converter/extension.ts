import { FieldDefinitionNode, Kind, ObjectTypeExtensionNode } from "graphql";
import camelCase from "camelcase";
import { collectFieldsDefinitions } from "./field";
import { ClassExtensionDefinition, Environment } from "./sdef";

export class ExtensionBuilder {
  private e: ClassExtensionDefinition;
  readonly fields: FieldDefinitionNode[];
  readonly extends: string;

  constructor(e: ClassExtensionDefinition) {
    this.e = e;
    this.fields = collectFieldsDefinitions(this.e);
    this.extends = e.$.extends;
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  build = (_: Environment): ObjectTypeExtensionNode[] => {
    return [
      {
        kind: Kind.OBJECT_TYPE_EXTENSION,
        name: {
          kind: Kind.NAME,
          value: camelCase(this.e.$.extends, { pascalCase: true }),
        },
        fields: this.fields,
      },
    ];
  };
}
