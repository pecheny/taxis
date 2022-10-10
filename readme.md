## TAxis
The library meant for writing manipulation with vectors set in arbitrary user-defined coordinate space (set of axes).
For example, visual layout/distribution  library can be written once and then used in 2d, 3d or radial space. The user should provide set of axes in @:enum abstract(Int) form.
The vector (```AVector```) is an abstract on top of underlying ```haxe.ds.Vector```. Saying about Cartesian 2d space ```AVector<Axis2D, Float>``` is an alternative for ```flash.geom.Point``` but with ability to pick exact component in runtime without reflection.

```haxe
    var axis = Axis2D.horizontal;
    trace(vector[axis]);
```

```haxe
    for (axis in Axis2D) 
        trace(vector[axis]);
```

## TODO
* put factoryCreate() to appropriate place
* write readme
* generate inline getters according to axis aliases.
* [minor] is it possible to autodetect n for factoryCreate() calls in @:generic classes