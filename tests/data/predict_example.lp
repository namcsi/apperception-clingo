
%------------------------------------------------------------------------------
% The sensory given.
%------------------------------------------------------------------------------

%---------------------------------------------
%   Time            Sensor a        Sensor b
%
%   1               ?               ?
%   2               off             on
%   3               on              off
%   4               on              on
%   5               ?               on
%   6               on              off
%   7               on              on
%   8               off             on
%   9               on              ?
%   10              ?               ?
%---------------------------------------------

% The given sequence
hidden(s(concept(on), object(a)), 1).
hidden(s(concept(on), object(b)), 1).
senses(s(concept(off), object(a)), 2).
senses(s(concept(on), object(b)), 2).
senses(s(concept(on), object(a)), 3).
senses(s(concept(off), object(b)), 3).
senses(s(concept(on), object(a)), 4).
senses(s(concept(on), object(b)), 4).
hidden(s(concept(off), object(a)), 5).
senses(s(concept(on), object(b)), 5).
senses(s(concept(on), object(a)), 6).
senses(s(concept(off), object(b)), 6).
senses(s(concept(on), object(a)), 7).
senses(s(concept(on), object(b)), 7).
senses(s(concept(off), object(a)), 8).
senses(s(concept(on), object(b)), 8).
senses(s(concept(on), object(a)), 9).
hidden(s(concept(off), object(b)), 9).
hidden(s(concept(on), object(a)), 10).
hidden(s(concept(on), object(b)), 10).

input(type(sensor)).
input(object(a;b)).
input(isa(sensor,object(a;b))).
input(concept(on,1)).
input(concept(off,1)).
input(isa(sensor,concept(on;off))).
time(1..10).

% Input exclusions
% Every object is either on or off
% on(X) ⊕ off(X)
% Input exclusions
% Every sensor is either on or off
% S : sensor → on(S) ⊕ off(S)

input(xor(concept(on),concept(off))).
