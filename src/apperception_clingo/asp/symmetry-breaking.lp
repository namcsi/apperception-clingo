% instatiation from domains must happen in ascending order, without any gaps
:- type_dom(T1), type(T2), not type(T1), not input(type(T2)).
:- object_dom(O1), object(O2), not object(O1), not input(object(O2))
