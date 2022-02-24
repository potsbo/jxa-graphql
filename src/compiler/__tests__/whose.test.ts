import { FieldNode, Kind, OperationDefinitionNode } from "graphql";
import gql from "graphql-tag";
import { format } from "prettier";
import { buildWhoseFilter } from "../whose";

test("normal field", () => {
  const res = buildWhoseFilter(
    { variableValues: {} },
    {
      kind: Kind.FIELD,
      name: { kind: Kind.NAME, value: "anyname" },
    }
  );
  expect(res).toEqual("");
});

test("field missing", () => {
  const q = gql`
    query {
      someField(whose: { enabled: false })
    }
  `;
  const f = (q.definitions[0] as OperationDefinitionNode).selectionSet.selections[0] as FieldNode;
  expect(() => buildWhoseFilter({ variableValues: {} }, f)).toThrowError();
});

test("invalid operator", () => {
  const q = gql`
    query {
      someField(whose: { operator: "unknownop" })
    }
  `;
  const f = (q.definitions[0] as OperationDefinitionNode).selectionSet.selections[0] as FieldNode;
  expect(() => buildWhoseFilter({ variableValues: {} }, f)).toThrowError();
});

test("non list operands", () => {
  const q = gql`
    query {
      someField(whose: { operator: "and", operands: "nonObjectValue" })
    }
  `;
  const f = (q.definitions[0] as OperationDefinitionNode).selectionSet.selections[0] as FieldNode;
  expect(() => buildWhoseFilter({ variableValues: {} }, f)).toThrowError();
});

test("non object operands", () => {
  const q = gql`
    query {
      someField(whose: { operator: "and", operands: ["nonObjectValue"] })
    }
  `;
  const f = (q.definitions[0] as OperationDefinitionNode).selectionSet.selections[0] as FieldNode;
  expect(() => buildWhoseFilter({ variableValues: {} }, f)).toThrowError();
});

test("type mismatch - string", () => {
  const q = gql`
    query {
      someField(whose: { field: 1 })
    }
  `;
  const f = (q.definitions[0] as OperationDefinitionNode).selectionSet.selections[0] as FieldNode;
  expect(() => buildWhoseFilter({ variableValues: { fieldName: true } }, f)).toThrowError();
});

test("type mismatch - boolean", () => {
  const q = gql`
    query {
      someField(whose: { field: "foo", enabled: 1 })
    }
  `;
  const f = (q.definitions[0] as OperationDefinitionNode).selectionSet.selections[0] as FieldNode;
  expect(() => buildWhoseFilter({ variableValues: { fieldName: true } }, f)).toThrowError();
});
test("variable type mismatch - string", () => {
  const q = gql`
    query {
      someField(whose: { field: $fieldName })
    }
  `;
  const f = (q.definitions[0] as OperationDefinitionNode).selectionSet.selections[0] as FieldNode;
  expect(() => buildWhoseFilter({ variableValues: { fieldName: true } }, f)).toThrowError();
});

test("variable type mismatch", () => {
    const q = gql`
      query {
        someField(whose: { field: "some", enabled: $enabled })
      }
    `;
    const f = (q.definitions[0] as OperationDefinitionNode).selectionSet.selections[0] as FieldNode;
    expect(() => buildWhoseFilter({ variableValues: { enabled: 1 } }, f)).toThrowError();
  });

test("normal field", () => {
  const q = gql`
    query {
      flattenedTasks(
        whose: {
          operator: "and"
          operands: [
            { field: "effectivelyCompleted", value: "false" }
            { field: "flagged", enabled: $onlyFlagged }
            {
              operator: "not"
              operands: [{ field: "effectiveDeferDate", value: "null", enabled: $withEffectiveDueDate }]
            }
            {
              enabled: $onlyAvailable
              operator: "or"
              operands: [
                { field: "effectiveDeferDate", operator: "=", value: "null" }
                { field: "effectiveDeferDate", operator: "<", value: "new Date()" }
              ]
            }
          ]
        }
      )
    }
  `;
  const f = (q.definitions[0] as OperationDefinitionNode).selectionSet.selections[0] as FieldNode;
  const filter = buildWhoseFilter(
    { variableValues: { onlyFlagged: false, onlyAvailable: false, withEffectiveDueDate: false } },
    f
  );
  expect(format("_" + filter)).toMatchInlineSnapshot(`
    "_.whose({ effectivelyCompleted: { _equals: false } });
    "
  `);
});

