package;

import haxe.ds.ReadOnlyArray;

abstract Axis<T:Axis<T>>(Int) to Int from Int {
    public static final k1:ReadOnlyArray<Int> = [0];
    public static final k2:ReadOnlyArray<Int> = [0, 1];
    public static final k3:ReadOnlyArray<Int> = [0, 1, 2];
    public static final k4:ReadOnlyArray<Int> = [0, 1, 2, 3];

    // public inline function next():T
    // 	throw "na";
    // public inline function hasNext()
    // 	return false;

    public inline function first():T {
        this = 0;
        return cast this;
    }

    // public inline function rest():AxisIterator<T> throw "n/a";
}
