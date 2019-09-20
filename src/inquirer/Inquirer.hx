package inquirer;

import haxe.DynamicAccess;
import haxe.extern.EitherType;
import js.Object;
import js.lib.Promise;

@:jsRequire('inquirer')
extern class Inquirer {
	public static inline function prompt<TAnswers>(
		questions:Array<Question<TAnswers>>
	):Promise<TAnswers> {
		return _prompt(questions.map(
			function(q:Question<TAnswers>):QuestionConfig<TAnswers> return q
		));
	}

	@:native('prompt')
	static function _prompt<TAnswers>(
		questions:Array<QuestionConfig<TAnswers>>
	):Promise<TAnswers>;

	// TODO: adapt typing to haxe
	// @:native('registerPrompt')
	static function registerPrompt(name:String, prompt:Dynamic):Void;

	// TODO: adapt typing to haxe
	// @:native('createPromptModule')
	static function createPromptModule<TAnswers, T>():Array<Question<TAnswers>>->Promise<T>;
}

typedef Options = {
	@:optional var isFinal:Bool;
};

/**
	Depends on the prompt:
	- confirm: Bool
	- input: User input (filtered if `filter` is defined), String
	- rawlist, list: Selected choice value (or name if no value specified), String
*/
typedef AnswerValue = EitherType<Bool, String>;

@:enum @:coreType abstract QuestionType from String to String {
	var Input = "input";
	var Confirm = "confirm";
	var List = "list";
	var RawList = "rawlist";
	var Expand = "expand";
	var Checkbox = "checkbox";
	var Password = "password";
	var Editor = "editor";

	// Or any other value if you register your own prompt types
}

enum EQuestion<TAnswers> {
	List(config:ListConfig<TAnswers>);
	RawList(config:RawListConfig<TAnswers>);
	Expand(config:ExpandConfig<TAnswers>);
	Checkbox(config:CheckboxConfig<TAnswers>);
	Confirm(config:ConfirmConfig<TAnswers>);
	Input(config:InputConfig<TAnswers>);
	Password(config:PasswordConfig<TAnswers>);
	Editor(config:EditorConfig<TAnswers>);

	Custom(config:QuestionConfig<TAnswers>);
}

abstract Question<TAnswers>(EQuestion<TAnswers>) from EQuestion<TAnswers> {
	@:to
	public function toQuestionConfig():QuestionConfig<TAnswers> {
		return switch (this) {
			case List(config):
				Object.assign({}, config, {type: QuestionType.List});

			case RawList(config):
				Object.assign({}, config, {type: QuestionType.RawList});

			case Expand(config):
				Object.assign({}, config, {type: QuestionType.Expand});

			case Checkbox(config):
				Object.assign({}, config, {type: QuestionType.Checkbox});

			case Confirm(config):
				Object.assign({}, config, {type: QuestionType.Confirm});

			case Input(config):
				Object.assign({}, config, {type: QuestionType.Input});

			case Password(config):
				Object.assign({}, config, {type: QuestionType.Password});

			case Editor(config):
				Object.assign({}, config, {type: QuestionType.Editor});

			case Custom(config): config;
		};
	}
}

@:jsRequire('inquirer', 'Separator')
extern class Separator {
	public var type(default, never):String; // = "separator"

	public function new(?value:String);
}

typedef Choice = EitherType<
	String,
	EitherType<
		{name:String, ?value:String, ?short:String},
		Separator
	>
>;

typedef ListConfig<TAnswers> = {
	var name:String;
	// TODO: default as optional

	var message:EitherType<
		String,
		TAnswers->String
	>;

	var choices:EitherType<
		Array<Choice>,
		EitherType<
			TAnswers->Array<Choice>,
			TAnswers->Promise<Array<Choice>>
		>
	>;

	@:optional var filter:EitherType<
		String->AnswerValue,
		String->Promise<AnswerValue>
	>;
}

typedef RawListConfig<TAnswers> = {
	var name:String;
	// TODO: default as optional

	var message:EitherType<
		String,
		TAnswers->String
	>;

	var choices:EitherType<
		Array<Choice>,
		EitherType<
			TAnswers->Array<Choice>,
			TAnswers->Promise<Array<Choice>>
		>
	>;

	@:optional var filter:EitherType<
		String->AnswerValue,
		String->Promise<AnswerValue>
	>;
}

