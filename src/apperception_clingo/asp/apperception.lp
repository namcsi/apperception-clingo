%% % the inputs to the encoding from the instance  are the following:

%% % sensory sequence
%% time(Time).
%% senses(ground_atom(A),Time).

%% % signature
%% input(type(Type)).
%% input(object(Object)).
%% input(isa(Type,Object)).
%% input(concept(PredName,Arity)).
%% input(isa(Type,PredName)).
%% input(isa2(Type1,Type2,PredName)).

%% % constraints
%% input(xor_constraint(Id,Type)).
%% input(xor_member(Id,PredName)).
%% input(exist(PredName)).

%% #include "generate.lp".
#include "definitions.lp".
#include "incompos.lp".
%% #include "symmetry-breaking.lp".
#include "unified-interpretation.lp".
#include "./meta-intepreter/sat.lp".
#include "./meta-intepreter/unfounded.lp".
#include "./meta-intepreter/unfounded-tight.lp".
%% #include "optimize.lp"

% add redundant constraints (safety, atom is body cannot be in head,
% definitely incompossible atoms in head/body)

% LocalWords:  incompossible incompassibility
