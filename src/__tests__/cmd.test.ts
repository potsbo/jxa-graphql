import mockArgv from "mock-argv";
import { run } from "../run";
import axios from "axios";
import { ServerInfo } from "apollo-server";

test("Calendar - server", async () => {
  await mockArgv(["serve", "/System/Applications/Calendar.app", "-p", "4001"], async () => {
    const mockStdout = jest.spyOn(process.stdout, "write");
    const readyText = new Promise<boolean>((resolve) => {
      mockStdout.mockImplementation((str: string | Uint8Array): boolean => {
        if (typeof str === "string" && str.includes("🚀  Server ready at http://localhost:4001/")) {
          resolve(true);
        }
        return true;
      });
    });

    const { server } = (await run(process)) as ServerInfo;
    expect(await readyText).toBe(true);

    const resp = await axios.post(
      "http://localhost:4001/",
      { query: "query { __typename }", variables: {} },
      {
        headers: {
          "Content-Type": "application/json",
        },
      }
    );

    expect(resp.data).toMatchInlineSnapshot(`
      Object {
        "data": Object {
          "__typename": "Query",
        },
      }
    `);

    server.close();

    mockStdout.mockRestore();
  });
});

test("Calendar - schema", async () => {
  await mockArgv(["schema", "/System/Applications/Calendar.app"], async () => {
    const mockStdout = jest.spyOn(process.stdout, "write");
    const output = new Promise<string>((resolve) => {
      mockStdout.mockImplementation((str: string | Uint8Array): boolean => {
        if (typeof str === "string") {
          resolve(str);
        }
        return true;
      });
    });

    await run(process);
    expect(await output).toMatchSnapshot()

    mockStdout.mockRestore();
  });
});
