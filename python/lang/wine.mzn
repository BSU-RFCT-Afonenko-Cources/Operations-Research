include "all_equal.mzn";

enum Vine = {Full, Half, Zero};
array[Vine] of int : Volume = [2, 1, 0]; 
array[Vine] of int : Bottles = [20, 20, 20];

int: N = 10;

set of int: BottleRange = 0..max(Bottles);
set of int: Pearson = 1..N;

array[Pearson, Vine] of var BottleRange : Distribution;

% сумма по объёму бутылок для каждого
constraint all_equal(
  [
    sum(j in Vine)(
      Distribution[i,j] * Volume[j]
    ) 
    | i in Pearson
  ] 
);

% сумма по количеству бутылок для каждого
constraint all_equal(
  [
    sum(i in Pearson)(
      Distribution[i,j]
    ) 
    | j in Vine
  ] 
);

% общее совпадение числа бутылок каждого вида
constraint forall(j in Vine)(
sum(i in Pearson)(Distribution[i,j]) = Bottles[j]
);


solve satisfy;

output "\t\t";
output [show(j) ++ "\t" |j in Vine];
output "\n";
output [if j==Full then "Студент \(i):\t" endif ++ show(Distribution[i,j]) ++ "\t" ++ if j==Zero then "\n" endif  | i in Pearson, j in Vine];
