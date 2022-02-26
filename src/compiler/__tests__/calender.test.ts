import { buildExecutionContext, ExecutionContext } from "graphql/execution/execute";
import prettier from "prettier";
import { GraphQLError } from "graphql";
import gql from "graphql-tag";
import { compile } from "../index";
import { build } from "../../converter";

const validateExecontext = (obj: ExecutionContext | readonly GraphQLError[]): obj is ExecutionContext => {
  return "operation" in obj;
};

const schema = build("/System/Applications/Calendar.app");

test("query for Connection", async () => {
  const document = gql`
    query {
      application {
        calendars(first: 3, whose: { field: "writable", value: "true" }) {
          edges {
            node {
              name
            }
          }
        }
      }
    }
  `;
  const exeContext = buildExecutionContext({
    schema: await schema,
    document: document,
  });
  if (!validateExecontext(exeContext)) {
    fail();
  }

  expect(prettier.format(compile("Calendar", exeContext), { parser: "babel" })).toMatchSnapshot();
});
