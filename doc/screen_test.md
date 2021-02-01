## Screen Tests

In addition to standard RSpec tests, WhirledPeas has custom tests for rendered templates. These files live in `screen_test/`. Each ruby file is expected to define a class named `TemplateFactory` that responds to `#build(name, args)` returning a template (this is the standard template factory role). Each file should also be accompanied by a `.frame` file with the same base name. This file will contain the output of the rendered screen and is considered the correct output when running tests. Use the `--view` flag to create the `.frame` file for an individual test or the `--view-pedning` flag to interactively create `.frame` files for all tests that do not have one.

Note: viewing `.frame` files with `cat` works better than most other text editors.

```
Usage: screen_test [file] [options]

If not file or options are provide, all tests are run

If no file is provided, the supported options are
    --help             print this usage statement and exit
    --view-pending     interactively display and optionally save rendered output for each pending test
    --view-failed      interactively display and optionally save rendered output for each faiing test

If a screen test file is provided as the first argument, the supported options are
    --run        run screen test for given file
    --view       interactively display and optionally save the file's test output
    --template   print out template tree for the test template
    --debug      render the test template without displying it, printing out debug information
```
