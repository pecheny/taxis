package;

import haxe.iterators.ArrayIterator;
import Axis;

class AxisTest {
	public static function main() {
		trace("hi");
		for (a in RealAxis)
			trace(a);
		new ContainerSmpl<RealAxis>();
	}
}

@:enum abstract RealAxis(Int) to Int {
	var one = 0;
	var two = 1;

	public function toString() {
		return "111";
	}

	static var keys:Array<RealAxis> = cast [0, 1];

	public static function iterator():ArrayIterator<RealAxis> {
		return keys.iterator();
	}
}

// typedef TAxisTD = {
// 	public static function iterator():ArrayIterator<RealAxis> {}
// }

@:generic
class ContainerSmpl<TAxis:Int> {
	var layoutMap:AVector<TAxis, String>;

	public function new() {
		layoutMap = AAA.factoryCreate(TAxis, a -> "");
		// AAA.iterator(TAxis);
		// AAA.iterator(RealAxis);
		for (a in layoutMap.axes()) {
			// var b:TAxis = a;
			// var b = 0;
			// trace(a , b);
			trace(a);
			trace("" + a);
			// trace(a  + " " +  b);
		}

		// for (a in TAxis)
		// var om:AxisCollection<Float> = AAA.create(RealAsix, 1., 2);
		trace(layoutMap);
	}
}
