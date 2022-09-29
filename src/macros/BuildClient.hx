package macros;

import haxe.macro.TypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.Tools;
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;
// TODO where look for final type parameter value? check follow()
class BuildClient {
	// public static function converFArg(fa:FunctionArg):FunctionArg {
	// 	return null;
	// }
	// public static function processCt(ct:ComplexType):ComplexType {
	// 	return null;
	// }
	public static function build2() {
		var t = Context.getLocalType();
		trace(t);
		var ct = t.toComplexType();
		var fields = Context.getBuildFields();
		trace("foo " + fields);
		var type:Type = Context.getLocalType();
		var clt:ClassType = switch type {
			case TInst(_.get() => clt, params):
				switch params[0] {
					case TInst(t, params):
						trace(params);

					case _:
				};
				var cFields = new Map<String, ClassField>();
				for (c in clt.fields.get()) {
					cFields[c.name] = c;
				}
				// tparam = params[0];

				// for (f in localFields) {
				// 	// var f:Field = f;
				// 	var cf = cFields[f.name];
				// 	var field:Field = {
				// 		name: f.name,
				// 		access: f.access,
				// 		pos: f.pos,
				// 		meta: f.meta,
				// 		kind: switch f.kind {
				// 			case FVar(ct, expr): FVar(cf.type.applyTypeParameters(clt.params, params).toComplexType(), expr);
				// 			case _: f.kind;
				// 		}
				// 	}
				// 	targetFields.push(field);
				// }
				clt;
			case _:
				throw "--";
		}
		return fields;
	}
	// public static function build() {
	// 	var type:Type = Context.getLocalType();
	// 	// trace(type);
	// 	var targetFields:Array<Field> = [];
	// 	var localFields = Context.getBuildFields();
	// 	var tparam:Type;
	// 	var clt:ClassType = switch type {
	// 		case TInst(_.get() => clt, params):
	// 			var cFields = new Map<String, ClassField>();
	// 			for (c in clt.fields.get()) {
	// 				cFields[c.name] = c;
	// 			}
	// 			tparam = params[0];
	// 			for (f in localFields) {
	// 				// var f:Field = f;
	// 				var cf = cFields[f.name];
	// 				var field:Field = {
	// 					name: f.name,
	// 					access: f.access,
	// 					pos: f.pos,
	// 					meta: f.meta,
	// 					kind: switch f.kind {
	// 						case FVar(ct, expr): FVar(cf.type.applyTypeParameters(clt.params, params).toComplexType(), expr);
	// 						case _: f.kind;
	// 					}
	// 				}
	// 				targetFields.push(field);
	// 			}
	// 			clt;
	// 		case _:
	// 			throw "--";
	// 	}
	// 	// trace(t2);
	// 	// var tparam:Type;
	// 	// var clt:ClassType = switch (t2) {
	// 	// 	case TInst(_.get() => clt, params):
	// 	// 		tparam = params[0];
	// 	// 		trace(clt);
	// 	// 		clt;
	// 	// 	case t:
	// 	// 		Context.error("Class expected", Context.currentPos());
	// 	// }
	// 	return getType(clt, tparam, targetFields);
	// 	// return null;
	// }
	// static function getType(clt:ClassType, tparam, fields) {
	// 	var name = clt.name + "_" + extractName(tparam);
	// 	var pack = clt.pack;
	// 	var fullName = pack.join(".") + "." + name;
	// 	trace(fullName);
	// 	try {
	// 		var t = Context.getType(fullName);
	// 		trace("defined");
	// 		return t;
	// 	} catch (e) {
	// 		trace("-- " + tparam + " --");
	// 		var typdef:TypeDefinition = {
	// 			pack: pack,
	// 			name: name,
	// 			pos: clt.pos,
	// 			// kind: TDClass({pack: ["genericbuild"], name: "SomeBase", params: [TPType(tparam.toComplexType())]}),
	// 			kind: TDClass(),
	// 			fields: fields
	// 		};
	// 		Context.defineType(typdef);
	// 		trace("type defined");
	// 	}
	// 	var t = Context.getType(fullName);
	// 	return t;
	// }
	// static function extractName(type:Type) {
	// 	return switch type {
	// 		case TInst(_.get() => t, params):
	// 			flattenName(t) + params.map(extractName).join("_");
	// 		case TEnum(_.get() => t, params):
	// 			flattenName(t) + params.map(extractName).join("_");
	// 		case TType(_.get() => t, params):
	// 			flattenName(t) + params.map(extractName).join("_");
	// 		case TAbstract(_.get() => t, params):
	// 			flattenName(t) + params.map(extractName).join("_");
	// 		//			case TMono(_.get() => t): {
	// 		//					trace(type  + " " + t);
	// 		//					"___";
	// 		//				}
	// 		case _:
	// 			throw "Wrong " + type;
	// 	}
	// }
	// static function flattenName(t:BaseType) {
	// 	return t.pack.join("_") + "_" + t.name;
	// }
}
