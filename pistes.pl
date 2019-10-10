findkeys(_,[],[],[],[]).

findkeys(N,[H|T],[], Keysneeded, Keysgiven):-
    (N == 0 -> Keysneeded = [],
               Keysgiven = [H|T]
    ;N > 0 -> N1 is N - 1 ,
              findkeys(N1,T,[H],Keysneeded,Keysgiven)).

findkeys(N,[H|T],[H2|T2],Keysneeded,Keysgiven):-
    (N == 0 -> Keysneeded = [H2|T2],
               Keysgiven = [H|T]
    ;N > 0 -> N1 is N - 1,
              findkeys(N1,T,[H,H2|T2],Keysneeded,Keysgiven)).          

findkeys(_,[],[H2|T2],Keysneeded,Keysgiven):-
    Keysneeded = [H2|T2],
    Keysgiven = [].

read_input(File, N, Pistes) :-
    open(File, read, Stream),
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atom_number(Atom, N1),
    N is N1 + 1,
    read_lines(Stream, N, Pistes).

read_lines(Stream, N, Pistes) :-
    ( N == 0 -> Pistes = []
    ; N > 0  -> read_line(Stream, Pista),
                Nm1 is N-1,
                read_lines(Stream, Nm1, RestPistes),
                Pistes = [Pista | RestPistes]).

read_line(Stream, pista(Numkeysneeded,Numkeysgiven, Stars, Keysneeded, Keysgiven)) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat([H1,H2,H3|Atoms], ' ', Atom),
    maplist(atom_number, [H1,H2,H3], [Numkeysneeded,Numkeysgiven, Stars]),
    maplist(atom_number, Atoms, All),
    findkeys(Numkeysneeded,All,[],Keysneeded,Keysgiven).

containsall(List1,[],List1).
containsall([],[],[]).
containsall(List1,[H|T],Result):-
    select(H,List1,L),
    containsall(L,T,Result),
    !.
    
play([pista(_Numkeysneeded,_Numkeysgiven, Stars, _Keysneeded, Keysgiven)|T], 0, [],Result):-
    Sum = Stars,
    play(T,Sum,Keysgiven,Result).

play([],Sum,_,Result):-
    Result = Sum,
    !.

play(Pistes,Sum,[],Result):-
    select(pista(Numkeysneeded,_Numkeysgiven, Stars, _Keysneeded, Keysgiven),Pistes,RestPistes),
    Numkeysneeded == 0,
    Sum2 is Sum + Stars,
    play(RestPistes,Sum2,Keysgiven,Result).

play(Pistes,Sum,Mykeys,Result):-
    select(pista(_Numkeysneeded,_Numkeysgiven, _Stars, Keysneeded, _Keysgiven),Pistes,_RestPistes),
    not(containsall(Mykeys,Keysneeded,_Restkeys1)),
    Result = Sum.

play(Pistes,Sum,Mykeys,Result):-
    select(pista(_Numkeysneeded,_Numkeysgiven, Stars, Keysneeded, Keysgiven),Pistes,RestPistes),
    containsall(Mykeys,Keysneeded,Restkeys1),
    Sum2 is Sum + Stars,
    append(Restkeys1,Keysgiven,Restkeys),
    play(RestPistes,Sum2,Restkeys,Result).

pistes(F,Answer):-
    read_input(F,_N,Pistes),
    findall(Sum,play(Pistes, 0,[],Sum),Stars),
    sort(Stars,Sorted),
    last(Sorted,Answer).
