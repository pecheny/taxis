package macros;

import haxe.macro.TypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.Tools;
using haxe.macro.TypeTools;

class BuildClient {
	public static function build() {
		var type:Type = Context.getLocalType();
		// trace(type);
		var targetFields:Array<Field> = [];
		var localFields = Context.getBuildFields();
		var t2 = switch type {
			case TInst(_.get() => clt, params):
				var cFields = new Map<String, ClassField>();
				for (c in clt.fields.get()) {
                    cFields[c.name] = c;
                }

				for (f in localFields) {
					var field:Field = {
						name: f.name,
						access: f.access,
                        pos: f.pos,
                        meta: :f.meta,
                        kind: 
					}
					targetFields.push(field);
				}

				var cfields = switch c.type.applyTypeParameters(e.params, params).reduce() {
					case TFun([{name: name, t: _.reduce() => TAnonymous(anon)}], ret) if (name.toLowerCase() == c.name.toLowerCase()):
						inlined = true;
						[for (f in anon.get().fields) convertField(f)];
					case TFun(args, ret):
						[
							for (a in args)
								makeInfo({name: a.name, type: a.t, pos: c.pos}, a.opt, [] // TODO: meta is lost?
								)
						];
					default:
						[];
				}

				for (f in) {
					var ftype:Type = f.type.applyTypeParameters(clt.params, params);
					// var name:String;
					// var ?doc:String;
					// var ?access:Array<Access>;
					// var kind:FieldType;
					// var pos:Position;
					// var ?meta:Metadata;
				}

				TypeTools.applyTypeParameters(type, clt.params, params);
			case _: throw "--";
		}

		trace(t2);
		var tparam:Type;
		var clt:ClassType = switch (t2) {
			case TInst(_.get() => clt, params):
				tparam = params[0];
				trace(clt);
				clt;
			case t:
				Context.error("Class expected", Context.currentPos());
		}
		return getType(clt, tparam, fields);
		// return null;
	}

	static function getType(clt:ClassType, tparam, fields) {
		var name = clt.name + "_" + extractName(tparam);
		var pack = clt.pack;
		var fullName = pack.join(".") + "." + name;
		trace(fullName);
		try {
			var t = Context.getType(fullName);
			trace("defined");
			return t;
		} catch (e) {
			trace("-- " + tparam + " --");
			var typdef:TypeDefinition = {
				pack: pack,
				name: name,
				pos: clt.pos,
				kind: TDClass(),
				fields: fields
			};
			Context.defineType(typdef);
			trace("type defined");
		}

		var t = Context.getType(fullName);
		return t;
	}

	static function extractName(type:Type) {
		return switch type {
			case TInst(_.get() => t, params):
				flattenName(t) + params.map(extractName).join("_");
			case TEnum(_.get() => t, params):
				flattenName(t) + params.map(extractName).join("_");
			case TType(_.get() => t, params):
				flattenName(t) + params.map(extractName).join("_");
			case TAbstract(_.get() => t, params):
				flattenName(t) + params.map(extractName).join("_");
			//			case TMono(_.get() => t): {
			//					trace(type  + " " + t);
			//					"___";
			//				}
			case _:
				throw "Wrong " + type;
		}
	}

	static function flattenName(t:BaseType) {
		return t.pack.join("_") + "_" + t.name;
	}
}
