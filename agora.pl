read_input(File, Days) :-
    open(File, read, Stream),
    read_line_to_codes(Stream, _),
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(As, ' ', Atom),
    maplist(atom_number, As, Days).

gcd(N1,N2,R):-
    N1 > N2,
    N2 > 0,
    Temp is N1 mod N2,
    gcd(Temp, N2,R).

gcd(N1,N2,R):-
    N1 < N2,
    N1 > 0,
    Temp2 is N2 mod N1,
    gcd(N1,Temp2, R).

gcd(N1,N2,R):-
    N1 = 0,
    R = N2.

gcd(N1,N2,R):-
    N2 = 0,
    R = N1.


lcm(X,Y,LCM):-
    gcd(X,Y,GCD),
    TEMP is X//GCD,
    LCM is TEMP*Y.

lcm_list([H|T], [], Ekp1):-
    lcm_list(T,[H], Ekp1).

lcm_list([], P, Ekp1):-
    reverse(P,Ekp1).

lcm_list([H|T],[X|[]], Ekp1):-
    lcm(X, H, R),
    lcm_list(T, [R,X], Ekp1).

lcm_list([H|T],[H1|T1], Ekp1):-
    lcm(H, H1, R),
    lcm_list(T, [R,H1|T1], Ekp1).

totalekp([HE1|TE1],[HE2,HE22|TE2], [], Ekp):-
    totalekp([HE1|TE1], TE2, [HE22,HE2], Ekp).

totalekp([H|_],[], [H1|T1], Ekp):-
    reverse([H,H1|T1],Ekp).

totalekp([HE1|TE1], [HE2|TE2], [HD|TL], Ekp):-
    lcm(HE1,HE2,R),
    totalekp(TE1,TE2, [R,HD|TL], Ekp).

agora(F, When, Missing):-
    read_input(F, Days),
    lcm_list(Days, [], Ekp1),
    reverse(Days,Rev),
    lcm_list(Rev, [], Ekptemp),
    reverse(Ekptemp,Ekp2),
    totalekp(Ekp1,Ekp2, [], Ekp),
    min_list(Ekp,When),
    nth0(Missing,Ekp,When),
    !.
