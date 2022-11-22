@:build(macros.BuildMacro.buildAxes())
@:enum abstract Axis2D(Axis<Axis2D>) to Axis<Axis2D> to Int {
    var horizontal;
    var vertical;
}

typedef AVector2D<T> = AVector<Axis2D, T>;
typedef ReadOnlyAVector2D<T> = AVector.ReadOnlyAVector<Axis2D, T>;
