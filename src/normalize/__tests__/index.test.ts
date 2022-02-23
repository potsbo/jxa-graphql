import { print } from "graphql";
import gql from "graphql-tag";
import { normalize } from "../index";

test("valid schema", () => {
  const input = gql`
    type Something {
      id: ID!
      string: String
      nonNullString: String!
      someScalar: SomeScalar
    }

    extend type Something {
      int: Int!
    }

    scalar SomeScalar
  `;

  const output = gql`
    type Something {
      id: ID!
      string: String
      nonNullString: String!
      someScalar: SomeScalar
      int: Int!
    }

    scalar SomeScalar
  `;

  expect(print(normalize(input))).toEqual(print(output));
});

test("one invalid field", () => {
  const input = gql`
    type Something {
      string: String
      nonNullString: String!
      unKnownType: UnknownType
    }
  `;

  const output = gql`
    type Something {
      string: String
      nonNullString: String!
    }
  `;

  expect(print(normalize(input))).toEqual(print(output));
});

test("user defiend type", () => {
  const input = gql`
    type Something {
      string: String
      nonNullString: String!
      unKnownType: KnownType
    }

    type KnownType {
      string: String
    }
  `;

  expect(print(normalize(input))).toEqual(print(input));
});

test("depending on invalid type", () => {
  const input = gql`
    type Something {
      string: String
      nonNullString: String!
      unKnownType: KnownType
    }

    type KnownType {
      string: UnknownType
    }
  `;

  const output = gql`
    type Something {
      string: String
      nonNullString: String!
    }
  `;

  expect(print(normalize(input))).toEqual(print(output));
});

test("fields with interface", () => {
  const input = gql`
    type Something {
      someInterface: SomeInterface
    }

    interface SomeInterface {
      str: String
    }
  `;

  const output = gql`
    type Something {
      someInterface: SomeInterface
    }

    interface SomeInterface {
      str: String
    }
  `;

  expect(print(normalize(input))).toEqual(print(output));
});

test("fields with enum", () => {
  const input = gql`
    type Something {
      someEnum: SomeEnum
    }

    enum SomeEnum {
      VALUE1
      VALUE2
    }
  `;

  const output = gql`
    type Something {
      someEnum: SomeEnum
    }

    enum SomeEnum {
      VALUE1
      VALUE2
    }
  `;

  expect(print(normalize(input))).toEqual(print(output));
});

test("args", () => {
  const input = gql`
    type Something {
      str: String
      fieldWithValidArgs(id: String!, input: SomeInput): Boolean
      fieldWithInvalidArgs(id: UnknownType!): Int
    }

    input SomeInput {
      str: String
    }
  `;

  const output = gql`
    type Something {
      str: String
      fieldWithValidArgs(id: String!, input: SomeInput): Boolean
      fieldWithInvalidArgs: Int
    }

    input SomeInput {
      str: String
    }
  `;

  expect(print(normalize(input))).toEqual(print(output));
});

test("input only", () => {
  const input = gql`
    input SomeInput {
      str: String
    }
  `;

  const output = gql`
    input SomeInput {
      str: String
    }
  `;

  expect(print(normalize(input))).toEqual(print(output));
});

test("valid interface", () => {
  const input = gql`
    interface SomeInterface {
      someField: String
    }
    type SomeType implements SomeInterface {
      someField: String
    }
  `;

  const output = gql`
    interface SomeInterface {
      someField: String
    }
    type SomeType implements SomeInterface {
      someField: String
    }
  `;

  expect(print(normalize(input))).toEqual(print(output));
});

test("valid child interface", () => {
  const input = gql`
    interface ParentInterface {
      childInterface: ChildInterface
    }

    interface ChildInterface {
      someField: String
    }

    type SomeType implements ParentInterface {
      childInterface: ValidChild
      validField: String
    }

    type ValidChild implements ChildInterface {
      someField: String
    }
  `;

  const output = gql`
    interface ParentInterface {
      childInterface: ChildInterface
    }

    interface ChildInterface {
      someField: String
    }

    type SomeType implements ParentInterface {
      childInterface: ValidChild
      validField: String
    }

    type ValidChild implements ChildInterface {
      someField: String
    }
  `;

  expect(print(normalize(input))).toEqual(print(output));
});
test("invalid interface", () => {
  const input = gql`
    interface SomeInterface {
      someField: String
    }
    type SomeType implements SomeInterface {
      validField: String
    }
  `;

  const output = gql`
    interface SomeInterface {
      someField: String
    }
    type SomeType {
      validField: String
    }
  `;

  expect(print(normalize(input))).toEqual(print(output));
});

test("invalid child interface", () => {
  const input = gql`
    interface ParentInterface {
      childInterface: ChildInterface
    }

    interface ChildInterface {
      someField: String
    }

    type SomeType implements ParentInterface {
      childInterface: InvalidChild
      validField: String
    }

    type InvalidChild implements ChildInterface {
      anotherField: String
    }
  `;

  const output = gql`
    interface ParentInterface {
      childInterface: ChildInterface
    }

    interface ChildInterface {
      someField: String
    }

    type SomeType {
      childInterface: InvalidChild
      validField: String
    }

    type InvalidChild {
      anotherField: String
    }
  `;

  expect(print(normalize(input))).toEqual(print(output));
});

test("object as input", () => {
  const input = gql`
    type Mutation {
      doSomething(input: NonInputObject): String
    }

    type NonInputObject {
      someField: String
    }
  `;

  const output = gql`
    type Mutation {
      doSomething: String
    }

    type NonInputObject {
      someField: String
    }
  `;

  expect(print(normalize(input))).toEqual(print(output));
});

test("multiple definition", () => {
  const input = gql`
    type SomeType {
      someField: String
      someField: String
    }

    extend type SomeType {
      someField: String
    }
    extend type SomeType {
      someField: String
    }
  `;

  const output = gql`
    type SomeType {
      someField: String
    }
  `;

  expect(print(normalize(input))).toEqual(print(output));
});

test("multiple definition or args", () => {
  const input = gql`
    type SomeType {
      someField(foo: String, foo: String): String
    }
  `;

  const output = gql`
    type SomeType {
      someField(foo: String): String
    }
  `;

  expect(print(normalize(input))).toEqual(print(output));
});

test("incompatible field nanem", () => {
  const input = gql`
    type SomeType {
      someField: Int!
      someField: String!
    }
  `;

  const output = gql`
    type SomeType {
      someField: Int!
    }
  `;

  expect(print(normalize(input))).toEqual(print(output));
});

test("incompatible field duplication with interfaces", () => {
  const input = gql`
    interface Foo {
      a: String!
    }
    type SomeType implements Foo {
      someField: Int!
      a: String!
      a: Int!
    }
  `;

  const output = gql`
    interface Foo {
      a: String!
    }

    type SomeType implements Foo {
      someField: Int!
      a: String!
    }
  `;

  expect(print(normalize(input))).toEqual(print(output));
});

test("too deep", () => {
  const input = gql`
    type Something {
      string: String
      nonNullString: String!
      unKnownType: KnownType
    }

    type KnownType {
      string: KnownType2
    }

    type KnownType2 {
      string: UnknownType
    }
  `;

  expect(() => normalize(input, 2)).toThrowError();
});
