import { Kind, NamedTypeNode } from "graphql";
import { unwrapType } from "..";

test("unwrapType NamedType", () => {
  const res = unwrapType({ kind: Kind.NAMED_TYPE, name: { kind: Kind.NAME, value: "SomeName" } });
  expect(res.name.value).toEqual("SomeName");
});

test("unwrapType ListType", () => {
  const type: NamedTypeNode = { kind: Kind.NAMED_TYPE, name: { kind: Kind.NAME, value: "SomeName" } };
  const res = unwrapType({ kind: Kind.LIST_TYPE, type });
  expect(res.name.value).toEqual("SomeName");
});

test("unwrapType NonNullType", () => {
  const type: NamedTypeNode = { kind: Kind.NAMED_TYPE, name: { kind: Kind.NAME, value: "SomeName" } };
  const res = unwrapType({ kind: Kind.NON_NULL_TYPE, type });
  expect(res.name.value).toEqual("SomeName");
});

test("unwrapType complex", () => {
  const type: NamedTypeNode = { kind: Kind.NAMED_TYPE, name: { kind: Kind.NAME, value: "SomeName" } };
  const res = unwrapType({
    kind: Kind.NON_NULL_TYPE,
    type: { kind: Kind.LIST_TYPE, type: { kind: Kind.NON_NULL_TYPE, type } },
  });
  expect(res.name.value).toEqual("SomeName");
});
