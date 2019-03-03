:- use_module(library(apply)).
:- use_module(library(dicts)).
:- use_module(library(http/json)).
:- use_module(library(lists)).
:- use_module(library(pairs)).


% True if Json can be unified to Filename.
read_json(Filename, Json) :-
	open(Filename, read, In),
	json_read_dict(In, Json),
	close(In).


% True if Date is an ISO 8601 string that can be unified to Timestamp.
parse_date(Date, Timestamp) :-
	string(Date),
	parse_time(Date, Timestamp),
	!.

% Unifies NotDate with Result. This has the effect of ignoring unparseable values.
parse_date(NotDate, Result) :-
	Result = NotDate.


% True if Value can be unified with the value present in Dict at the path given by Keys.
% Keys is a list of dict-keys. This is used for convenient access to nested dict keys that may or may not exist.
get_dict_path(Keys, Dict, Value) :-
	is_list(Keys),
	!,
	foldl(get_dict, Keys, Dict, Value).

% True if Value can be unified with the value present in Dict at the path given by KeyString.
% KeyString is a string of dict-keys separated with dots, e.g. "key1.key2.key3".
get_dict_path(KeyString, Dict, Value) :-
	string(KeyString),
	!,
	split_string(KeyString, ".", "", SplitKeyString),
	maplist(atom_string, Keys, SplitKeyString),
	get_dict_path(Keys, Dict, Value).


% True if mapping Goal to Json can be unified with NewJson.
% mapjson/3 is patterned after maplist/3.
mapjson(Goal, Json, NewJson) :-
	is_list(Json),
	!,
	maplist(mapjson(Goal), Json, NewJson).

mapjson(Goal, Json, NewJson) :-
	is_dict(Json),
	!,
	dict_pairs(Json, _, Pairs),
	pairs_keys_values(Pairs, Keys, Values),
	maplist(mapjson(Goal), Values, NewValues),
	pairs_keys_values(NewPairs, Keys, NewValues),
	dict_create(NewJson, _, NewPairs).

mapjson(Goal, Json, NewJson) :- 
	call(Goal, Json, NewJson).