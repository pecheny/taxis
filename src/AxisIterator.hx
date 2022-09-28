class AxisIterator<T:Int> {
	var min:Int;
	var max:Int;

	public inline function new(min:Int, max:Int) {
		this.min = min;
		this.max = max;
	}

	public inline function hasNext() {
		return min < max;
	}

	public inline function next():T {
		return cast min++;
	}
}
