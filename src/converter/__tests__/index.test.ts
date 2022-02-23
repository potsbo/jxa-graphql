import gql from "graphql-tag";
import { build } from "..";

test("build", async () => {
  // TODO: make this runnable in CI
  expect(
    await build(
      "/Applications/OmniFocus.app",
      gql`
        scalar RichText
      `
    )
  ).toMatchSnapshot("omnifocus.graphql");
});

test("build", async () => {
  // TODO: make this runnable in CI
  expect(await build("/System/Applications/Calendar.app")).toMatchSnapshot("calendar.graphql");
});
