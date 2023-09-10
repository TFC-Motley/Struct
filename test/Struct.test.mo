import {test; suite; skip} "mo:test";
import {main = schema_suite} "modules/Schema";
import {main = generator_suite} "modules/Generator";
import {main = sequencer_suite} "modules/Sequencer";
import {main = buffer_suite} "modules/Buffer";

schema_suite();
generator_suite();
sequencer_suite();
buffer_suite();