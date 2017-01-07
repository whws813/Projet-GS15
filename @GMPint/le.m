function GMPint_res = le(GMPint1 , GMPint2)


if ~isa(GMPint1,'GMPint')
	GMPint1 = GMPint( num2str(GMPint1) );
end
if ~isa(GMPint2,'GMPint')
	GMPint2 = GMPint( num2str(GMPint2) );
end

if ( GMPint1 == GMPint2 )
	GMPint_res = 1;
	return,
end

test_gt = gt(GMPint1 , GMPint2);

if ( test_gt == 0 )
	GMPint_res = 1;
else
	GMPint_res = 0;
end,