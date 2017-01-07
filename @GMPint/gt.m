function GMPint_res = gt(GMPint1 , GMPint2)


if ~isa(GMPint1,'GMPint')
	GMPint1 = GMPint( num2str(GMPint1) );
end
if ~isa(GMPint2,'GMPint')
	GMPint2 = GMPint( num2str(GMPint2) );
end

if ( GMPint1 == GMPint2 )
	GMPint_res = 0;
	return,
end

GMPint_res = ge(GMPint1 , GMPint2);