typedef ExpandConfig<TAnswers> = {
// typedef ExpandConfig<TAnswers:Dynamic<AnswerValue>> = {
	var name:String;
	// TODO: default as optional

	var message:EitherType<
		String,
		TAnswers->String
	>;

	var choices:EitherType<
		Array<Choice>,
		EitherType<
			TAnswers->Array<Choice>,
			TAnswers->Promise<Array<Choice>>
		>
	>;
}

typedef CheckboxConfig<TAnswers> = {
	var name:String;
	// TODO: default as optional

	var message:EitherType<
		String,
		TAnswers->String
	>;

	var choices:EitherType<
		Array<Choice>,
		EitherType<
			TAnswers->Array<Choice>,
			TAnswers->Promise<Array<Choice>>
		>
	>;

	@:optional var filter:EitherType<
		String->AnswerValue,
		String->Promise<AnswerValue>
	>;

	@:optional var validate:String->EitherType<
		String,
		EitherType<
			Bool,
			EitherType<
				Promise<String>,
				Promise<Bool>
			>
		>
	>;
}

typedef ConfirmConfig<TAnswers> = {
	var name:String;
	// TODO: default as optional Bool

	var message:EitherType<
		String,
		TAnswers->String
	>;
}

typedef InputConfig<TAnswers> = {
// typedef InputConfig<TAnswers:Dynamic<AnswerValue>> = {
	var name:String;
	// TODO: default as optional

	var message:EitherType<
		String,
		TAnswers->String
	>;

	@:optional var validate:String->EitherType<
		String,
		EitherType<
			Bool,
			EitherType<
				Promise<String>,
				Promise<Bool>
			>
		>
	>;

	@:optional var filter:EitherType<
		String->AnswerValue,
		String->Promise<AnswerValue>
	>;

	@:optional var transformer:String->TAnswers->Options->String;
}

typedef PasswordConfig<TAnswers> = {
// typedef PasswordConfig<TAnswers:Dynamic<AnswerValue>> = {
	var name:String;
	// TODO: default as optional

	var message:EitherType<
		String,
		TAnswers->String
	>;

	@:optional var validate:String->EitherType<
		String,
		EitherType<
			Bool,
			EitherType<
				Promise<String>,
				Promise<Bool>
			>
		>
	>;

	@:optional var filter:EitherType<
		String->AnswerValue,
		String->Promise<AnswerValue>
	>;
}

typedef EditorConfig<TAnswers> = {
	var name:String;
	// TODO: default as optional

	var message:EitherType<
		String,
		TAnswers->String
	>;

	@:optional var validate:String->EitherType<
		String,
		EitherType<
			Bool,
			EitherType<
				Promise<String>,
				Promise<Bool>
			>
		>
	>;

	@:optional var filter:EitherType<
		String->AnswerValue,
		String->Promise<AnswerValue>
	>;
}

typedef QuestionConfig<TAnswers> = {
	var type:QuestionType;
	var name:String;

	// TODO
	// @:optional var default:EitherType<AnswerValue, EitherType<TAnswers->AnswerValue, TAnswers->Promise<AnswerValue>>>;

	var message:EitherType<
		String,
		TAnswers->String
	>;

	@:optional var choices:EitherType<
		Array<Choice>,
		EitherType<
			TAnswers->Array<Choice>,
			TAnswers->Promise<Array<Choice>>
		>
	>;

	@:optional var validate:String->EitherType<
		String,
		EitherType<
			Bool,
			EitherType<
				Promise<String>,
				Promise<Bool>
			>
		>
	>;

	@:optional var filter:EitherType<
		String->AnswerValue,
		String->Promise<AnswerValue>
	>;

	@:optional var transformer:String->TAnswers->Options->String;

	@:optional var when:EitherType<
		TAnswers->Bool,
		EitherType<
			TAnswers->Promise<Bool>,
			Bool
		>
	>;

	// TODO: these are not included in the documentation for sub types..
	@:optional var pageSize:Int;
	@:optional var prefix:String;
	@:optional var suffix:String;
};
