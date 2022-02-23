import { Kind, StringValueNode } from "graphql";

export function stringValue<T extends string | undefined>(value: T): T extends string ? StringValueNode : undefined;
export function stringValue(value: string | undefined): StringValueNode | undefined {
  if (value === undefined) {
    return undefined;
  }
  return {
    kind: Kind.STRING,
    value: value,
    block: true,
  };
}
