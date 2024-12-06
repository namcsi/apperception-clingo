#program team1(k).
team1(k).
{pair(k,P)}:- team1(k), team2(P).

#program team2(k).
team2(k).
{pair(P,k)}:- team2(k), team1(P).

%% #program base.
%% switch(Y,X):- pair(X,Y).
