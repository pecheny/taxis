package macros;

import haxe.macro.Type.ClassType;
import macros.BuildMacro;
import haxe.macro.Expr;
import haxe.macro.*;
import Type as HType;

using haxe.macro.ComplexTypeTools;
using haxe.macro.TypeTools;
using haxe.macro.ExprTools;
using Std;

class AVConstructor {
    /**
        Generates code of creating a AVector<TAxis, T>
        @param axisCl - type of axis.
        @param fac - factory method to create values. T in the resulting AVector would be of type returning by the fac.
        @param nm - number of axes in the given enum. Should be provided for calls from @:generic classes when there is no way to calculate it during generation step and can be omitted otherwise.
    **/
    public static macro function factoryCreate<TAxis:Axis<TAxis>, T>(axisCl:ExprOf<Class<TAxis>>, fac:ExprOf<TAxis->T>, ?nm:Expr) {
        var expected = switch Context.getExpectedType() {
            case TAbstract(_.get() => {name: "AVector"}, [_, t]):
                t;
            case _: null;
        }
        // var expectedVal =
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
        if (expected != null)
            Context.unify(valCt0, expected);
        var valCt = valCt0.follow().toComplexType();

        if (valCt == null)
            Context.fatalError("Factory function returns incompatible type " + valCt0.toString(), Context.currentPos());

        var cl = getAxisType(axisCl);
        var ct = cl.toComplexType();
        var ft = macro:$ct -> $valCt;
        var assignExprs:Array<Expr>;
        var countExpr:Expr = null;
        countExpr = switch nm.expr {
            case EConst(CIdent("null")):
                macro $v{BuildMacro.calcNumOfvals(cl)};
            case EConst(CIdent(s)):
                macro $i{s};
            case EConst(CInt(_.parseInt() => s)):
                macro $v{s};
            case _:
                Context.fatalError("Only int const or int variable can be used as nm argument", Context.currentPos());
                throw "Wrong";
        }
        var vectorCt = macro:AVector<$ct, $valCt>;
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

    static function getAxisType(axisCl) {
        var typeName = ExprTools.toString(axisCl);
        var ct = MacroStringTools.toComplex(typeName);
        var cl = Context.resolveType(ct, Context.currentPos());
        return cl;
    }

    public static macro function create<T>(axisCl, extra:Array<ExprOf<T>>) {
        var cl = getAxisType(axisCl);
        var n = BuildMacro.calcNumOfvals(cl);
        if (n != extra.length)
            Context.fatalError('AVector of $cl should contain $n elements, but you pass ${extra.length}', Context.currentPos());

        var ct:ComplexType = cl.toComplexType();
        var valCt = Context.typeof(extra[0]).toComplexType();
        var vectorCt = macro:AVector<$ct, $valCt>;

        var assignExprs = [];
        for (i in 0...n)
            assignExprs.push(macro av[cast $v{i}] = ${extra[i]});
        return macro {
            var av:$vectorCt = cast new haxe.ds.Vector<$valCt>($v{n});
            $b{assignExprs};
            av;
        };
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
