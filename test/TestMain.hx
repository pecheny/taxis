import macros.BuildMacroTest;
class TestMain {
    static function main() {
		utest.UTest.run([
			new BuildMacroTest(),
		]);
	}
 
}