const AVAILABLES = {
  extractClass,
  extractId,
  paginate,
} as const;

export type AvailableKeys = keyof typeof AVAILABLES;

export const buildLibrary = (dependencies: Set<AvailableKeys>) => {
  const keys = Array.from(dependencies.values()).sort();
  return keys.map((k) => AVAILABLES[k].toString()).join("\n");
};

export const library = `
${extractClass.toString()}
${extractId.toString()}
${paginate.toString()}
`;

export const FUNCS = {
  extractClass: {
    kind: "FunctionDependency",
    name: "extractClass",
  },
  extractId: {
    kind: "FunctionDependency",
    name: "extractId",
  },
  paginate: {
    kind: "FunctionDependency",
    name: "paginate",
  },
} as const;

declare const Automation: {
  getDisplayString: (obj: unknown) => string | undefined;
};
declare const ObjectSpecifier: {
  classOf: (obj: unknown) => string | undefined;
};
/* eslint-disable @typescript-eslint/no-non-null-assertion */
function extractClass(obj: unknown) {
  const s = ObjectSpecifier.classOf(eval(Automation.getDisplayString(obj)!))!;
  return (s.match(/[a-zA-Z0-9]+/g) || []).map((w) => `${w[0].toUpperCase()}${w.slice(1)}`).join("");
}
/* eslint-enable @typescript-eslint/no-non-null-assertion */

function extractId(obj: unknown) {
  const spec = Automation.getDisplayString(obj);
  if (spec === undefined) {
    return null;
  }
  let inStr = false;
  let ret = "";
  let nextEscape = null;
  for (let i = 0; i < spec.length; i++) {
    const c = spec[i];
    const inEscape = nextEscape === i;

    if (c === "\\") {
      nextEscape = i + 1;
      continue;
    }
    if (!inEscape && c === '"') {
      inStr = !inStr;
      continue;
    }

    if (!inStr) {
      if (c === "(") {
        ret = "";
        continue;
      }
      if (c === ")") {
        continue;
      }
    }

    ret = `${ret}${c}`;
  }

  return ret !== "" ? ret : null;
}

function paginate<T>(nodes: T[], { first, after }: { first?: number; after?: string }, getId: (elm: T) => string): T[] {
  const afterIndex = after === undefined ? undefined : nodes.findIndex((n) => getId(n) === after);
  if (afterIndex === -1) {
    return [];
  }
  const start = afterIndex === undefined ? 0 : afterIndex + 1;
  const end = first !== undefined ? start + first : undefined;
  return nodes.slice(start, end);
}
