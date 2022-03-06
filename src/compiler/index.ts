import { assertSome, isSome } from "@graphql-tools/utils";
import {
  FieldNode,
  GraphQLResolveInfo,
  Kind,
  NonNullTypeNode,
  ObjectTypeDefinitionNode,
  SelectionNode,
  TypeNode,
  FieldDefinitionNode,
  InterfaceTypeDefinitionNode,
  ArgumentNode,
  IntValueNode,
  StringValueNode,
  ConstDirectiveNode,
  InlineFragmentNode,
  FragmentSpreadNode,
} from "graphql";
import { unwrapType } from "../graphql-utils";
import { bundle, join, RenderResult, VariableDependency } from "./bundler";
import { AvailableKeys, buildLibrary, FUNCS } from "./jxalib";
import { buildWhoseFilter } from "./whose";

const NODES_VAR_NAME = "nodes";
const ALL_NODES_VAR_NAME = "allNodes";

type CurrentContext = Pick<GraphQLResolveInfo, "fragments" | "schema" | "variableValues">;

type RenderableObject<T extends TypeNode = TypeNode> = {
  parentName: RenderResult | string;
  selectedFields: readonly SelectionNode[];
  typeNode: T;
};

type RenderableField = {
  parentName: RenderResult | string;
  field: FieldNode;
  definition: FieldDefinitionNode;
};

const extractIntArgument = (field: FieldNode, argName: string) => {
  const val = field.arguments?.find(
    (a): a is ArgumentNode & { value: IntValueNode } => a.name.value === argName && a.value.kind === Kind.INT
  )?.value.value;
  return val ? parseInt(val) : undefined;
};

const extractStringArgument = (field: FieldNode, argName: string) => {
  return field.arguments?.find(
    (a): a is ArgumentNode & { value: StringValueNode } => a.name.value === argName && a.value.kind === Kind.STRING
  )?.value.value;
};

const hasDirective = (field: { readonly directives?: ReadonlyArray<ConstDirectiveNode> }, directiveName: string) => {
  return field.directives?.some((d) => d.name.value === directiveName) ?? false;
};

const hasInterface = (ctx: CurrentContext, definition: FieldDefinitionNode, interfaceName: string) => {
  const field = mustFindTypeDefinition(ctx, definition.type);
  return field.interfaces?.some((i) => i.name.value === interfaceName) ?? false;
};

const extractPaginationArgs = (field: FieldNode) => {
  const first = extractIntArgument(field, "first");
  const after = extractStringArgument(field, "after");
  return { first, after };
};

