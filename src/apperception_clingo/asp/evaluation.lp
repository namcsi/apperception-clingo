incorrect(G,T) :- hidden(G,T), not holds(G,T).
correct :- not incorrect.
num_incorrect(N) :- N = #count{ G,T: incorrect(G,T) }.
