@:enum abstract Axis2D(Axis) to Axis {
    var horizontal;
    var vertical;
}

typedef AxisCollection2D<T> = AVector<Axis2D, T>;