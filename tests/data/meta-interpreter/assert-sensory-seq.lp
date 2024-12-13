% assert atoms in incomplete sensory sequence of example 1 from making
% sense of sensory input paper.
not not hold(s(pred(off,1),obj(a);pred(on,1),obj(b)),2).
not not hold(s(pred(on,1),obj(a);pred(off,1),obj(b)),3).
not not hold(s(pred(on,1),obj(a);pred(on,1),obj(b)),4).
not not hold(s(pred(on,1),obj(b)),5).
not not hold(s(pred(on,1),obj(a);pred(off,1),obj(b)),6).
not not hold(s(pred(on,1),obj(a);pred(on,1),obj(b)),7).
not not hold(s(pred(off,1),obj(a);pred(on,1),obj(b)),8).
not not hold(s(pred(on,1),obj(a)),9).
