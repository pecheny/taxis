import haxe.macro.Type.ClassType;
import macros.BuildMacro;
import haxe.macro.Expr;
import haxe.macro.*;
import Type as HType;

using haxe.macro.ComplexTypeTools;
using haxe.macro.TypeTools;
using haxe.macro.ExprTools;

class AAA {

	public static macro function factoryCreate<TAxis, T>(axisCl:ExprOf<Class<TAxis>>, fac:ExprOf<TAxis->T>) {
		// function trClt(t:ClassType) {
		// 	trace(t.kind);
		// 	trace(t.params);
		// }
		// function tr(t:Type) {
		// 	switch t {
		// 		case TInst(_.get() => t, params):
		// 			trClt(t);
		// 			trace(params);
		// 		case _:
		// 	}
		// }
		// trClt(Context.getLocalClass().get());
		// tr(Context.getLocalType().follow());
		var facT = Context.typeof(fac);
		var facCt = facT.toComplexType();
		var valCt = // if (facCt != null) switch facCt {
			// 	case TFunction([axis], ret): ret;
			// 	case _: Context.fatalError("To construct an AVector<TAxis, TVal> with factoryCreate() ypu should provide factory function TAxis -> TVal",
			// 			Context.currentPos());
			// } else
			if (facT != null) switch facT {
				case TFun(args, ret): ret.toComplexType();
				case _:
					Context.fatalError("Can't infere factory function type: \n" + facT + "\n " + fac.toString(), Context.currentPos());
			} else {
				Context.fatalError("Can't infere factory function type: \n" + fac + "\n " + fac.toString(), Context.currentPos());
			}
		var cl = getAxisType(axisCl);
		var ct = cl.toComplexType();
		var n = BuildMacro.calcNumOfvals(cl);
		var vectorCt = macro:AVector<$ct, $valCt>;
		var assignExprs = [
			for (i in 0...n)
				macro av[cast $v{i}] = _fac(cast $v{i})
		];
		return macro {
			var _fac = $fac;
			var av:$vectorCt = cast new haxe.ds.Vector<$valCt>($v{n});
			$b{assignExprs};
			// for (i in $axisCl)
			// 	av[cast i] = _fac(cast i);
			av;
		}
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
