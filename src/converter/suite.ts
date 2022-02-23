import { ClassBuilder } from "./class";
import { EnumBuilder } from "./enumeration";
import { ExtensionBuilder } from "./extension";
import { RecordTypeBuilder } from "./recordType";
import { Builder, Sdef, Suite } from "./sdef";

const parseSuite = (s: Suite): Builder[] => {
  const extensionBuilders = (s["class-extension"] ?? []).map((c) => new ExtensionBuilder(c));
  const classBuilders = (s.class ?? []).map((c) => new ClassBuilder(c));
  const recordTypeBuilders = (s["record-type"] ?? []).map((c) => new RecordTypeBuilder(c));
  const enumBuilders = (s.enumeration ?? []).map((e) => new EnumBuilder(e));
  return [...classBuilders, ...extensionBuilders, ...recordTypeBuilders, ...enumBuilders];
};

export const parseSuites = (
  sdef: Sdef
): {
  includes: string[];
  builders: Builder[];
} => {
  const includes: string[] = [];
  const ss = sdef.dictionary.suite;

  ss.forEach((s) => {
    if (s["xi:include"] !== undefined) {
      s["xi:include"].forEach((i) => {
        const prefix = "file://";
        if (!i.$.href.startsWith(prefix)) {
          throw new Error(`Unsupported include found ${i.$.href}`);
        }
        const path = i.$.href.slice(prefix.length);
        includes.push(path);
      });
    }
  });

  const builders = ss.map(parseSuite).reduce((acum, cur) => [...acum, ...cur], []);
  return { builders, includes };
};
