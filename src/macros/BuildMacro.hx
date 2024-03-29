package macros;

import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.Access;
import haxe.ds.ReadOnlyArray;
import haxe.macro.Context;

using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;
using StringTools;

class BuildMacro {
    static var safe_from_int = true;
    public static function buildAxes() {
        #if macro
        var t = Context.getLocalType();
        var ct:ComplexType = t.toComplexType();
        var basisName:String;
        var baseCt:ComplexType = switch ct {
            case TPath(tp):
                basisName = tp.name.replace("_Impl_", "");
                TPath({
                    name: basisName,
                    params: tp.params,
                    pack: tp.pack,
                    sub: tp.sub
                });
            case _: throw "Wrong";
        }

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
            name: "basisTypeName",
            kind: FieldType.FFun({args: [], expr: macro return $v{basisName}}),
            access: [APublic, AStatic, AInline]
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
                ret: macro:Iterator<$baseCt>
            }),
            access: [APublic, AStatic]
        });
        fields.push({
            pos: Context.currentPos(),
            name: "fromInt",
            kind: FieldType.FFun({
                args: [{name:"i", type: macro : Int}],
                expr: if (safe_from_int) macro if (i < 0 || i > $v{vals.length - 1}) throw "" + i + " cant be converterd to " + $v{baseCt.toString()}  else return cast i;
                    else macro return cast i,
                ret: macro:$baseCt
            }),
            access: [APublic, AStatic, AInline]
        });
        // fields.push({
        // 	pos: Context.currentPos(),
        // 	name: "rest",
        // 	kind: FieldType.FFun({
        // 		args: [],
        // 		expr: macro return cast $p{["Axis", "k" + vals.length, "iterator"]}(),
        // 		ret: macro:Iterator<macros.BuildMacroTest.TestAxis>
        // 	}),
        // 	access: [APublic, AInline]
        // });
        // fields.push({
        // 	pos: Context.currentPos(),
        // 	name: "next",
        // 	kind: FieldType.FFun({
        // 		args: [],
        // 		expr: macro return cast this + 1,
        // 		ret: macro:$ct
        // 	}),
        // 	access: [APublic, AInline]
        // });
        // fields.push({
        // 	pos: Context.currentPos(),
        // 	name: "hasNext",
        // 	kind: FieldType.FFun({
        // 		args: [],
        // 		expr: macro return ( cast this  )< $v{vals.length},
        // 		ret: macro:Bool
        // 	}),
        // 	access: [APublic, AInline]
        // });
        // fields.push(macro final aliases = $a{[macro "foo"]});
        return fields;
        #end
    }

    public static function calcNumOfvals(t:haxe.macro.Type) {
        #if macro
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
                Context.fatalError("The argument should be @:enum abstract. Probably your call from @:generic class where you should set number of axes explicitly",
                    Context.currentPos());
        }
        return num;
        #end
    }
}
