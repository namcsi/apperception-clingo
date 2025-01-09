incorrect(G,T) :- hidden(G,T), not hold(G,T).
incorrect :- incorrect(G,T).
correct :- not incorrect.
num_incorrect(N) :- N = #count{ G,T: incorrect(G,T) }.
