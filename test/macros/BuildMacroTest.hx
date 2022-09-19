package macros;

import utest.Assert;
import utest.Test;

class BuildMacroTest extends Test {
	public function testAxisBuilding() {
		Assert.equals("one", "" + TestAxis.one); // test toString() generation
		Assert.equals(1, TestAxis.one);
		Assert.equals(0, TestAxis.zero);

		var iterated = [for (a in TestAxis) a];
		Assert.same([zero, one, two], iterated);
	}

	function dummyFactory(a:TestAxis) {
		return "" + a;
	}

	public function testAVector() {
		// Assert.raises(() -> AAA.create(TestAxis, TestAxis.one, TestAxis.two), null, "Should fail on wrong number of args"); -- fails in compile time.
		var avec = AAA.create(TestAxis, TestAxis.zero, TestAxis.one, TestAxis.two);
		Assert.equals(TestAxis.zero, avec[zero]);
		Assert.equals(TestAxis.zero.toString(), "" + avec[zero]);
		var avec2:AVector<TestAxis, Dummy> = AAA.factoryCreate(TestAxis, a -> new Dummy(a)); // check type inference for arrow function argument
		Assert.equals(one, avec2[one].a);
		var avec3:AVector<TestAxis, String> = AAA.factoryCreate(TestAxis, dummyFactory); // check type inference for method reference
		Assert.equals(TestAxis.zero.toString(), "" + avec3[zero]);
	}

	// public function testGenericUserClass() {
	// 	var csmpl = new ContainerSmpl<TestAxis>();
	// 	Assert.same(["zero", "one", "two"], csmpl.tostrings); // test toString in generic user classes
	// }
}

class Dummy {
	public var a:TestAxis;

	public function new(a) {
		this.a = a;
	}
}

@:build(macros.BuildMacro.buildAxes())
@:enum abstract TestAxis(Axis) to Axis {
	var zero;
	var one;
	var two;
}

@:generic
class ContainerSmpl<TAxis:Axis> {
	var layoutMap:AVector<TAxis, String>;
	public var tostrings:Array<String>;

	public function new() {
		var layoutMap = AAA.factoryCreate(TAxis, a -> "" + a);
		// var layoutMap = AAA.fc2(TAxis, a -> "" + a);
		tostrings = [for (a in layoutMap.axes()) layoutMap[a]];
	}
}
