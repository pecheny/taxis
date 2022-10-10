package macros;

import utest.Assert;
import utest.Test;
import TestAxis;

class BuildClientTest extends Test {
	public function testbBuildingClient() {
		var it:Iterator<TestAxis> = TestAxis.iterator();
		for (a in it) {
			var a1:TestAxis = a;
		}
		var tavec:AVector<TestAxis, TestAxis> = AVConstructor.factoryCreate(TestAxis, a -> a); // can infere type by declared one
		var tavec:AVector<TestAxis, String> = AVConstructor.factoryCreate(TestAxis, a -> "" + a);//Can unify campatible types
		var tavec = AVConstructor.factoryCreate(TestAxis, a -> "" + a); //can infere type according to ret type of the fac
		var val = tavec[one];
		Assert.isOfType(val, String);
		var c = new ContainerSmpl<TestAxis>(3);
		Assert.same(["zero zero", "one one", "two two"], c.tostrings); // test toString in generic user classes
	}
}

@:generic
class ContainerSmpl<TAxis:Axis<TAxis>> {
	var layoutMap:AVector<TAxis, String>;

	public var tostrings:Array<String>;

	public function new(n) {
		layoutMap = AVConstructor.factoryCreate(TAxis, a -> "" + a, n);
		tostrings = [for (a in layoutMap.axes()) layoutMap[a] + " " + a];
	}
}
