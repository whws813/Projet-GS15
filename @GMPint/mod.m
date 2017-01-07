function GMPint_res = mod(GMPint1,GMPint2)


if ~isa(GMPint1,'GMPint')
	GMPint1 = GMPint( num2str(GMPint1) );
end
if ~isa(GMPint2,'GMPint')
	GMPint2 = GMPint( num2str(GMPint2) );
end


[ q r ] = GMPint1 / GMPint2;
if (r.signe == -1*  GMPint2.signe)
    GMPint_res = r + GMPint2;
else
    GMPint_res = r;
end,
