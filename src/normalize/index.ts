import {
  DefinitionNode,
  DocumentNode,
  FieldDefinitionNode,
  InputValueDefinitionNode,
  Kind,
  NameNode,
  print,
  TypeNode,
} from "graphql";
import { validateSDL } from "graphql/validation/validate";
import { compatibleType, identicalyNamed, implementsInterface, unwrapType } from "../graphql-utils";

const SCALARS = ["Int", "Float", "String", "Boolean", "ID"];

const isNonNull = <T>(t: T | null): t is T => {
  return t !== null;
};

type FieldLike = FieldDefinitionNode | InputValueDefinitionNode;

type NamedWithFields = {
  fields?: readonly FieldDefinitionNode[] | readonly InputValueDefinitionNode[];
  name: NameNode;
};
class Nomalizer {
  private readonly doc: DocumentNode;
  constructor(doc: DocumentNode) {
    this.doc = doc;
  }

  normalize = (depth: number): DocumentNode => {
    const doc = { ...this.doc, definitions: this.doc.definitions.map(this.pruneDefinition).filter(isNonNull) };
    const errors = validateSDL(doc);
    if (depth === 0) {
      if (errors.length > 0) {
        throw errors;
      }
      return doc;
    }

    if (print(new Nomalizer(doc).normalize(0)) === print(doc)) {
      return doc;
    }

    return new Nomalizer(doc).normalize(depth - 1);
  };

  private pruneInterfaces = <T extends DefinitionNode>(def: T): T | null => {
    if ("interfaces" in def) {
      return {
        ...def,
        interfaces: def.interfaces?.filter(this.definedType).filter((i) => {
          return implementsInterface(
            def,
            {
              kind: Kind.INTERFACE_TYPE_DEFINITION,
              fields: this.collectExtendedFields(i.name.value).filter(
                (f): f is FieldDefinitionNode => f.kind === Kind.FIELD_DEFINITION
              ),
              name: {
                kind: Kind.NAME,
                value: "",
              },
            },
            { knownTypes: this.doc.definitions }
          );
        }),
      };
    }
    return def;
  };

  private pruneDefinition = (def: DefinitionNode): DefinitionNode | null => {
    const fs = [
      this.pruneInterfaces,
      this.pruneFields,
      <T extends DefinitionNode>(def: T): T | null => {
        if (def.kind === Kind.OBJECT_TYPE_EXTENSION) {
          return null;
        }
        return def;
      },
    ];

    let ret = def;
    for (const f of fs) {
      const res = f(ret);
      if (res === null) {
        return null;
      }
      ret = res;
    }

    return ret;
  };

  private collectExtendedFields = (def: NamedWithFields | string): readonly FieldLike[] => {
    const typeName = typeof def === "string" ? def : def.name.value;
    return this.doc.definitions
      .filter((d): d is DefinitionNode & NamedWithFields => "name" in d && "fields" in d && d.name?.value === typeName)
      .map((d) => d.fields ?? [])
      .reduce((acum: FieldLike[], cur) => [...acum, ...cur], []);
  };

  private pruneFields = <T extends DefinitionNode>(def: T): T | null => {
    if (!("fields" in def)) {
      return def;
    }
    const fields = this.collectExtendedFields(def)
      .filter(this.definedType)
      .filter((f) => {
        if (!("interfaces" in def) || def.interfaces === undefined) {
          return true;
        }

        for (const i of def.interfaces) {
          const requiredFields = this.collectExtendedFields(i.name.value);
          for (const rf of requiredFields) {
            if (!identicalyNamed(rf, f)) {
              continue;
            }

            if (!compatibleType(rf.type, f.type, { knownTypes: this.doc.definitions })) {
              return false;
            }
          }
        }
        return true;
      })
      .map((d) => ("arguments" in d ? this.pruneArgs(d) : d))
      .reduce((acum: FieldLike[], cur: FieldLike) => {
        if (acum.some((f) => f.name.value == cur.name.value)) {
          return acum;
        }
        return [...acum, cur];
      }, []);
    if (fields.length === 0) {
      return null;
    }

    return { ...def, fields };
  };

  private pruneArgs = <T extends { arguments?: readonly InputValueDefinitionNode[] }>(def: T): T => {
    const args = def.arguments?.filter(this.definedInputType).reduce((acum: InputValueDefinitionNode[], cur) => {
      if (acum.some((a) => a.name.value === cur.name.value)) {
        return acum;
      }
      return [...acum, cur];
    }, []);

    return { ...def, arguments: args };
  };

  private definedType = (field: { type: TypeNode } | TypeNode): boolean => {
    const typeName = "type" in field ? unwrapType(field.type).name.value : field.name.value;
    if (SCALARS.includes(typeName)) {
      return true;
    }

    return this.doc.definitions.some(
      (def) =>
        (def.kind === Kind.OBJECT_TYPE_DEFINITION && def.name.value === typeName) ||
        (def.kind === Kind.INTERFACE_TYPE_DEFINITION && def.name.value === typeName) ||
        (def.kind === Kind.ENUM_TYPE_DEFINITION && def.name.value === typeName) ||
        (def.kind === Kind.INPUT_OBJECT_TYPE_DEFINITION && def.name.value === typeName) ||
        (def.kind === Kind.SCALAR_TYPE_DEFINITION && def.name.value === typeName)
    );
  };

  private definedInputType = (field: { type: TypeNode } | TypeNode): boolean => {
    const typeName = "type" in field ? unwrapType(field.type).name.value : field.name.value;
    if (SCALARS.includes(typeName)) {
      return true;
    }

    return this.doc.definitions.some(
      (def) => def.kind === Kind.INPUT_OBJECT_TYPE_DEFINITION && def.name.value === typeName
    );
  };
}

export const normalize = (doc: DocumentNode, depth = 100): DocumentNode => {
  const p = new Nomalizer(doc);
  return p.normalize(depth);
};
