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

type(sensor).
obj(a;b).
isa(sensor,obj(a;b)).
pred(on,1).
pred(off,1).
isa(sensor,pred((on;off),1)).
time(1..10).

xor(pred(on,1),pred(off,1)).

%% % A unified interpretation of cost 11.
%% type(sensor).

%% obj(a).
%% obj(b).
%% obj(1).

%% var(1).
%% var(2).
%% var(3).

%% pred(1,2).
%% pred(off,1).
%% pred(on,1).

%% isa(sensor,obj(1)).
%% isa(sensor,obj(a)).
%% isa(sensor,obj(b)).
%% isa(sensor,pred(off,1)).
%% isa(sensor,pred(on,1)).
%% isa((sensor,sensor),pred(1,2)).
%% isa(sensor,var(1)).
%% isa(sensor,var(2)).
%% isa(sensor,var(3)).

%% init(s(pred(on,1),obj(a))).
%% init(s(pred(on,1),obj(b))).
%% init(s(pred(off,1),obj(1))).
%% init(s2(pred(1,2),obj(a),obj(b))).
%% init(s2(pred(1,2),obj(b),obj(1))).
%% init(s2(pred(1,2),obj(1),obj(a))).


%% causal(1).
%% causal(2).

%% rule_head(causal(2),s(pred(on,1),var(3))).
%% rule_body(causal(2),s(pred(off,1),var(3))).

%% rule_head(causal(1),s(pred(off,1),var(2))).
%% rule_body(causal(1),s(pred(off,1),var(1))).
%% rule_body(causal(1),s2(pred(1,2),var(1),var(2))).

%% xor(pred(on,1),pred(off,1)).
%% exist(pred(1,2)).

%% % force sensed and hidden info to hold
%% :- hidden(G,T), not hold(G,T).
%% :- senses(G,T), not hold(G,T).
