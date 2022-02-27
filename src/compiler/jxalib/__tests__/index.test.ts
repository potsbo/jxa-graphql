import { library } from "../index";

test("pascalCase", () => {
  const input = "some name";
  const output = eval(`
    ${library}
    pascalCase("${input}");
  `);

  expect(output).toEqual("SomeName");
});

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const Automation = {
  getDisplayString: (obj: { getDisplayString: () => string | undefined } | undefined) => {
    return obj?.getDisplayString();
  },
};

test("extractId", () => {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const input = { getDisplayString: () => `Application("Calendar").calendars.byId("SOME-CALENDAR-ID-1234")` };
  const output = eval(`
    ${library}
    extractId(input);
  `);

  expect(output).toEqual("SOME-CALENDAR-ID-1234");
});

test("extractId complex", () => {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const input = {
    getDisplayString: () =>
      `Application("Calendar").calendars.byId("SOME-CALENDAR-ID-1234").events.byId("SOME-EVENT-ID-1234")`,
  };
  const output = eval(`
    ${library}
    extractId(input);
  `);

  expect(output).toEqual("SOME-EVENT-ID-1234");
});

test("extractId malformed", () => {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const input = {
    getDisplayString: () =>
      `Application("Calendar").calendars.byId("SOME-CALENDAR-ID-1234").events.byId("SOME-EVENT-ID-1234").someProp()`,
  };
  const output = eval(`
    ${library}
    extractId(input);
  `);

  expect(output).toEqual(null);
});

test("extractId int", () => {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const input = {
    getDisplayString: () => `Application("Google Chrome").windows.byId(1234)`,
  };
  const output = eval(`
    ${library}
    extractId(input);
  `);

  expect(output).toEqual(1234);
});

test("extractId undefined", () => {
  const output = eval(`
    ${library}
    extractId(undefined);
  `);

  expect(output).toEqual(null);
});

test("paginate no param", () => {
  const input = [{ id: 1 }, { id: 2 }, { id: 3 }, { id: 4 }, { id: 5 }, { id: 6 }, { id: 7 }, { id: 8 }];
  const output = eval(`
      ${library}
      const nodes = ${JSON.stringify(input)};
      paginate(nodes, {}, (elm) => elm.id);
    `);

  expect(output).toEqual(input);
});

test("paginate normal param", () => {
  const input = [{ id: 1 }, { id: 2 }, { id: 3 }, { id: 4 }, { id: 5 }, { id: 6 }, { id: 7 }, { id: 8 }];
  const output = eval(`
    ${library}
    const nodes = ${JSON.stringify(input)};
    paginate(nodes, { after: 3, first: 2 }, (elm) => elm.id);
  `);

  expect(output).toEqual([{ id: 4 }, { id: 5 }]);
});

test("paginate no match", () => {
  const input = [{ id: 1 }, { id: 2 }, { id: 3 }, { id: 4 }, { id: 5 }, { id: 6 }, { id: 7 }, { id: 8 }];
  const output = eval(`
    ${library}
    const nodes = ${JSON.stringify(input)};
    paginate(nodes, { after: 100, first: 2 }, (elm) => elm.id);
  `);

  expect(output).toEqual([]);
});

test("paginate asks too many", () => {
  const input = [{ id: 1 }, { id: 2 }, { id: 3 }, { id: 4 }, { id: 5 }, { id: 6 }, { id: 7 }, { id: 8 }];
  const output = eval(`
    ${library}
    const nodes = ${JSON.stringify(input)};
    paginate(nodes, { after: 2, first: 100 }, (elm) => elm.id);
  `);

  expect(output).toEqual([{ id: 3 }, { id: 4 }, { id: 5 }, { id: 6 }, { id: 7 }, { id: 8 }]);
});
