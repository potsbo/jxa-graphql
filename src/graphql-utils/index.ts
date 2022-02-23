import {
  DefinitionNode,
  FieldDefinitionNode,
  InterfaceTypeDefinitionNode,
  Kind,
  NamedTypeNode,
  NameNode,
  TypeNode,
} from "graphql";

export const unwrapType = (typeNode: TypeNode): NamedTypeNode => {
  if (typeNode.kind === Kind.NAMED_TYPE) {
    return typeNode;
  }

  return unwrapType(typeNode.type);
};

export const compatibleType = (
  a: TypeNode,
  b: TypeNode,
  opts: { knownTypes?: readonly DefinitionNode[] } = {}
): boolean => {
  if (a.kind === Kind.NAMED_TYPE && b.kind === Kind.NAMED_TYPE) {
    return (
      identicalyNamed(a, b) ||
      opts.knownTypes?.some(
        (k) =>
          "name" in k && "interfaces" in k && identicalyNamed(k, a) && k.interfaces?.some((i) => identicalyNamed(i, b))
      ) ||
      opts.knownTypes?.some(
        (k) =>
          "name" in k && "interfaces" in k && identicalyNamed(k, b) && k.interfaces?.some((i) => identicalyNamed(i, a))
      ) ||
      false
    );
  }
  if (a.kind === Kind.LIST_TYPE && b.kind === Kind.LIST_TYPE) {
    return compatibleType(a.type, b.type, opts);
  }
  if (a.kind === Kind.NON_NULL_TYPE && b.kind === Kind.NON_NULL_TYPE) {
    return compatibleType(a.type, b.type, opts);
  }
  return false;
};

export const identicalyNamed = (a: { name?: NameNode }, b: { name?: NameNode }): boolean => {
  if (a.name === undefined || b.name === undefined) {
    return false;
  }

  return a.name.value === b.name.value;
};

export const implementsInterface = (
  objectLike: { fields?: readonly FieldDefinitionNode[] },
  itfc: InterfaceTypeDefinitionNode,
  opts: { knownTypes?: readonly DefinitionNode[] } = {}
): boolean => {
  if (itfc.fields === undefined) {
    return true;
  }
  return itfc.fields.every((required) => {
    return objectLike.fields?.some(
      (actual) => identicalyNamed(required, actual) && compatibleType(required.type, actual.type, opts)
    );
  });
};
