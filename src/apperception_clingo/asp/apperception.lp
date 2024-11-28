%% % the inputs to the encoding from the instance  are the following:

%% % sensory sequence
%% is_time(Time).
%% senses(ground_atom(A),Time).

%% % signature
%% input(type(Type)).
%% input(object(Object)).
%% input(isa(Type,Object)).
%% input(unary_concept(PredName)).
%% input(binary_concept(PredName)).
%% input(isa(Type,PredName)).
%% input(isa2(Type1,Type2,PredName)).

%% % constraints
%% input(xor_constraint(Id,Type)).
%% input(xor_member(Id,PredName)).
%% input(exist_constraint(PredName)).

%% % Then, the system iteratively sets the following constants to greater and greater values.

%% type(1..t).

%% object(1..o).
%% concept(1..p).
%% is_variable(1..v).

%% is_rule_causal(1..rc).
%% is_rule_static(1..rs).
%% max_body_size(b).

% convert inputs
type(Type) :- input(type(Type)).
object(Object) :- input(object(Object)).
unary_concept(PredName) :- input(unary_concept(PredName)).
binary_concept(PredName) :- input(binary_concept(PredName)).
isa(Type,Thing) :- input(isa(Type,Thing)).
xor_constraint(Id,Type) :- input(xor_constraint(Id,Type)).
xor_member(Id,PredName) :- input(xor_member(Id,PredName)).
exist_constraint(PredName) :- input(exist_constraint(PredName)).

concept(C) :- binary_concept(C).
concept(C) :- unary_concept(C).

{ unary_concept(C); binary_concept(C) } = 1 :- concept(C).
% choose type signature
{} :- binary_concept(C).
