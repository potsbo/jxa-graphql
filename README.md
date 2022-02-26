# JXA GraphQL

Access AppleScript supported apps via GraphQL interface.

## Example

### `npx`

Run `serve` command to start a GraphQL server.

```
$ npx jxa-graphql serve /System/Applications/Calendar.app
🚀  Server ready at http://localhost:4000/
```

With [`Apollo Sandbox`](https://studio.apollographql.com/sandbox/explorer), or any other preferred tools, you can run GraphQL queries to get data from applications.

### API

To be written

## Features

To be written

- Pagenation
- Fragment
- Mutation
- Enum
- Schema Override

## How it works

JXA GraphQL is a GraphQL wrapper for [JavaScript for Automation (JXA)](https://developer.apple.com/library/archive/releasenotes/InterapplicationCommunication/RN-JavaScriptForAutomation/Articles/Introduction.html).

compile graphql query into javascript

```graphql
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
```

```js
function pascalCase(s) {
  return (s.match(/[a-zA-Z0-9]+/g) || []).map((w) => `${w[0].toUpperCase()}${w.slice(1)}`).join("");
}
function extractId(obj) {
  const spec = Automation.getDisplayString(obj);
  return (
    spec
      ?.split("byId")
      .reverse()[0]
      .match(/^\\(\"(.+)\"\\)$/)
      ?.reverse()[0] ?? null
  );
}
function pagenate(nodes, { first, after }, getId) {
  const afterIndex = after === undefined ? undefined : nodes.findIndex((n) => getId(n) === after);
  if (afterIndex === -1) {
    return [];
  }
  const start = afterIndex === undefined ? 0 : afterIndex + 1;
  const end = first !== undefined ? start + first : undefined;
  return nodes.slice(start, end);
}
const app = Application("Calendar");
JSON.stringify({
  result: {
    calendars: (() => {
      const allNodes = app.calendars.whose({ writable: { _equals: true } })();
      const nodes = pagenate(allNodes, { first: 3 }, extractId);
      return {
        edges: nodes.map((elm) => {
          return { node: { name: elm.name() } };
        }),
      };
    })(),
  },
});
```

## Release

When new tag pushed, GitHub Actions automatically create GitHub Releases and run `npm publish`

### Command to run

```
$ npm version <newversion>
$ git push origin <newversion>
```
