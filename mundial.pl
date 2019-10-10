read_input(File, N, Teams) :-
    open(File, read, Stream),
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atom_number(Atom, N),
    read_lines(Stream, N, Teams).

read_lines(Stream, N, Teams) :-
    ( N == 0 -> Teams = []
    ; N > 0  -> read_line(Stream, Team),
                Nm1 is N-1,
                read_lines(Stream, Nm1, RestTeams),
                Teams = [Team | RestTeams]).

read_line(Stream, team(Name, P, A, B)) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat([Name | Atoms], ' ', Atom),
    maplist(atom_number, Atoms, [P, A, B]).

calculator(Teams, [], Matches, [], N, N1):-
    select(team(L,GX,S1,S2),Teams,L2),
    GX = 1,
    select(team(W,GY,IFY,AY),L2,L3),
    GY > 1,
    IFY >= S2,
    AY >= S1,
    S2 > S1,
    S1 >= 0,
    GY1 is GY - 1,
    IFY1 is IFY - S2,
    AY1 is AY - S1,
    N2 is N - 1,
    append(L3,[team(W,GY1,IFY1,AY1)],L4),    
    calculator(L4,[match(W,L,S2,S1)],Matches, [team(W,GY1,IFY1,AY1)], N2, N1).

calculator(Teams, L1, Matches, [], N, N1):-
    select(team(L,GX,S1,S2),Teams,L2),
    GX = 1,
    select(team(W,GY,IFY,AY),L2,L3),
    GY > 1,
    IFY >= S2,
    AY >= S1,
    S2 > S1,
    S1 >= 0,
    GY1 is GY - 1,
    IFY1 is IFY - S2,
    AY1 is AY - S1,
    N2 is N - 1,
    append(L3,[team(W,GY1,IFY1,AY1)],L4),
    append(L1,[match(W,L,S2,S1)],L5),    
    calculator(L4,L5,Matches, [team(W,GY1,IFY1,AY1)], N2, N1).

calculator(Teams, L1,Matches, Played, N, N1):-
    ( N >= N1 -> 
    subtract(Teams,Played,Notplayed),
    select(team(L,GX,S1,S2),Notplayed,L2),
    GX = 1,
    select(team(W,GY,IFY,AY),L2,_L3),
    GY > 1,
    IFY >= S2,
    AY >= S1,
    S2 > S1,
    S1 >= 0,
    GY1 is GY - 1,
    IFY1 is IFY - S2,
    AY1 is AY - S1,
    N2 is N - 1,
    delete(Teams,team(L,GX,S1,S2),Temp),
    delete(Temp,team(W,GY,IFY,AY), Newteams),
    append(Newteams,[team(W,GY1,IFY1,AY1)],L4),
    append(Played,[team(W,GY1,IFY1,AY1)],L6),
    append(L1,[match(W,L,S2,S1)],L5),
    calculator(L4,L5,Matches,L6,N2,N1)
    ; N < N1 ->
    N2 is N1//2,
    calculator(Teams,L1,Matches,[],N,N2)).

calculator([H1,H2|[]],L1,Matches,_,_,_):-
    select(team(L,_,S1,S2),[H1,H2|[]],L2),
    select(team(W,_,IFY,AY),L2,_L3),
    IFY = S2,
    AY = S1,
    S2 > S1,
    S1 >= 0,
    append(L1,[match(W,L,S2,S1)],Matches).

mundial(F,Matches):-
    read_input(F,N,Teams),
    N1 is N//2,
    N2 is N - 1,
    calculator(Teams, [], Matches, [], N2, N1).
