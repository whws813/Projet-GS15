function [res] = pgcdGMP(GMPint1,GMPint2)

if ~isa(GMPint1,'GMPint')
	GMPint1 = GMPint( num2str(GMPint1) );
end
if ~isa(GMPint2,'GMPint')
	GMPint2 = GMPint( num2str(GMPint2) );
end

res = GMPint2;

while res ~= 0
    res = mod(GMPint1,GMPint2);
    GMPint1 = GMPint2;
    GMPint2 = res;
end

res = GMPint1;
return