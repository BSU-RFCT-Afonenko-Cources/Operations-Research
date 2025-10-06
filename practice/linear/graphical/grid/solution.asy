import graph;
size(120,120);
pen p = opacity(0);
dot((0,0),p);
dot((8,8),p);
pen thin=linewidth(0.5*linewidth());
xaxis("$x_1$",BottomTop,black,
      LeftTicks(begin=false,
                end=false,
                extend=true,
                ptick=thin));
yaxis("$x_2$",LeftRight,black,
      RightTicks(begin=false,
                 end=false,
                 extend=true,
                 ptick=thin));
