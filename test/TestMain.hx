import macros.*;
class TestMain {
    static function main() {
		utest.UTest.run([
			new BuildMacroTest(),
			new BuildClientTest()
		]);
	}
}