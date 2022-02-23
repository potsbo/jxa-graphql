import { DocumentNode, DefinitionNode } from "graphql";

export interface Sdef {
  dictionary: { suite: Suite[] };
}

export interface Environment {
  builders: Builder[];
  override?: DocumentNode;
}

export interface Suite {
  $: {
    code: string;
    description: string;
    name: string;
  };
  command: unknown[];
  class?: ClassDefinition[];
  "record-type": RecordTypeDefinition[];
  "value-type": unknown[];
  "class-extension": ClassExtensionDefinition[];
  enumeration?: EnumDefinition[];
  "xi:include"?: Include[];
}

interface Include {
  $: {
    href: string;
    xpointer: string;
  };
}

export interface ClassDefinition {
  $: {
    code: string;
    description: string;
    name: string;
    inherits?: string;
  };
  property?: PropertyDefinition[];
  element?: ElementDefinition[];
  contents?: ContentDefinition[];
}

export interface ClassExtensionDefinition {
  $: {
    code: string;
    description: string;
    extends: string;
    inherits?: string;
  };
  property?: PropertyDefinition[];
  element?: ElementDefinition[];
  contents?: ContentDefinition[];
}

export interface RecordTypeDefinition {
  $: {
    code: string;
    description?: string;
    name: string;
    inherits?: string;
    hidden?: "yes";
  };
  property?: PropertyDefinition[];
  element?: ElementDefinition[];
  contents?: ContentDefinition[];
}

export type PropertyDefinition =
  | {
      $: {
        code: string;
        description: string;
        name: string;
        type: string;
        optional?: "yes";
        access?: "r";
      };
    }
  | {
      $: {
        code: string;
        description: string;
        name: string;
      };
      type: { $: { list?: "yes"; type: string } }[];
    };

export type ElementDefinition = {
  $: {
    description: string;
    type: string;
  };
  cocoa: [{ $: { key: string } }];
};

export type EnumDefinition = {
  $: {
    name: string;
    description?: string;
    type: string;
  };
  enumerator: { $: { code: string; description: string; name: string } }[];
};

export type ContentDefinition = {
  $: {
    access: string;
    code: string;
    description: string;
    name: string;
    type: string;
  };
  cocoa: [{ $: unknown[] }];
};

export type Builder = { build: (_: Environment) => DefinitionNode[] };
