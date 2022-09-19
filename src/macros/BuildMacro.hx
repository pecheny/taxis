package macros;

import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.Access;
import haxe.ds.ReadOnlyArray;
import haxe.macro.Context;

class BuildMacro {
	public static function buildAxes() {
		var fields = Context.getBuildFields();
		var vals = [];
		for (f in fields) {
			// trace(f);
			switch f {
				case {name: n, access: acc, kind: FVar(t, e)} if (!acc.contains(AStatic)):
					vals.push(macro $v{n});
				case _:
			}
		}
		fields.push({
			pos: Context.currentPos(),
			name: "aliases",
			kind: FieldType.FVar(macro:haxe.ds.ReadOnlyArray<String>, macro $a{vals}),
			access: [APublic, AStatic, AFinal]
		});
		fields.push({
			pos: Context.currentPos(),
			name: "toString",
			kind: FieldType.FFun({args: [], expr: macro return aliases[this]}),
			access: [APublic, AInline]
		});
		// ComplexType
		fields.push({
			pos: Context.currentPos(),
			name: "iterator",
			kind: FieldType.FFun({
				args: [],
				expr: macro return cast $p{["Axis", "k" + vals.length, "iterator"]}(),
				ret: macro:Iterator<macros.BuildMacroTest.TestAxis>
			}),
			access: [APublic, AStatic]
		});

		// fields.push(macro final aliases = $a{[macro "foo"]});
		return fields;
	}

	public static function calcNumOfvals(t:haxe.macro.Type) {
		var num = 0;
		switch t {
			case TAbstract(_.get() => ab, params) if (ab.meta.has(":enum")):
				for (field in ab.impl.get().statics.get()) {
					if (field.meta.has(":enum") && field.meta.has(":impl")) {
					  var fieldName = field.name;
					  num++;
					//   valueExprs.push(macro $typePath.$fieldName);
					}
				  }

			case _:
		}
		return num;
	}
}
