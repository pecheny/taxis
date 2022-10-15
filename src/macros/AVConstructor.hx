package macros;

import haxe.EnumTools;
import haxe.macro.Type.ClassType;
import macros.BuildMacro;
import haxe.macro.Expr;
import haxe.macro.*;
import Type as HType;

using haxe.macro.ComplexTypeTools;
using haxe.macro.TypeTools;
using haxe.macro.ExprTools;
using Std;
using macros.AVConstructor;

class AVConstructor {
    public static macro function create<T>(extra:Array<Expr>) {
        var expectedAxis = extractExpectedAxis(Context.getExpectedType());
        var n = 0;
        if (expectedAxis != null) { // type of expected AVector is set explicit
            n = BuildMacro.calcNumOfvals(expectedAxis);
            if (extra.length == n + 1) {
                var at = getAxisType(extra.shift());
            }
        } else { // treat first arg as axisType
            expectedAxis = getAxisType(extra.shift());
            n = BuildMacro.calcNumOfvals(expectedAxis);
        }

        if (n != extra.length)
            Context.fatalError('AVector of $expectedAxis should contain $n elements, but you pass ${extra.length}', Context.currentPos());

        var valCt0 = Context.typeof(extra[0]);

        var expected = extractExpected(Context.getExpectedType());
        if (expected == null)
            expected = Context.typeof(extra[0]);

        var type = Context.typeof(extra[0]);
        for (arg in extra) {
            var argT = Context.typeof(arg);
            Context.unify(expected, argT);
        }

        var valCt = expected.follow().toComplexType();
        var axct = expectedAxis.toComplexType();
        var vectorCt = macro:AVector<$axct, $valCt>;
        var assignExprs = [];
        for (i in 0...n)
            assignExprs.push(macro av[cast $v{i}] = ${extra[i]});
        return macro {
            var av:$vectorCt = cast new haxe.ds.Vector<$valCt>($v{n});
            $b{assignExprs};
            av;
        };
    }

    /**
        Generates code of creating a AVector<TAxis, T>
        @param axisCl - [optional] type of axis.
        @param fac - factory method to create values. T in the resulting AVector would be of type returning by the fac.
        @param nm - [optional] number of axes in the given enum. Should be provided for calls from @:generic classes when there is no way to calculate it during generation step and can be omitted otherwise.
    **/
    public static macro function factoryCreate<TAxis:Axis<TAxis>, T>(?axisCl:ExprOf<Class<TAxis>>, ?fac:ExprOf<TAxis->T>, ?nm:Expr) {
        if (fac.isNull() && nm.isNull()) { // handle omitted axisCl
            fac = axisCl;
            axisCl = null; // extractExpectedAxis(Context.getExpectedType());
            // if (axisCl == null)
        }
        var facT = Context.typeof(fac);
        var facCt = facT.toComplexType();
        var valCt0 = if (facT != null) switch facT {
            case TFun(args, ret):
                ret;
            case _:
                Context.fatalError("Can't infere factory function type: \n" + facT + "\n " + fac.toString(), Context.currentPos());
        } else {
            Context.fatalError("Can't infere factory function type: \n" + fac + "\n " + fac.toString(), Context.currentPos());
        }

        var expected = extractExpected(Context.getExpectedType());
        var valCt = if (expected != null) {
            Context.unify(expected, valCt0);
            expected.follow().toComplexType();
        } else {
            valCt0.follow().toComplexType();
        }

        if (valCt == null)
            Context.fatalError("Factory function returns incompatible type " + valCt0.toString(), Context.currentPos());

        var axisType = if (axisCl != null) getAxisType(axisCl) else extractExpectedAxis(Context.getExpectedType());
        if (axisType == null)
            Context.fatalError("Cant detext axis type. You should either do set explicit expected type of AVector or pass axis type as first argument",
                Context.currentPos());

        var axisComplex = axisType.toComplexType();
        var ft = macro:$axisComplex -> $valCt;
        var assignExprs:Array<Expr>;
        var countExpr:Expr = null;
        countExpr = switch nm.expr {
            case EConst(CIdent("null")):
                macro $v{BuildMacro.calcNumOfvals(axisType)};
            case EConst(CIdent(s)):
                macro $i{s};
            case EConst(CInt(_.parseInt() => s)):
                macro $v{s};
            case _:
                Context.fatalError("Only int const or int variable can be used as nm argument", Context.currentPos());
                throw "Wrong";
        }
        var vectorCt = macro:AVector<$axisComplex, $valCt>;
        var assignExprs:Array<Expr> = [
            macro for (i in 0...$countExpr)
                av[cast i] = _fac(cast i)
        ];

        var expr = macro {
            var _fac:$ft = $fac;
            var av:$vectorCt = cast new haxe.ds.Vector<$valCt>($countExpr);
            $b{assignExprs};
            av;
        }
        return expr;
    }

    static function isNull(e:Expr) {
        if (e == null)
            return true;
        return switch e.expr {
            case EConst(CIdent("null")): true;
            case _: false;
        }
    }

    static function extractExpectedAxis(t:Type) {
        if (t == null)
            return null;
        return switch t {
            case TAbstract(_.get() => {name: "AVector"}, [ax, _]):
                ax;
            case TType(_.get() => dt, params):
                #if macro
                var t:Type = TypeTools.applyTypeParameters(dt.type, dt.params, params);
                #end
                extractExpectedAxis(t);
            case _: null;
        }
    }

    static function extractExpected(t:Type) {
        if (t == null)
            return null;
        return switch t {
            case TAbstract(_.get() => {name: "AVector"}, [_, t]):
                t;
            case TType(_.get() => dt, params):
                #if macro
                var t:Type = TypeTools.applyTypeParameters(dt.type, dt.params, params);
                #end
                extractExpected(t);
            case _: null;
        }
    }

    static function getAxisType(axisCl) {
        #if macro
        var typeName = ExprTools.toString(axisCl);
        var ct = MacroStringTools.toComplex(typeName);
        var cl = Context.resolveType(ct, Context.currentPos());
        return cl;
        #end
    }

    // macro public static function iterator(cl) {
    // 	var nm = findStrings(cl);
    // 	// trace(cl + " " + nm);
    // 	var tt = haxe.macro.Context.getType(nm);
    // 	// trace(tt + " " + TypeTools.follow(tt));
    // 	var ct = Context.getLocalClass().get();
    // 	// trace(Context.getLocalTVars() + " " + ct.kind);
    // 	// TypeTools.follow();
    // 	return macro null;
    // }
    // static function findStrings(e:Expr) {
    // 	switch (e.expr) {
    // 		case EConst(CIdent(s)):
    // 			return s;
    // 		case _:
    // 			ExprTools.iter(e, findStrings);
    // 	}
    // 	return "nonono";
    // }
}
