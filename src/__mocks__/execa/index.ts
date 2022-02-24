import { readFile } from "fs";
import { join } from "path";
import { promisify } from "util";

export default async (file: string, args: string[]) => {
  if (!["sdef", "cat"].includes(file)) {
    throw new Error("Unsupported command");
  }
  const path = join(__dirname, "__fixtures__", args[0]);
  const content = await promisify(readFile)(path);
  return { stdout: content.toString() };
};
