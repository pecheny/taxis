package macros;

import utest.Assert;
import macros.BuildClient;
import utest.Test;

class BuildClientTest extends Test {
	public function testbBuildingClient() {
		var it:Iterator<TestAxis> = TestAxis.iterator();
		for (a in it) {
			var a1:TestAxis = a;
		}
		var tavec:AVector<TestAxis, String> = AAA.factoryCreate(TestAxis, a -> "" + a);
		trace(tavec[TestAxis.one]);
		var c = new ContainerSmpl<TestAxis>(3);
		Assert.same(["zero zero", "one one", "two two"], c.tostrings); // test toString in generic user classes
	}
}

@:generic
class ContainerSmpl<TAxis:Axis<TAxis>> {
	var layoutMap:AVector<TAxis, String>;

	public var tostrings:Array<String>;

	public function new(n) {
		layoutMap = AAA.factoryCreate(TAxis, a -> "" + a, n);
		tostrings = [for (a in layoutMap.axes()) layoutMap[a] + " " + a];
	}
}
