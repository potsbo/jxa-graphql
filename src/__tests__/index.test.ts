import { makeExecutableSchema } from "@graphql-tools/schema";
import { graphql, print } from "graphql";
import gql from "graphql-tag";
import { buildRootValue, buildSchema } from "../index";
const rootValue = buildRootValue("Calendar", (code) => {
  const genCalendar = (num: number) => {
    return {
      getDisplayString: () => `Application("Calendar").calendars.byId("SOME-CALENDAR-ID-${num}")`,
      name: () => `Some Calendar Name ${num}`,
      events: () => [...Array(10)].map((_, i) => genEvent(i)),
    };
  };

  const genEvent = (num: number) => {
    return {
      getDisplayString: () =>
        `Application("Calendar").calendars.byId("ANY-CALENDAR-ID").events.byId("SOME-EVENT-ID-${num}")`,
      summary: () => `Some Event Summary ${num}`,
    };
  };

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const Application = (_: string) => ({
    calendars: () => {
      return [...Array(10)].map((_, i) => genCalendar(i));
    },
  });
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const Automation = {
    getDisplayString: (obj: { getDisplayString: () => string }) => {
      return obj.getDisplayString();
    },
  };

  const resp = eval(code);
  if (typeof resp !== "string") {
    throw Error("eval result is not a string");
  }
  const obj = JSON.parse(resp);
  if (typeof obj !== "object" || obj === null || !("result" in obj)) {
    throw Error("malformed output");
  }
  return new Promise((resolve) => resolve(obj.result));
});

test("Integration Test - Calendar", async () => {
  const typeDefs = await buildSchema("/System/Applications/Calendar.app");
  const schema = makeExecutableSchema({ typeDefs, resolvers: { Query: rootValue } });
  const query = gql`
    query {
      application {
        calendars(first: 3, after: "SOME-CALENDAR-ID-3") {
          edges {
            node {
              id
              name
              events(first: 1) {
                pageInfo {
                  hasPreviousPage
                  hasNextPage
                }
                edges {
                  node {
                    summary
                  }
                }
              }
            }
          }
        }
      }
    }
  `;

  expect(await graphql({ schema, source: print(query) })).toMatchSnapshot();
});
