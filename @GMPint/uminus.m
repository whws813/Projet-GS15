function GMPint_res = uminus(GMPint1)

if ~isa(GMPint1,'GMPint')
	GMPint1 = GMPint( num2str(GMPint1) );
end

GMPint_res = GMPint1;
GMPint_res.signe = -1 * GMPint_res.signe;
