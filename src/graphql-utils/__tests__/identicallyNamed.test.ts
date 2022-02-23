import { identicalyNamed } from "..";

test("identicalyNamed both unnamed", () => {
  expect(identicalyNamed({}, {})).toBe(false);
});
