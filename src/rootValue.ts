import { GraphQLResolveInfo } from "graphql";
import { compile } from "./compiler";

export const buildRootValue = (appName: string, runner: (code: string) => Promise<unknown>) => {
  return new Proxy(
    {},
    {
      get: () => {
        return (_1: unknown, _2: unknown, _3: unknown, info: GraphQLResolveInfo) => {
          const code = compile(appName, info);
          return runner(code);
        };
      },
    }
  );
};
