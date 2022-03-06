#!/usr/bin/env node

import { run } from "./run";

run(process).catch((err) => console.error(err));
