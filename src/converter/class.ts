import { DefinitionNode, FieldDefinitionNode, InterfaceTypeDefinitionNode, Kind } from "graphql";
import camelCase from "camelcase";
import { collectFieldsDefinitions, field } from "./field";
import { ClassDefinition, Environment } from "./sdef";
import { named as named, nonNull, list } from "./types";
import { EDGE_TYPE_NAME, CONNECTION_TYPE_NAME, NodeInterface } from "./constants";
import { name } from "./name";
import { objectType } from "./object";

const complementId = (fields: FieldDefinitionNode[]): FieldDefinitionNode[] => {
  if (fields.some((f) => f.name.value === "id")) {
    return fields;
  }

  return [
    ...fields,
    field("id", nonNull("ID"), {
      directives: [
        {
          kind: Kind.DIRECTIVE,
          name: name("extractFromObjectDisplayName"),
        },
      ],
    }),
  ];
};

export class ClassBuilder {
  private c: ClassDefinition;
  private fields: FieldDefinitionNode[];
  constructor(c: ClassDefinition) {
    this.c = c;
    this.fields = collectFieldsDefinitions(this.c);
  }
  private getBaseTypeName = () => camelCase(this.c.$.name, { pascalCase: true });
  private getClassName = () => this.c.$.name;
  private getInherits = () => this.c.$.inherits;
  private getInterfaceName = () => `${this.getBaseTypeName()}Interface`;
  private getInterfaced = (fields: FieldDefinitionNode[]): InterfaceTypeDefinitionNode => {
    return {
      kind: Kind.INTERFACE_TYPE_DEFINITION,
      fields,
      name: name(this.getInterfaceName(), { pascalCase: true }),
      interfaces: [named(NodeInterface.name.value)],
    };
  };
  private getAncestors = (classBuilders: ClassBuilder[]): ClassBuilder[] => {
    const inherits = this.getInherits();
    const parent = classBuilders.find((t) => t.getClassName() === inherits);
    if (inherits !== undefined && parent === undefined) {
      /* istanbul ignore next */
      throw new Error("parent not found");
    }
    if (parent === undefined) {
      return [];
    }
    return [...parent.getAncestors(classBuilders), parent];
  };

  build = ({ override, builders }: Environment): DefinitionNode[] => {
    const typeName = camelCase(this.c.$.name, { pascalCase: true });

    // TODO: if compatible override given, try to merge
    if (override?.definitions.some((d) => "name" in d && d.name?.value === typeName)) {
      return [];
    }

    const classBuilders = builders.filter((b): b is ClassBuilder => b instanceof ClassBuilder);
    const ancestors = this.getAncestors(classBuilders);

    const inherited = classBuilders.map((c) => c.getInherits()).some((c): c is string => c === this.getClassName());

    const fields = complementId(
      [...ancestors, this].reduce((acum: FieldDefinitionNode[], cur) => {
        return [...acum, ...cur.fields];
      }, [])
    );

    const interfaces: string[] = [NodeInterface.name.value, ...ancestors.map((a) => a.getInterfaceName())];
    if (inherited) {
      interfaces.push(this.getInterfaceName());
    }

    const classDef = objectType(typeName, fields, { description: this.c.$.description, interfaces });
    const edgeDef = objectType(
      `${typeName}${EDGE_TYPE_NAME}`,
      [field("cursor", nonNull("String")), field("node", nonNull(inherited ? this.getInterfaceName() : typeName))],
      { interfaces: [EDGE_TYPE_NAME] }
    );
    const connectionDef = objectType(
      `${typeName}${CONNECTION_TYPE_NAME}`,
      [
        field("byId", named(inherited ? this.getInterfaceName() : typeName), {
          arguments: [
            {
              kind: Kind.INPUT_VALUE_DEFINITION,
              name: name("id"),
              type: nonNull("ID"),
            },
          ],
        }),
        field("edges", nonNull(list(nonNull(`${typeName}${EDGE_TYPE_NAME}`)))),
        field("pageInfo", nonNull("PageInfo")),
      ],
      {
        interfaces: [CONNECTION_TYPE_NAME],
      }
    );
    return [connectionDef, edgeDef, classDef, this.getInterfaced(fields)];
  };
}
