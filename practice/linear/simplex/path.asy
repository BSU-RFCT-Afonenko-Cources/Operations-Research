import graph3;
settings.render = 2;

currentprojection=orthographic(2,1.2,1.5,center=true);

size(10cm);

real s = 0.5;
triple A = (0,0,0);

triple B = (0,1,0);
triple y = B + (0,s,0);

triple C = (1,0,0);
triple x = C + (s,0,0);

triple D = (0,0,1);
triple z = D + (0,0,s);

triple E = (1,1,0);
triple F = (1,0,1);
triple G = (0,1,1);

triple J = (1,0.5,1);
triple H = (0.5,1,1);
triple I = (1,1,0.5);

draw(A--C, dashed);
draw(A--D, dashed);
draw(A--B, dashed);
draw(C--E);
draw(C--F);
draw(E--B);
draw(D--G);
draw(F--D);
draw(B--G);

draw(F--J);
draw(E--I);
draw(G--H);
draw(J--H);
draw(J--I);
draw(H--I);

draw(D--z);
draw(C--x);
draw(B--y);

label("A", A, S);
label("B", B, NE);
label("C", C, S);
label("D", D, NE);
label("E", E, S);
label("F", F, NW);
label("G", G, NE);

label("J", J, SW);
label("H", H, N);
label("I", I, SE);

label("$x$",x,S);
label("$y$",y,NE);
label("$z$",z,N);
