export type RenderResult<FK extends string> = {
  kind: "RenderResult";
  body: string;
  dependencies: {
    variables: Set<string>;
    functions: Set<FK>;
  };
};

type FunctionDependency<FK extends string> = {
  kind: "FunctionDependency";
  name: FK;
};

export const bundle = <FK extends string>(
  strings: TemplateStringsArray,
  ...placeholders: (string | RenderResult<FK> | FunctionDependency<FK>)[]
): RenderResult<FK> => {
  let result = "";
  const dependencies = {
    variables: new Set<string>(),
    functions: new Set<FK>(),
  };
  for (let i = 0; i < placeholders.length; i++) {
    result += strings[i];
    const elm = placeholders[i];

    if (typeof elm === "string") {
      result += elm;
      continue;
    }

    if (elm.kind === "FunctionDependency") {
      result += elm.name;
      dependencies.functions.add(elm.name);
      continue;
    }

    if (elm.kind === "RenderResult") {
      result += elm.body;
      dependencies.functions = new Set([...dependencies.functions, ...elm.dependencies.functions]);
      dependencies.variables = new Set([...dependencies.variables, ...elm.dependencies.variables]);
      continue;
    }
  }
  result += strings[strings.length - 1];

  return { kind: "RenderResult", body: result, dependencies };
};

export const join = <FK extends string>(results: RenderResult<FK>[]): RenderResult<FK> => {
  const dependencies = {
    variables: results.map((r) => r.dependencies.variables).reduce((acum, cur) => new Set([...acum, ...cur])),
    functions: results.map((r) => r.dependencies.functions).reduce((acum, cur) => new Set([...acum, ...cur])),
  };
  return {
    kind: "RenderResult",
    body: results
      .sort((a, b) => a.body.localeCompare(b.body))
      .map((f) => f.body)
      .join(""),
    dependencies,
  };
};
