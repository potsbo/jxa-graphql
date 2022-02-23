import { Kind } from "graphql";
import { implementsInterface } from "..";

test("interface with undefined fields", () => {
  expect(
    implementsInterface({}, { kind: Kind.INTERFACE_TYPE_DEFINITION, name: { kind: Kind.NAME, value: "SomeInterface" } })
  ).toBe(true);
});

test("interface with required fields", () => {
  expect(
    implementsInterface(
      {},
      {
        kind: Kind.INTERFACE_TYPE_DEFINITION,
        name: { kind: Kind.NAME, value: "SomeInterface" },
        fields: [
          {
            kind: Kind.FIELD_DEFINITION,
            name: {
              kind: Kind.NAME,
              value: "SomeName",
            },
            type: {
              kind: Kind.NAMED_TYPE,
              name: {
                kind: Kind.NAME,
                value: "SomeType",
              },
            },
          },
        ],
      }
    )
  ).toBe(false);
});

test("interface matches", () => {
  expect(
    implementsInterface(
      {
        fields: [
          {
            kind: Kind.FIELD_DEFINITION,
            name: {
              kind: Kind.NAME,
              value: "SomeName",
            },
            type: {
              kind: Kind.NAMED_TYPE,
              name: {
                kind: Kind.NAME,
                value: "SomeType",
              },
            },
          },
        ],
      },
      {
        kind: Kind.INTERFACE_TYPE_DEFINITION,
        name: { kind: Kind.NAME, value: "SomeInterface" },
        fields: [
          {
            kind: Kind.FIELD_DEFINITION,
            name: {
              kind: Kind.NAME,
              value: "SomeName",
            },
            type: {
              kind: Kind.NAMED_TYPE,
              name: {
                kind: Kind.NAME,
                value: "SomeType",
              },
            },
          },
        ],
      }
    )
  ).toBe(true);
});

test("interface matches recursively", () => {
  expect(
    implementsInterface(
      {
        fields: [
          {
            kind: Kind.FIELD_DEFINITION,
            name: {
              kind: Kind.NAME,
              value: "SomeName",
            },
            type: {
              kind: Kind.NAMED_TYPE,
              name: {
                kind: Kind.NAME,
                value: "SomeType",
              },
            },
          },
        ],
      },
      {
        kind: Kind.INTERFACE_TYPE_DEFINITION,
        name: { kind: Kind.NAME, value: "SomeInterface" },
        fields: [
          {
            kind: Kind.FIELD_DEFINITION,
            name: {
              kind: Kind.NAME,
              value: "SomeName",
            },
            type: {
              kind: Kind.NAMED_TYPE,
              name: {
                kind: Kind.NAME,
                value: "AnotherInterface",
              },
            },
          },
        ],
      },
      {
        knownTypes: [
          {
            kind: Kind.OBJECT_TYPE_DEFINITION,
            name: {
              kind: Kind.NAME,
              value: "SomeType",
            },
            interfaces: [
              {
                kind: Kind.NAMED_TYPE,
                name: {
                  kind: Kind.NAME,
                  value: "AnotherInterface",
                },
              },
            ],
          },
        ],
      }
    )
  ).toBe(true);
});

test("type unmatch", () => {
  expect(
    implementsInterface(
      {
        fields: [
          {
            kind: Kind.FIELD_DEFINITION,
            name: {
              kind: Kind.NAME,
              value: "SomeName",
            },
            type: {
              kind: Kind.NAMED_TYPE,
              name: {
                kind: Kind.NAME,
                value: "AnotherType",
              },
            },
          },
        ],
      },
      {
        kind: Kind.INTERFACE_TYPE_DEFINITION,
        name: { kind: Kind.NAME, value: "SomeInterface" },
        fields: [
          {
            kind: Kind.FIELD_DEFINITION,
            name: {
              kind: Kind.NAME,
              value: "SomeName",
            },
            type: {
              kind: Kind.NAMED_TYPE,
              name: {
                kind: Kind.NAME,
                value: "SomeType",
              },
            },
          },
        ],
      }
    )
  ).toBe(false);
});

test("name unmatch", () => {
  expect(
    implementsInterface(
      {
        fields: [
          {
            kind: Kind.FIELD_DEFINITION,
            name: {
              kind: Kind.NAME,
              value: "SomeName",
            },
            type: {
              kind: Kind.NAMED_TYPE,
              name: {
                kind: Kind.NAME,
                value: "SomeType",
              },
            },
          },
        ],
      },
      {
        kind: Kind.INTERFACE_TYPE_DEFINITION,
        name: { kind: Kind.NAME, value: "SomeInterface" },
        fields: [
          {
            kind: Kind.FIELD_DEFINITION,
            name: {
              kind: Kind.NAME,
              value: "AnotherType",
            },
            type: {
              kind: Kind.NAMED_TYPE,
              name: {
                kind: Kind.NAME,
                value: "SomeType",
              },
            },
          },
        ],
      }
    )
  ).toBe(false);
});
