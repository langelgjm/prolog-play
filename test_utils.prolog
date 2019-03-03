:- use_module(library(plunit)).

:- include("utils.prolog").


:- begin_tests(utils).

test(parse_date) :-
	X = 946684800.0,
	parse_date("2000-01-01", X),
	parse_date("2000-01-01 00:00:00", X),
	parse_date("2000-01-01T00:00:00.0Z", X),
	parse_date("2000-01-01 00:00:00", X),
	parse_date("2000-01-01 00:00:00", X),
	Y = 978307199.999,
	parse_date("2000-12-31 23:59:59.999", Y),
	parse_date("2000-12-31T23:59:59.999Z", Y),
	parse_date(a, a),
	parse_date(1, 1),
	parse_date("A", "A"),
	parse_date([], []),
	parse_date(_{a: 1}, _{a: 1}).
	
test(get_dict_path) :-
	Input = _{foo: "bar", baz: _{foo: "bar"}},
	get_dict_path([baz, foo], Input, "bar"),
	get_dict_path("baz.foo", Input, "bar").
	
test(mapjson) :- 
	Expected = 946684800.0,
	String = "2000-01-01",
	mapjson(parse_date, String, Expected).

test(mapjson) :- 
	X = 946684800.0,
	List = ["foo", "2000-01-01"],
	Expected = ["foo", X],
	mapjson(parse_date, List, Expected).

test(mapjson) :- 
	X = 946684800.0,
	Dict = _{foo: "bar", baz: "2000-01-01"},
	Expected = _{foo: "bar", baz: X},
	mapjson(parse_date, Dict, Expected).

test(mapjson) :- 
	X = 946684800.0,
	Dict = _{foo: ["2000-01-01"], bar: _{baz: "2000-01-01"}},
	Expected = _{foo: [X], bar: _{baz: X}},
	mapjson(parse_date, Dict, Expected).

:- end_tests(utils).