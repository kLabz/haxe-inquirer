package inquirer;

import haxe.DynamicAccess;
import haxe.extern.EitherType;
import js.Promise;

typedef Question = Dynamic; // TODO
typedef Answer = EitherType<Bool, String>;
typedef Answers = DynamicAccess<Answer>;

@:jsRequire('inquirer')
extern class Inquirer {
	public static function prompt(questions:Array<Question>):Promise<Answers>;
	public static function registerPrompt(name:String, prompt:Dynamic):Void; // TODO
	public static function createPromptModule<T>():Array<Question>->Promise<T>;
}
