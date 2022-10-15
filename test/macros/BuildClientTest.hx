package macros;

import utest.Assert;
import utest.Test;
import TestAxis;

class BuildClientTest extends Test {
    function test_unify_with_typedef() {
        var tavec:TestAVector<Array<String>> = AVConstructor.factoryCreate(TestAxis, a -> ["" + a]);
        var compatType = Type.getClass(new haxe.ds.Vector<Array<String>>(1));
        Assert.isOfType(tavec, compatType);
    }

    function test_unify_with_null_ret() {
        var tavec:AVector<TestAxis, Array<String>> = AVConstructor.factoryCreate(TestAxis, a -> null); // can infere type by declared one
        var compatType = Type.getClass(new haxe.ds.Vector<Array<String>>(1));
        Assert.isOfType(tavec, compatType);
        Assert.isNull(tavec[one]);
        tavec[zero] = ["foo"];
        Assert.same(["foo"], tavec[zero]);
    }

    function test_unify_compatible_types() {
        var tavec:AVector<TestAxis, String> = AVConstructor.factoryCreate(TestAxis, a -> "" + a); // Can unify compatible types
        Assert.notNull(tavec);
        var tavec2:AVector<TestAxis, TestAxis> = AVConstructor.factoryCreate(TestAxis, a -> a); // can infere type by declared one
        Assert.equals(1, tavec2[one]);
        Assert.equals("one", "" + tavec2[one]);
    }

    function test_axis_usage_in_generic_user_class() {
        var c = new ContainerSmpl<TestAxis>(3);
        Assert.same(["zero zero", "one one", "two two"], c.tostrings); // test toString in generic user classes
    }

    function test_empty() {
        var c = new ContainerSmpl<TestAxis>(3);
        var empty:AVector<TestAxis, Dummy> = c.empty;
        Assert.isNull(empty[two]);
    }

    function test_can_infere_type_according_to_ret_type_of_the_fac() {
        var tavec = AVConstructor.factoryCreate(TestAxis, a -> "" + a); // can infere type according to ret type of the fac
        var val = tavec[one];
        Assert.isOfType(val, String);

        var avec2:AVector<TestAxis, Dummy> = AVConstructor.factoryCreate(TestAxis, a -> new Dummy(a)); // check type inference for arrow function argument
        Assert.equals(one, avec2[one].a);
    }

    function test_can_unify_with_more_general_declared() {
        var avec2:AVector<TestAxis, IDummy> = AVConstructor.factoryCreate(TestAxis, a -> new Dummy(a)); // check type inference for arrow function argument
        Assert.isOfType(avec2[zero], IDummy);
        Assert.isOfType(avec2[zero], Dummy);
    }

    function test_create_can_unify_with_more_general_declared() {
        var avec2:AVector<TestAxis, IDummy> = AVConstructor.create(TestAxis, new Dummy(zero), new Dummy(zero),
            new Dummy(zero)); // check type inference for arrow function argument
        Assert.isOfType(avec2[zero], IDummy);
        Assert.isOfType(avec2[zero], Dummy);
    }

    function test_can_ommit_axis_with_explicit_expected() {
        var tavec:AVector<TestAxis, String> = AVConstructor.factoryCreate(a -> "" + a);
        Assert.equals("one", tavec[one]);
    }

    function test_create_can_ommit() {
        var avec2:AVector<TestAxis, IDummy> = AVConstructor.create(new Dummy(zero), new Dummy(zero),
            new Dummy(zero)); // check type inference for arrow function argument
        Assert.isOfType(avec2[zero], IDummy);
        Assert.isOfType(avec2[zero], Dummy);
    }

    function test_factoryCreate_with_method_reference() {
        var avec3:AVector<TestAxis, String> = AVConstructor.factoryCreate(TestAxis, dummyFactory); // check type inference for method reference
        Assert.equals(TestAxis.zero.toString(), "" + avec3[zero]);
    }

    function dummyFactory(a:TestAxis) {
        return "" + a;
    }

    public function test_create() {
        // Assert.raises(() -> AVConstructor.create(TestAxis, TestAxis.one, TestAxis.two), null, "Should fail on wrong number of args"); -- fails in compile time.
        var avec = AVConstructor.create(TestAxis, TestAxis.zero, TestAxis.one, TestAxis.two);
        Assert.equals(TestAxis.zero, avec[zero]);
        Assert.equals(TestAxis.zero.toString(), "" + avec[zero]);

        var avec2:AVector<TestAxis, IDummy> = AVConstructor.create(new Dummy(zero), new Dummy(zero), new Dummy(zero));
        Assert.isOfType(avec2[zero], IDummy);
        Assert.isOfType(avec2[zero], Dummy);

        var avec3:TestAVector<Float> = AVConstructor.create(0., 0., 0.);
        var avec3:TestAVector<Float> = AVConstructor.create(TestAxis, 0., 0., 0.);
        Assert.equals(0., avec3[zero]);
    }
}

class Dummy implements IDummy {
    public var a:TestAxis;

    public function new(a) {
        this.a = a;
    }
}

interface IDummy {}
typedef TestAVector<T> = AVector<TestAxis, T>

@:generic
class ContainerSmpl<TAxis:Axis<TAxis>> {
    var layoutMap:AVector<TAxis, String>;

    public var empty:AVector<TAxis, Dummy>;
    public var tostrings:Array<String>;

    public function new(n) {
        layoutMap = AVConstructor.factoryCreate(TAxis, a -> "" + a, n);
        tostrings = [for (a in layoutMap.axes()) layoutMap[a] + " " + a];
        empty = AVConstructor.empty(n);
    }
}
