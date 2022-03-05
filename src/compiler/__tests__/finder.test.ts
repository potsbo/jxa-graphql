import { buildExecutionContext, ExecutionContext } from "graphql/execution/execute";
import prettier from "prettier";
import { GraphQLError } from "graphql";
import gql from "graphql-tag";
import { compile } from "../index";
import { build } from "../../converter";

const validateExecontext = (obj: ExecutionContext | readonly GraphQLError[]): obj is ExecutionContext => {
  return "operation" in obj;
};

const schema = build("/System/Library/CoreServices/Finder.app");

test("specifier support", async () => {
  const document = gql`
    query {
      application {
        home {
          files {
            edges {
              node {
                ... on AliasFile {
                  originalItem {
                    __typename
                    id
                  }
                }
              }
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

  expect(prettier.format(compile("Finder", exeContext), { parser: "babel" })).toMatchSnapshot();
});