test("nesting deep", () => {
  const q = gql`
    query {
      flattenedTasks(
        whose: {
          operator: "_and"
          operands: [
            {
              operator: "and"
              operands: [
                {
                  operator: "and"
                  operands: [
                    {
                      operator: "and"
                      operands: [
                        { operator: "not", operands: [{ field: "someField" }] }
                        { field: "effectiveDeferDate", operator: "=", value: "null" }
                        { field: "effectiveDeferDate", operator: "=", value: "null", enabled: false }
                      ]
                    }
                    { field: "effectiveDeferDate", operator: ">=", value: $defaultStringValue }
                    { field: "effectiveDeferDate", operator: "<=", value: "new Date()" }
                    { field: "effectiveDeferDate", operator: ">", value: "new Date()" }
                    { field: "effectiveDeferDate", operator: "_equals", value: "new Date()" }
                    { field: "effectiveDeferDate", operator: "equals", value: "new Date()" }
                    { field: "effectiveDeferDate", operator: ">", value: "new Date()" }
                  ]
                }
              ]
            }
          ]
        }
      )
    }
  `;
  const f = (q.definitions[0] as OperationDefinitionNode).selectionSet.selections[0] as FieldNode;
  const filter = buildWhoseFilter({ variableValues: { defaultStringValue: "someString" } }, f);
  expect(format("_" + filter)).toMatchInlineSnapshot(`
    "_.whose({
      _and: [
        {
          _and: [
            { _not: [{ someField: { _equals: true } }] },
            { effectiveDeferDate: { _equals: null } },
          ],
        },
        { effectiveDeferDate: { _greaterThanEquals: someString } },
        { effectiveDeferDate: { _lessThanEquals: new Date() } },
        { effectiveDeferDate: { _greaterThan: new Date() } },
        { effectiveDeferDate: { _equals: new Date() } },
        { effectiveDeferDate: { _equals: new Date() } },
        { effectiveDeferDate: { _greaterThan: new Date() } },
      ],
    });
    "
  `);
});

test("real use case", () => {
  const q = gql`
    query {
      flattenedTasks(
        whose: {
          operator: "and"
          operands: [
            { field: "effectivelyCompleted", value: "false" }
            { field: "flagged", enabled: $onlyFlagged }
            {
              operator: "not"
              operands: [{ field: "effectiveDeferDate", value: "null", enabled: $withEffectiveDueDate }]
            }
            {
              enabled: $onlyAvailable
              operator: "or"
              operands: [
                { field: "effectiveDeferDate", operator: "=", value: "null" }
                { field: "effectiveDeferDate", operator: "<", value: "new Date()" }
              ]
            }
          ]
        }
      )
    }
  `;
  const f = (q.definitions[0] as OperationDefinitionNode).selectionSet.selections[0] as FieldNode;
  const filter = buildWhoseFilter(
    { variableValues: { onlyFlagged: true, withEffectiveDueDate: true, onlyAvailable: true } },
    f
  );
  expect(format("_" + filter)).toMatchInlineSnapshot(`
    "_.whose({
      _and: [
        { effectivelyCompleted: { _equals: false } },
        { flagged: { _equals: true } },
        { _not: [{ effectiveDeferDate: { _equals: null } }] },
        {
          _or: [
            { effectiveDeferDate: { _equals: null } },
            { effectiveDeferDate: { _lessThan: new Date() } },
          ],
        },
      ],
    });
    "
  `);
});
