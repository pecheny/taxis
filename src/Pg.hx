import haxe.iterators.ArrayIterator;

class Pg {
	static function main() {
		trace("Haxe is great!");
		var vc = new haxe.ds.Vector<Int>(2);
		for (v in vc)
			trace(v);

		var bar = Bar.a;
		//  Foo.b.key();
		Bar.a.key();
	}
}

// @:forward(key)
@:enum abstract Bar(Foo) {
	var a = 0;

	public function key() {
		this.key();
	}
}

// @:build(Macro.build())
@:enum abstract Foo(Int) from Int {
	var b = 0;

	public macro function key(eth) {
		trace("" + haxe.macro.Context.getLocalType());
		trace(haxe.macro.Context.getLocalClass());
		trace(haxe.macro.Context.typeof(eth));
		return macro trace("key \n" + $v{haxe.macro.Context.getClassPath().join("")});

	}

    // public static function iterator() {
    //     return new ArrayIterator
    // }
}
