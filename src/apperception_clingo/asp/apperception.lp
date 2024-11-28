%% % the inputs to the encoding from the instance  are the following:

%% % sensory sequence
%% time(Time).
%% senses(ground_atom(A),Time).

%% % signature
%% input(type(Type)).
%% input(object(Object)).
%% input(isa(Type,Object)).
%% input(concept(PredName)).
%% input(concept2(PredName)).
%% input(isa(Type,PredName)).
%% input(isa2(Type1,Type2,PredName)).

%% % constraints
%% input(xor_constraint(Id,Type)).
%% input(xor_member(Id,PredName)).
%% input(exist_constraint(PredName)).

%% % Then, the system iteratively sets the following constants to greater and greater values.

%% type_dom(1..t).
%% object_dom(1..o).
%% concept_dom(1..p).
%% variable_dom(1..v).

%% rule_causal_dom(1..rc).
%% rule_static_dom(1..rs).
%% max_body_size(b).

% convert inputs
type(Type) :- input(type(Type)).
object(Object) :- input(object(Object)).
concept(PredName) :- input(concept(PredName)).
concept2(PredName) :- input(concept2(PredName)).
isa(Type,Thing) :- input(isa(Type,Thing)).
isa2(Type1,Type2,Concept) :- input(isa2(Type1,Type2,Concept)).
xor_constraint(Id,Type) :- input(xor_constraint(Id,Type)).
xor_member(Id,PredName) :- input(xor_member(Id,PredName)).
exist_constraint(PredName) :- input(exist_constraint(PredName)).

hold(A,T):- senses(A,T), time(T).

% choose to instatiate from domains
{ type(T) } :- type_dom(T).
{ object(O) } :- object_dom(O).
{ concept(C); concept2(C) } = 1 :- concept_dom(C).
{ variable(V) } :- variable_dom(V).
{ rule_causal(R) } :- rule_causal_dom(R).
{ rule_static(R) } :- rule_static_dom(R).

% choose type signature for concepts
{ isa(T,C): type(T) } = 1 :- concept(C).
{ isa2(T1,T2,C): type(T1), type(T2) } = 1 :- concept2(C).
