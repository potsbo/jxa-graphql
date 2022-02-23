import { Kind, TypeNode } from "graphql";
import { compatibleType } from "..";

test("compatibleType same type", () => {
  const type: TypeNode = { kind: Kind.NAMED_TYPE, name: { kind: Kind.NAME, value: "SomeName" } };
  expect(compatibleType(type, type)).toBe(true);
});

test("compatibleType same list type", () => {
  const type: TypeNode = { kind: Kind.NAMED_TYPE, name: { kind: Kind.NAME, value: "SomeName" } };
  const listType: TypeNode = { kind: Kind.LIST_TYPE, type };
  expect(compatibleType(listType, listType)).toBe(true);
});

test("compatibleType same non null type", () => {
  const type: TypeNode = { kind: Kind.NAMED_TYPE, name: { kind: Kind.NAME, value: "SomeName" } };
  const listType: TypeNode = { kind: Kind.NON_NULL_TYPE, type };
  expect(compatibleType(listType, listType)).toBe(true);
});

test("compatibleType incompatible types", () => {
  const type: TypeNode = { kind: Kind.NAMED_TYPE, name: { kind: Kind.NAME, value: "SomeName" } };
  const listType: TypeNode = { kind: Kind.NON_NULL_TYPE, type };
  expect(compatibleType(listType, type)).toBe(false);
});

test("compatibleType compatible types via interface", () => {
  const a: TypeNode = { kind: Kind.NAMED_TYPE, name: { kind: Kind.NAME, value: "SomeInterface" } };
  const b: TypeNode = { kind: Kind.NAMED_TYPE, name: { kind: Kind.NAME, value: "SomeName" } };

  expect(
    compatibleType(a, b, {
      knownTypes: [
        {
          kind: Kind.OBJECT_TYPE_DEFINITION,
          name: {
            kind: Kind.NAME,
            value: "SomeName",
          },
          interfaces: [
            {
              kind: Kind.NAMED_TYPE,
              name: {
                kind: Kind.NAME,
                value: "SomeInterface",
              },
            },
          ],
        },
      ],
    })
  ).toBe(true);
});

test("compatibleType compatible types via interface", () => {
  const a: TypeNode = { kind: Kind.NAMED_TYPE, name: { kind: Kind.NAME, value: "SomeInterface" } };
  const b: TypeNode = { kind: Kind.NAMED_TYPE, name: { kind: Kind.NAME, value: "SomeName" } };

  expect(
    compatibleType(b, a, {
      knownTypes: [
        {
          kind: Kind.OBJECT_TYPE_DEFINITION,
          name: {
            kind: Kind.NAME,
            value: "SomeName",
          },
          interfaces: [
            {
              kind: Kind.NAMED_TYPE,
              name: {
                kind: Kind.NAME,
                value: "SomeInterface",
              },
            },
          ],
        },
      ],
    })
  ).toBe(true);
});