const renderField = (
  ctx: CurrentContext,
  f: RenderableField,
  opts: Partial<{ isRecordType: boolean; isEnum: boolean }>
): RenderResult<AvailableKeys> => {
  const name = f.field.name.value;
  // TODO: check type
  if (name === "cursor") {
    return bundle`cursor: ${FUNCS.extractId}(${f.parentName}),`;
  }
  if (name === "hasPreviousPage") {
    return bundle`hasPreviousPage: ${FUNCS.extractId}(${NODES_VAR_NAME}[0]) !== ${FUNCS.extractId}(${ALL_NODES_VAR_NAME}[0]),`;
  }
  if (name === "hasNextPage") {
    return bundle`hasNextPage: ${FUNCS.extractId}(${NODES_VAR_NAME}[${NODES_VAR_NAME}.length - 1]) !== ${FUNCS.extractId}(${ALL_NODES_VAR_NAME}[${ALL_NODES_VAR_NAME}.length - 1]),`;
  }
  if (name === "startCursor") {
    return bundle`startCursor: ${FUNCS.extractId}(${NODES_VAR_NAME}[0]),`;
  }
  if (name === "endCursor") {
    return bundle`endCursor: ${FUNCS.extractId}(${NODES_VAR_NAME}[${NODES_VAR_NAME}.length - 1]),`;
  }

  if (f.field.selectionSet) {
    const renderableObject: Omit<RenderableObject, "parentName"> = {
      selectedFields: f.field.selectionSet.selections,
      typeNode: f.definition.type,
    };

    if (hasInterface(ctx, f.definition, "Node") && name === "node") {
      return bundle`${name}: ${renderObject(ctx, { ...renderableObject, parentName: f.parentName })},`;
    }

    if (hasInterface(ctx, f.definition, "Edge")) {
      return bundle`${name}: ${renderObject(ctx, { ...renderableObject, parentName: NODES_VAR_NAME })},`;
    }

    if (hasInterface(ctx, f.definition, "Connection")) {
      const pageParam = extractPaginationArgs(f.field);
      const whose = buildWhoseFilter(ctx, f.field);
      const child = bundle`${f.parentName}.${name}`;
      return bundle`${name}: ${renderConnection(
        ctx,
        { ...renderableObject, parentName: child },
        { whose, pageParam }
      )},`;
    }

    let args: VariableDependency | string = "";
    if (f.field.arguments !== undefined) {
      if (f.field.arguments.length > 1) {
        /* istanbul ignore next */
        throw new Error(`Can not pass multiple arguments to field ${f.field.name.value}`);
      }
      const arg = f.field.arguments[0];
      if (arg !== undefined) {
        if (arg.value.kind === Kind.STRING) {
          args = JSON.stringify(arg.value.value);
        }
        if (arg.value.kind === Kind.VARIABLE) {
          args = { kind: "VariableDependency", name: arg.value.name.value };
        }
      }
    }

    return bundle`${name}: ${renderObject(ctx, {
      ...renderableObject,
      parentName: bundle`${f.parentName}.${name}(${args})`,
    })},`;
  }

  if (hasDirective(f.definition, "extractFromObjectDisplayName")) {
    return bundle`${name}: ${FUNCS.extractId}(${f.parentName}),`;
  }

  const isEnum = isEnumValue(ctx, f.definition);
  const suffix = isEnum ? `()?.toUpperCase().replaceAll(" ", "_")` : opts.isRecordType ? "" : "()";
  return bundle`${name}: ${f.parentName}.${f.field.name.value}${suffix},`;
};

const isEnumValue = (ctx: CurrentContext, f: FieldDefinitionNode): boolean => {
  const typeName = unwrapType(f.type).name.value;
  const typeDef = ctx.schema.getType(typeName)?.astNode;
  return typeDef?.kind === Kind.ENUM_TYPE_DEFINITION;
};

const mustFindTypeDefinition = (
  ctx: CurrentContext,
  typeNode: TypeNode
): ObjectTypeDefinitionNode | InterfaceTypeDefinitionNode => {
  const typeName = unwrapType(typeNode).name.value;
  const typeDef = ctx.schema.getType(typeName)?.astNode;
  assertSome(typeDef);
  if (typeDef.kind === Kind.OBJECT_TYPE_DEFINITION) {
    return typeDef;
  }
  if (typeDef.kind === Kind.INTERFACE_TYPE_DEFINITION) {
    return typeDef;
  }
  /* istanbul ignore next */
  throw new Error("unsupported type definition kind");
};

const renderObject = (ctx: CurrentContext, object: RenderableObject): RenderResult<AvailableKeys> => {
  if (object.typeNode.kind === Kind.NON_NULL_TYPE) {
    return renderNonNullObject(ctx, { ...object, typeNode: object.typeNode.type });
  }

  return bundle`${object.parentName} ? ${renderNonNullObject(ctx, {
    ...object,
    typeNode: object.typeNode,
  })}: undefined`;
};

const renderConnection = (
  ctx: CurrentContext,
  object: RenderableObject,
  opts: { pageParam: { first: number | undefined; after: string | undefined }; whose: RenderResult | null }
) => {
  const allNodes = bundle`${object.parentName}${opts.whose}()`;
  let nodes: RenderResult<AvailableKeys> | string = `${ALL_NODES_VAR_NAME}`;
  if (opts.pageParam.first !== undefined || opts.pageParam.after !== undefined) {
    nodes = bundle`${FUNCS.paginate}(${nodes}, ${JSON.stringify(opts.pageParam)}, ${FUNCS.extractId})`;
  }

  return bundle`
    (() => {
      const ${ALL_NODES_VAR_NAME} = ${allNodes};
      const ${NODES_VAR_NAME} = ${nodes};
      return {
        ${renderFields(ctx, object)}
      }
    })()
  `;
};

