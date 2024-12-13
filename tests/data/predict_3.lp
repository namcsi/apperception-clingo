%------------------------------------------------------------------------------
% This file was generated using sequence babbbbbcbbdbbebbf
%------------------------------------------------------------------------------

% The given sequence
senses(s2(c_letter, obj_sensor, obj_letter_b), 1).
senses(s2(c_letter, obj_sensor, obj_letter_a), 2).
senses(s2(c_letter, obj_sensor, obj_letter_b), 3).
senses(s2(c_letter, obj_sensor, obj_letter_b), 4).
senses(s2(c_letter, obj_sensor, obj_letter_b), 5).
senses(s2(c_letter, obj_sensor, obj_letter_b), 6).
senses(s2(c_letter, obj_sensor, obj_letter_b), 7).
senses(s2(c_letter, obj_sensor, obj_letter_c), 8).
senses(s2(c_letter, obj_sensor, obj_letter_b), 9).
senses(s2(c_letter, obj_sensor, obj_letter_b), 10).
senses(s2(c_letter, obj_sensor, obj_letter_d), 11).
senses(s2(c_letter, obj_sensor, obj_letter_b), 12).
senses(s2(c_letter, obj_sensor, obj_letter_b), 13).
senses(s2(c_letter, obj_sensor, obj_letter_e), 14).
senses(s2(c_letter, obj_sensor, obj_letter_b), 15).
senses(s2(c_letter, obj_sensor, obj_letter_b), 16).
hidden(s2(c_letter, obj_sensor, obj_letter_f), 17).

% types

type(t_sensor).
type(t_letter).

% preds
pred(c_letter,2).
isa((t_sensor,t_letter),c_letter).

% Elements
obj(obj_sensor).
isa(t_sensor,obj_sensor).
obj(obj_letter_a;obj_letter_b;obj_letter_c;obj_letter_d;obj_letter_e;obj_letter_f).
isa(t_letter,
	 (obj_letter_a;obj_letter_b;obj_letter_c;obj_letter_d;obj_letter_e;obj_letter_f)).

time(1..17).

% Every sensor has a unique letter attribute

exist(c_letter).
