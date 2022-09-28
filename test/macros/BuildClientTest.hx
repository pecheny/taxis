package macros;

import utest.Test;

class BuildClientTest extends Test {
	public function tebBuildingClient() {
		var c = new ContainerSmpl<TestAxis>();
	}

}

@:genericBuild(macros.BuildClient.build())
class ContainerSmpl<TAxis:Axis<TAxis>> {
	var layoutMap:AVector<TAxis, String>;

	public var tostrings:Array<String>;

	public function new() {
		trace("smpl");
		var a:TAxis;
		a.first();
		// for (a in a.rest())
		// 	trace(a);

		// 	var layoutMap = AAA.factoryCreate(TAxis, a -> "" + a);
		// 	// var layoutMap = AAA.fc2(TAxis, a -> "" + a);
		// 	tostrings = [for (a in layoutMap.axes()) layoutMap[a]];
	}
}
