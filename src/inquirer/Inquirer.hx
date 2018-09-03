package inquirer;

import haxe.DynamicAccess;
import haxe.extern.EitherType;
import js.Promise;

typedef Question = Dynamic; // TODO
typedef Answer = EitherType<Bool, String>;

@:jsRequire('inquirer')
extern class Inquirer {
	public static function prompt<TAnswers>(questions:Array<Question>):Promise<TAnswers>;
	public static function registerPrompt(name:String, prompt:Dynamic):Void; // TODO
	public static function createPromptModule<T>():Array<Question>->Promise<T>;
}
