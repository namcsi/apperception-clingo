%------------------------------------------------------------------------------
% This file was generated using sequence babbbbbcbbdbbebbf
%------------------------------------------------------------------------------

% The given sequence
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_b)), 1).
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_a)), 2).
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_b)), 3).
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_b)), 4).
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_b)), 5).
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_b)), 6).
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_b)), 7).
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_c)), 8).
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_b)), 9).
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_b)), 10).
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_d)), 11).
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_b)), 12).
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_b)), 13).
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_e)), 14).
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_b)), 15).
senses(s2(pred(sense_l,2), obj(sensor_1), obj(letter_b)), 16).
hidden(s2(pred(sense_l,2), obj(sensor_1), obj(letter_f)), 17).

% types

type(sensor).
type(letter).

% preds
pred(sense_l,2).
isa((sensor,letter),pred(sense_l,2)).

% Elementsf
obj(sensor_1).
isa(sensor,sensor_1).
obj(letter_a;letter_b;letter_c;letter_d;letter_e;letter_f).
isa(letter,
	 obj(letter_a;letter_b;letter_c;letter_d;letter_e;letter_f)).

time(1..17).

% Every sensor senses a unique letter at each time point.

exist(pred(sense_l,2)).

% I have no idea how the system could solve this one...
