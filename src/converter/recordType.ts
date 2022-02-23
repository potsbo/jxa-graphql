import { ObjectTypeDefinitionNode } from "graphql";
import { collectFieldsDefinitions } from "./field";
import { Environment, RecordTypeDefinition } from "./sdef";
import { objectType } from "./object";

export class RecordTypeBuilder {
  private e: RecordTypeDefinition;
  constructor(e: RecordTypeDefinition) {
    this.e = e;
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  build = (_: Environment): ObjectTypeDefinitionNode[] => {
    const fields = collectFieldsDefinitions(this.e);
    return [objectType(this.e.$.name, fields, { directives: ["recordType"] })];
  };
}
