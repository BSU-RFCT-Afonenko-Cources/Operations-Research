int: N = 6;
enum Operation = {Bring, Saw, TakeAway};

set of Operation: Porters = { Bring, TakeAway };
set of Operation: Sawyer = { Saw };

array[Operation] of int : Duration = [20, 25, 20];
int: ConsecutiveTime = N*sum(Duration);

set of int: Logs = 1..N;

array[Logs, Operation] of var 0..ConsecutiveTime : S;
array[Logs, Operation] of var 0..ConsecutiveTime : F;

% соотношение между временем начала и окончания
constraint forall(i in Logs, o in Operation)(
    F[i,o] = S[i,o] + Duration[o]
);

% операции каждого бревна выполняются последовательно
constraint forall(i in Logs)(
    F[i,Bring] <= S[i,Saw] /\ F[i,Saw] <= S[i,TakeAway]
);

include "cumulative.mzn";
% операции носильщиков не перекрываются
constraint cumulative([ S[i, o] | i in Logs, o in Porters],
                      [ Duration[o] | i in Logs, o in Porters ],
                      [ 1 | i in Logs, o in Porters ],
                      1);

% операции распиловки не перекрываются
constraint cumulative([ S[i, Saw] | i in Logs],
                      [ Duration[Saw] | i in Logs],
                      [ 1 | i in Logs],
                      1);

% только два интервала между заносом и выносом могут перекрываться
predicate overlap(var int: s1, var int: f1, var int: s2, var int: f2) =
    s1 <= f2 /\ s2 <= f1;

constraint forall(i in Logs, j in Logs where j > i, k in Logs where k > j)
(
    sum([bool2int(overlap(F[i,Bring],S[i,TakeAway],F[j,Bring],S[j,TakeAway])),
    bool2int(overlap(F[i,Bring],S[i,TakeAway],F[k,Bring],S[k,TakeAway])),
    bool2int(overlap(F[j,Bring],S[j,TakeAway],F[k,Bring],S[k,TakeAway]))]) <= 2
);

solve minimize max( [F[i,TakeAway] | i in Logs] );
