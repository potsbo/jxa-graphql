import { buildExecutionContext, ExecutionContext } from "graphql/execution/execute";
import prettier from "prettier";
import { GraphQLError } from "graphql";
import gql from "graphql-tag";
import { compile } from "../index";
import { build } from "../../converter";

const validateExecontext = (obj: ExecutionContext | readonly GraphQLError[]): obj is ExecutionContext => {
  return "operation" in obj;
};

const schema = build("/Applications/OmniFocus.app");

const TaskViewModelFragmentDoc = gql`
  fragment TaskViewModel on TaskInterface {
    name
    id
    effectiveDueDate
    completed
    effectivelyCompleted
    containingProject {
      id
      name
    }
    flagged
  }
`;

test("query for Connection", async () => {
  const document = gql`
    query Hoge {
      application {
        defaultDocument {
          projects {
            pageInfo {
              hasNextPage
            }
            edges {
              cursor
              node {
                name
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

  expect(prettier.format(compile("OmniFocus", exeContext), { parser: "babel" })).toMatchSnapshot();
});

test("query with inline fragment", async () => {
  const document = gql`
    query {
      application {
        defaultDocument {
          folders {
            edges {
              node {
                name
                sections {
                  edges {
                    node {
                      ... on Project {
                        completed
                      }
                      ... on Folder {
                        name
                      }
                    }
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

  expect(prettier.format(compile("OmniFocus", exeContext), { parser: "babel" })).toMatchSnapshot();
});

test("query with project interface", async () => {
  const document = gql`
    query {
      application {
        defaultDocument {
          projects {
            byId(id: "hZoaSakOnG4") {
              rootTask {
                id
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

  expect(prettier.format(compile("OmniFocus", exeContext), { parser: "babel" })).toMatchSnapshot();
});

test("query with pageInfo", async () => {
  const document = gql`
    query {
      application {
        defaultDocument {
          projects(first: 10, after: "SOME-ID") {
            pageInfo {
              hasPreviousPage
              hasNextPage
              startCursor
              endCursor
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

  expect(prettier.format(compile("OmniFocus", exeContext), { parser: "babel" })).toMatchSnapshot();
});

test("query with fragment", async () => {
  const document = gql`
    query GetTasksInProject($projectId: ID!) {
      application {
        defaultDocument {
          projects {
            byId(id: $projectId) {
              rootTask {
                tasks {
                  edges {
                    node {
                      ...TaskViewModel
                      repetition {
                        unit
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    ${TaskViewModelFragmentDoc}
  `;

  const exeContext = buildExecutionContext({
    schema: await schema,
    document: document,
    variableValues: { projectId: "foobar" },
  });
  if (!validateExecontext(exeContext)) {
    fail();
  }

  expect(prettier.format(compile("OmniFocus", exeContext), { parser: "babel" })).toMatchSnapshot();
});

test("typename", async () => {
  const document = gql`
    query GetTasksInProject {
      application {
        perspectiveNames
        defaultDocument {
          sections {
            edges {
              node {
                ... on Project {
                  name
                  effectiveStatus
                }
                ... on Folder {
                  name
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

  expect(prettier.format(compile("OmniFocus", exeContext), { parser: "babel" })).toMatchSnapshot();
});

test("explicit typename", async () => {
  const document = gql`
    query {
      application {
        defaultDocument {
          sections {
            edges {
              node {
                id
                __typename
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

  expect(prettier.format(compile("OmniFocus", exeContext), { parser: "babel" })).toMatchSnapshot();
});
