import haxe.macro.Expr.ExprOf;

abstract AVector<TAxis:Axis<TAxis>, T>(haxe.ds.Vector<T>) {
    // @:generic inline public static function factoryCreate<TAxis:Axis, T>( fac:TAxis->T):AVector<TAxis, T> {
    // 	return cast new haxe.ds.Vector<Int>(2);
    // 	// return macro cast new haxe.ds.Vector<Int>(TAxis.aliases.length);
    // }
    @:arrayAccess public inline function get(a:TAxis):T {
        return this[a];
    }

    @:arrayAccess public inline function set(a:TAxis, val:T):T
        return this[a] = val;

    public inline function axes():AxisIterator<TAxis> {
        return new AxisIterator(0, this.length);
    }

    @:to public inline function readonly():ReadOnlyAVector<TAxis, T> {
        return cast this;
    }

    public inline function copy():AVector<TAxis, T> {
        return cast this.copy();
    }
}

abstract ReadOnlyAVector<TAxis:Axis<TAxis>, TVal>(haxe.ds.Vector<TVal>) {
    @:arrayAccess public inline function get(a:TAxis):TVal {
        return this[a];
    }

    public inline function axes():AxisIterator<TAxis> {
        return new AxisIterator(0, this.length);
    }
}
