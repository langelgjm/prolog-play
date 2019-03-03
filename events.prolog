:- include("utils.prolog").


% Initialization

% Read a JSON file from the command line and assert its contents as raw_event.
:- initialization
	current_prolog_flag(argv, [JsonFile | _]),
	read_json(JsonFile, Json),
	assertz(raw_event(Json)).

% Parse raw_event and assert the result as event.
:- initialization
	raw_event(RawEvent),
	mapjson(parse_date, RawEvent, Event),
	assertz(event(Event)).

% keys that are known to exist can be accessed like so:
% event(E), X = E.key1, Y = E.key1.key2.
% keys that may or may not exist may be accessed with get_dict/3 or get_dict_path/3
% event(E), get_dict(key1, E, V).
% event(E), get_dict_path([key1, key2], E, V)
% event(E), get_dict_path("key1.key2", E, V)

success :-
	get_time(Now),
	event(E),
	E.aTimestamp < Now.

failure :-
	get_time(Now),
	event(E),
	E.aTimestamp > Now.

any_state :-
	failure;
	success.

% Exclusive state.
x_state :-
	findall(_, any_state, Result),
	length(Result, Length),
	Length is 1.

% Exclusive success.
x_success :-
	success,
	x_state.