package macros;

import macros.BuildClient;
import utest.Test;

class BuildClientTest extends Test {
	public function tebBuildingClient() {
		var c = new ContainerSmpl<TestAxis>();
	}

}

// @:genericBuild(macros.BuildClient.build())
@:autoBuild(macros.BuildClient.build2())
class AxisUser<T> {
	
}
@:generic class ContainerSmpl<TAxis:Axis<TAxis>> extends AxisUser<TAxis>{
	var layoutMap:AVector<TAxis, String>;

	public var tostrings:Array<String>;

	public function new() {
		// layoutMap.axes
		// trace("smpl");
		// var a:TAxis;
		// a.first();
		// for (a in a.rest())
		// 	trace(a);

		// 	var layoutMap = AAA.factoryCreate(TAxis, a -> "" + a);
		// 	// var layoutMap = AAA.fc2(TAxis, a -> "" + a);
		// 	tostrings = [for (a in layoutMap.axes()) layoutMap[a]];
	}
}
