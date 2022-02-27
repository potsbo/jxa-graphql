export const library = `
${pascalCase.toString()}
${extractId.toString()}
${paginate.toString()}
`;

function pascalCase(s: string) {
  return (s.match(/[a-zA-Z0-9]+/g) || []).map((w) => `${w[0].toUpperCase()}${w.slice(1)}`).join("");
}

declare const Automation: {
  getDisplayString: (obj: unknown) => string | undefined;
};

function extractId(obj: unknown) {
  const spec = Automation.getDisplayString(obj);
  return JSON.parse(
    spec
      ?.split("byId")
      .reverse()[0]
      .match(/^\(([^\)]+)\)$/)
      ?.reverse()[0] ?? "null"
  );
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
