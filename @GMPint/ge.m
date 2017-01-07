function GMPint_res = ge(GMPint1 , GMPint2)


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

nb_chiffres1 = length(GMPint1.liste_chiffres);
nb_chiffres2 = length(GMPint2.liste_chiffres);


if ( GMPint1.signe > GMPint2.signe)
	GMPint_res = 1;
	return,
elseif ( GMPint1.signe < GMPint2.signe)
	GMPint_res = 0;
	return,
end,

if ( GMPint1.signe ==-1  &&  GMPint2.signe ==-1 )
	negation = 1;
else
	negation = 0;
end

if ( nb_chiffres1 > nb_chiffres2)
	GMPint_res = 1;
	return,
elseif ( nb_chiffres1 < nb_chiffres2)
	GMPint_res = 0;
	return,
end

k=1;
test_equality=0;
while ( test_equality==0 && k <= nb_chiffres1 ) 
	if GMPint1.liste_chiffres(k) > GMPint2.liste_chiffres(k) 
		test_equality=1;
	elseif GMPint1.liste_chiffres(k) < GMPint2.liste_chiffres(k) 
		test_equality=-1;
	end,
    k=k+1;
end,

if test_equality==0
	GMPint_res = 1;
elseif test_equality==1 && negation == 0
	GMPint_res = 1;
elseif test_equality==1 && negation == 1
	GMPint_res = 0;
elseif test_equality==-1 && negation == 0
	GMPint_res = 0;
elseif test_equality==-1 && negation == 1
	GMPint_res = 1;
end

