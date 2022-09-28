class ImplicitToString {
	static function main() {
        trace([ new A(1) ]);
        new User([ new A(1) ]);
        new User([ new ClWToString() ]);
        new User2(new A(1));
        new User2(new ClWToString());
    }
}

abstract A(Int) {
	public inline function new(a) {
		this = a;
	}

	public inline function foo() {trace("foo");}
	public inline function toString() {
		return "fff";
	}
}

class ClWToString {
	public inline function new() {}

	public inline function foo() {trace("foo");}
	public inline function toString() {
		return "fff";
	}
}
@:generic
class User2<T> {
    public function new(a:T) {
        trace(a);
    }
}


@:generic
class User<T> {
	var a:Array<T>;

	public function new(a:Array<T>) {
		this.a = a;
		for (aa in a) {
            trace(aa);
			trace(a, "" + aa);
            var bb:T = aa;
            trace(bb);
        }
	}
}
