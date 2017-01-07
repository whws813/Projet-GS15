function [res_char] = char(GMPint_input, form)

if nargin==1 
	form=0;
end

if form==0
    liste_chiffres = GMPint_input.liste_chiffres;
    liste_bits = zeros( 1 , ceil(numel(liste_chiffres)*log2(10)) );
    indice_bits=1;
    while ~all(liste_chiffres==0),
        liste_bits(end-indice_bits+1) = mod(liste_chiffres(end) , 2 );
        retenues = rem(liste_chiffres,2);
        liste_chiffres = floor(liste_chiffres/2);
        liste_chiffres(2:end)=liste_chiffres(2:end)+retenues(1:end-1)*5;
        indice_bits = indice_bits + 1;
    end,

    liste_bits = liste_bits( find(liste_bits,1,'first') : end);
	res_char = liste_bits;
	return
else
	res_char = GMPint_input.liste_chiffres;
	return
end


