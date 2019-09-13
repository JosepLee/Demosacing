function A = sw(w1)
%B样条函数为基础的权重计算函数，输入点与插值点的距离，然后计算权重
w=abs(w1);
if w<1&&w>=0
  A=(2/3)+0.5*w^3-w^2;
elseif w>=1&&w<2
  A=(2-w)^3/6;
else 
  A=0;
end


