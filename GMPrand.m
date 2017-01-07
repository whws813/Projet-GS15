function GMPint_res = GMPrand(nb_bits)

if nargin == 0
	error('vous devez entrer au moins 1 augument (le nombre de bits de l entier long aléatoire')
end

num_bin = round(rand(1,nb_bits));
num_bin(1) = 1;
GMPint_res=bin2GMPint( char(num_bin +48) );