import { InterfaceTypeDefinitionNode, Kind } from "graphql";
import { field } from "./field";
import { name } from "./name";
import { list, named, nonNull } from "./types";

export const CONNECTION_TYPE_NAME = "Connection";
export const EDGE_TYPE_NAME = "Edge";
export const NODE_TYPE_NAME = "Node";
export const INTERFACE_SUFFIX = "Interface";

export const NodeInterface: InterfaceTypeDefinitionNode = {
  kind: Kind.INTERFACE_TYPE_DEFINITION,
  name: name(NODE_TYPE_NAME, { pascalCase: true }),
  fields: [field("id", nonNull("ID"))],
};

// https://relay.dev/graphql/connections.htm#sec-Edge-Types
export const EdgeInterface: InterfaceTypeDefinitionNode = {
  kind: Kind.INTERFACE_TYPE_DEFINITION,
  name: name(EDGE_TYPE_NAME, { pascalCase: true }),
  fields: [field("node", nonNull("Node")), field("cursor", nonNull("String"))],
};

// https://relay.dev/graphql/connections.htm#sec-Connection-Types
export const ConnectionInterface: InterfaceTypeDefinitionNode = {
  kind: Kind.INTERFACE_TYPE_DEFINITION,
  name: name(CONNECTION_TYPE_NAME, { pascalCase: true }),
  fields: [
    field("edges", nonNull(list(nonNull(EDGE_TYPE_NAME)))),
    field("pageInfo", nonNull("PageInfo")),
    // https://developer.apple.com/library/archive/releasenotes/InterapplicationCommunication/RN-JavaScriptForAutomation/Articles/OSX10-10.html
    {
      ...field("byId", named("Node")),
      arguments: [
        {
          kind: Kind.INPUT_VALUE_DEFINITION,
          name: name("id"),
          type: nonNull("ID"),
        },
      ],
    },
  ],
};