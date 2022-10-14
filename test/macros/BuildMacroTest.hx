package macros;

import utest.Assert;
import utest.Test;
import TestAxis;

class BuildMacroTest extends Test {
	public function test_toString_toInt() {
		Assert.equals("one", "" + TestAxis.one); 
		Assert.equals(1, TestAxis.one);
		Assert.equals(0, TestAxis.zero);
	}

    public function test_axis_iterator() {
        var arr = [for (a in TestAxis) "" + a];
        Assert.same(["zero", "one", "two"], arr);
		var iterated = [for (a in TestAxis) a];
		Assert.same([zero, one, two], iterated);
    }

    public function test_fromInt() {
        var a = TestAxis.fromInt(2);
        Assert.equals(two, a);
        Assert.raises(()->{var a = TestAxis.fromInt(3);
        trace(a);} );
    }

}