const renderNonNullObject = (ctx: CurrentContext, object: RenderableObject<NonNullTypeNode["type"]>) => {
  if (object.typeNode.kind === Kind.LIST_TYPE) {
    return bundle`${object.parentName}.map((elm) => {
      return { ${renderFields(ctx, { ...object, parentName: "elm" })} };
    })`;
  }

  return bundle`{ ${renderFields(ctx, object)} }`;
};

const renderInlineFragment = (ctx: CurrentContext, field: InlineFragmentNode, parentName: string | RenderResult) => {
  const typeNode = field.typeCondition;
  assertSome(typeNode);
  return bundle`...(() => {
    return ${FUNCS.extractClass}(${parentName}) === "${typeNode.name.value}"
      ? {
        ${renderFields(ctx, { parentName, selectedFields: field.selectionSet.selections, typeNode }, false)}
         __typename: "${typeNode.name.value}",
      }
      : {}
  })(),`;
};

const renderFragmentSpread = (ctx: CurrentContext, field: FragmentSpreadNode, parentName: string | RenderResult) => {
  const fs = ctx.fragments[field.name.value];
  return renderFields(
    ctx,
    { parentName, selectedFields: fs.selectionSet.selections, typeNode: fs.typeCondition },
    false
  );
};

const renderFields = (
  ctx: CurrentContext,
  object: RenderableObject,
  withReflection?: boolean
): RenderResult<AvailableKeys> => {
  const objectDef = mustFindTypeDefinition(ctx, object.typeNode);
  const isRecordType = hasDirective(objectDef, "recordType");

  let reflectionRequired =
    withReflection !== undefined ? withReflection : objectDef.kind === Kind.INTERFACE_TYPE_DEFINITION;

  const fields = object.selectedFields.map((field) => {
    if (field.kind === Kind.INLINE_FRAGMENT) {
      return renderInlineFragment(ctx, field, object.parentName);
    }
    if (field.kind === Kind.FRAGMENT_SPREAD) {
      return renderFragmentSpread(ctx, field, object.parentName);
    }
    if (field.name.value === "__typename") {
      reflectionRequired = true;
      return null;
    }
    const definition = objectDef.fields?.find((def) => def.name.value === field.name.value);
    assertSome(definition);
    return renderField(ctx, { parentName: object.parentName, field, definition }, { isRecordType });
  });

  if (reflectionRequired) {
    fields.push(bundle`__typename: ${FUNCS.extractClass}(${object.parentName}),`);
  }

  return join(fields.filter(isSome));
};

export const compile = (
  appName: string,
  info: Pick<GraphQLResolveInfo, "operation" | "fragments" | "variableValues" | "schema">,
  rootObjName?: string
) => {
  const field = info.operation.selectionSet.selections[0];
  if (field.kind !== Kind.FIELD || field.selectionSet === undefined) {
    /* istanbul ignore next */
    throw new Error(`unsupported node type or undefined selectionSet`);
  }

  const fieldGetter = info.operation.operation === "query" ? info.schema.getQueryType() : info.schema.getMutationType();
  const typeNode = fieldGetter?.getFields()[field.name.value].astNode?.type;
  assertSome(typeNode);

  const primarySelection = info.operation.selectionSet.selections[0];
  if (primarySelection.kind !== Kind.FIELD) {
    /* istanbul ignore next */
    throw new Error("Field is expected at top level selection set");
  }

  const selectedFields = field.selectionSet.selections;
  const rootName = rootObjName ?? "app";
  const convert = rootObjName ? "" : `const ${rootName} = Application("${appName}");`;

  const res = renderObject(info, {
    selectedFields,
    typeNode,
    parentName: rootName,
  });

  const library = buildLibrary(res.dependencies.functions);
  const vars = Object.entries(info.variableValues)
    .map(([k, v]) => (res.dependencies.variables.has(k) ? `const ${k} = ${JSON.stringify(v)};` : ""))
    .join("\n");

  return `${library};${vars};${convert};JSON.stringify({ result: ${res.body}})`;
};
