import { FieldNode, GraphQLResolveInfo, Kind, ObjectValueNode } from "graphql";

const WHOSE_ARG_NAME = "whose";
const OPERANDS_KEY = "operands";

const MATCH_OPERATORS = [
  "_equals",
  "_contains",
  "_beginsWith",
  "_endsWith",
  "_greaterThan",
  "_greaterThanEquals",
  "_lessThan",
  "_lessThanEquals",
  "_match",
] as const;

const LOGICAL_OPERATORS = ["_and", "_or", "_not"] as const;

type MatchOperator = typeof MATCH_OPERATORS[number];
type LogicalOperator = typeof LOGICAL_OPERATORS[number];

type Condition =
  | {
      kind: "MATCH";
      field: string;
      operator: MatchOperator;
      value: string;
      enabled: boolean;
    }
  | {
      kind: "LOGICAL";
      operator: LogicalOperator;
      children: Condition[];
      enabled: boolean;
    };

const getMatchOperator = (op: string): MatchOperator | null => {
  if (MATCH_OPERATORS.indexOf(op as MatchOperator) > -1) {
    return op as MatchOperator;
  }
  if (MATCH_OPERATORS.indexOf(`_${op}` as MatchOperator) > -1) {
    return `_${op}` as MatchOperator;
  }
  switch (op) {
    case "=":
      return "_equals";
    case ">":
      return "_greaterThan";
    case ">=":
      return "_greaterThanEquals";
    case "<":
      return "_lessThan";
    case "<=":
      return "_lessThanEquals";
  }
  return null;
};

const mustGetLogicalOperator = (op: string): LogicalOperator => {
  if (LOGICAL_OPERATORS.indexOf(op as LogicalOperator) > -1) {
    return op as LogicalOperator;
  }
  if (LOGICAL_OPERATORS.indexOf(`_${op}` as LogicalOperator) > -1) {
    return `_${op}` as LogicalOperator;
  }
  throw new Error(`Failed to convert ${op} as a logical operator`);
};

const mustExtractBoolArg = (
  ctx: Pick<GraphQLResolveInfo, "variableValues">,
  c: ObjectValueNode,
  key: string,
  defaultValue: boolean
): boolean => {
  const node = c.fields.find((d) => d.name.value === key)?.value;
  if (!node) {
    return defaultValue;
  }
  if (node.kind === Kind.VARIABLE) {
    const val = ctx.variableValues[node.name.value];
    if (val === undefined || typeof val !== "boolean") {
      throw new Error(`unresolvable variable: ${node.name.value}`);
    }
    return val;
  }
  if (node.kind !== Kind.BOOLEAN) {
    throw new Error();
  }

  return node.value;
};

const mustExtractStringArg = (
  ctx: Pick<GraphQLResolveInfo, "variableValues">,
  c: ObjectValueNode,
  key: string,
  defaultValue?: string
): string => {
  const node = c.fields.find((d) => d.name.value === key)?.value;
  if (node === undefined) {
    if (defaultValue !== undefined) {
      return defaultValue;
    }
    throw new Error(`argument "${key}" not found in ${c.fields.map((d) => d.name.value)}`);
  }
  if (node.kind === Kind.VARIABLE) {
    const val = ctx.variableValues[node.name.value];
    if (val === undefined || typeof val !== "string") {
      throw new Error(`unresolvable variable: ${node.name.value}`);
    }
    return val;
  }

  if (node.kind !== Kind.STRING) {
    throw new Error();
  }

  return node.value;
};

const extractConditionFromObjectValueNode = (
  ctx: Pick<GraphQLResolveInfo, "variableValues">,
  condition: ObjectValueNode
): Condition => {
  const enabled = mustExtractBoolArg(ctx, condition, "enabled", true);
  const operator = mustExtractStringArg(ctx, condition, "operator", "=");
  const matchOp = getMatchOperator(operator);
  if (matchOp) {
    const field = mustExtractStringArg(ctx, condition, "field");
    const value = mustExtractStringArg(ctx, condition, "value", "true");
    return {
      kind: "MATCH",
      field,
      operator: matchOp,
      value,
      enabled,
    };
  }

  const logicalOp = mustGetLogicalOperator(operator);

  const childrenNode = condition.fields.find((f) => f.name.value === OPERANDS_KEY)?.value;
  if (!childrenNode || childrenNode.kind !== Kind.LIST) {
    throw new Error(`malformed conditions ${condition}`);
  }

  return {
    kind: "LOGICAL",
    operator: logicalOp,
    children: childrenNode.values.map((f) => {
      if (f.kind !== Kind.OBJECT) {
        throw new Error(`malformed conditions ${f.kind}`);
      }
      return extractConditionFromObjectValueNode(ctx, f);
    }),
    enabled,
  };
};

const extractCondition = (ctx: Pick<GraphQLResolveInfo, "variableValues">, f: FieldNode): Condition | null => {
  const condition = f.arguments?.find((a) => a.name.value === WHOSE_ARG_NAME)?.value;
  if (!condition || condition.kind !== Kind.OBJECT) {
    return null;
  }

  return extractConditionFromObjectValueNode(ctx, condition);
};

const filterPresent = <T>(x: T | null): x is T => {
  return x !== null && x !== undefined;
};

const reduce = (c: Condition | null): Condition | null => {
  if (c === null) {
    return null;
  }
  if (!c.enabled) {
    return null;
  }
  if (c.kind === "MATCH") {
    return c;
  }

  const reducedChildren = c.children.map(reduce).filter(filterPresent);
  if (reducedChildren.length === 0) {
    return null;
  }
  switch (c.operator) {
    case "_not":
      return { ...c, children: reducedChildren };
    case "_and":
    case "_or":
      if (reducedChildren.length === 1) {
        return reducedChildren[0];
      }
      return { ...c, children: reducedChildren };
  }
};

const compileCondition = (whose: Condition): string => {
  if (whose.kind === "LOGICAL") {
    const children = `[${whose.children.map(compileCondition).join(",")}]`;
    return `{ ${whose.operator}: ${children}}`;
  }
  return `{ ${whose.field}: { ${whose.operator}: ${whose.value}}}`;
};

const compileWhoseParam = (whose: Condition | null): string => {
  const reduced = reduce(whose);
  if (reduced === null) {
    return "";
  }

  return `.whose(${compileCondition(reduced)})`;
};

export const buildWhoseFilter = (ctx: Pick<GraphQLResolveInfo, "variableValues">, f: FieldNode) => {
  return compileWhoseParam(extractCondition(ctx, f));
};
