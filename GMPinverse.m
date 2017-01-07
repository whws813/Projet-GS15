function [inverse] = GMPinverse(GMPint1,GMPint2)
% function permettant de calculer inverse de GMPint1 dans GMPint2 en
% utilisant l'algorithme d'Euclide etendu

res = GMPint1;
a = GMPint2;
b = GMPint1;
y0 = 0;
y1 = 1;
round = 0;
while res ~= 1
    res = mod(a,b);
    q = a/b;
    tmp = y1;
    y1 = q*y1 + y0;
    y0 = tmp;
    a = b;
    b = res;
    round = round + 1;
end
if (mod(round,2)==1)
    inverse = mod(-1*y1,GMPint2);
else
    inverse = y1;
end
return