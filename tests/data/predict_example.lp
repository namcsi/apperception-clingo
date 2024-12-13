
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
hidden(s(pred(on,1), obj(a)), 1).
hidden(s(pred(on,1), obj(b)), 1).
senses(s(pred(off,1), obj(a)), 2).
senses(s(pred(on,1), obj(b)), 2).
senses(s(pred(on,1), obj(a)), 3).
senses(s(pred(off,1), obj(b)), 3).
senses(s(pred(on,1), obj(a)), 4).
senses(s(pred(on,1), obj(b)), 4).
hidden(s(pred(off,1), obj(a)), 5).
senses(s(pred(on,1), obj(b)), 5).
senses(s(pred(on,1), obj(a)), 6).
senses(s(pred(off,1), obj(b)), 6).
senses(s(pred(on,1), obj(a)), 7).
senses(s(pred(on,1), obj(b)), 7).
senses(s(pred(off,1), obj(a)), 8).
senses(s(pred(on,1), obj(b)), 8).
senses(s(pred(on,1), obj(a)), 9).
hidden(s(pred(off,1), obj(b)), 9).
hidden(s(pred(on,1), obj(a)), 10).
hidden(s(pred(on,1), obj(b)), 10).

input(type(sensor)).
input(obj(a;b)).
input(isa(sensor,obj(a;b))).
input(pred(on,1)).
input(pred(off,1)).
input(isa(sensor,pred((on;off),1))).
time(1..10).

% Input exclusions
% Every obj is either on or off
% on(X) ⊕ off(X)
% Input exclusions
% Every sensor is either on or off
% S : sensor → on(S) ⊕ off(S)

input(xor(pred(on,1),pred(off,1))).
