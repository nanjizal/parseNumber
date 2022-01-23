package parseNumber;

import utest.Runner;
import utest.Test;
import utest.ui.Report;
import equals.Equal;
import utest.Assert;
// subfolders
import parseNumber.ParseNumber;

@:build(hx.doctest.DocTestGenerator.generateDocTests())
@:build(utest.utils.TestBuilder.build())
class ParseTest extends utest.Test {
    public static function main() {
        var runner = new Runner();
        runner.addCase( new ParseTest() );
        Report.create(runner);
        runner.run();
    }
    function new() {
        super();
    }
}
