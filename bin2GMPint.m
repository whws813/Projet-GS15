function [GMPint_res res_char] = bin2GMP(int_char)

GMPint_res = [];

nb_chiffres = size(int_char);
if (nb_chiffres(1)~=1)
    error('Vous devez un unique nombre')
end

if int_char(1) == '-';
    GMPint_res.signe = -1;
    int_char = int_char(2:end);
else
    GMPint_res.signe = 1;
end


nb_chiffres = nb_chiffres(2);
if ~all(ismember(int_char,'01')),
    error('Vous devez un unique nombre')
end,

liste_bits = double(int_char)-48;
GMPint_res.liste_bits = liste_bits;

liste_chiffres = zeros(1, ceil(nb_chiffres*log10(2) ) );
GMPint_res.liste_chiffres = liste_chiffres;

liste_chiffres(end) = 1;
indice_bits=1;
tmp=0;
while ~all(liste_bits==0),
    if ( liste_bits(end-indice_bits+1) ~= 0)
        GMPint_res.liste_chiffres = GMPint_res.liste_chiffres + liste_chiffres;
        retenues = floor( GMPint_res.liste_chiffres / 10);
        while ~all(~retenues)
            GMPint_res.liste_chiffres = rem( GMPint_res.liste_chiffres , 10);
            GMPint_res.liste_chiffres(1:end-1) = GMPint_res.liste_chiffres(1:end-1) + retenues(2:end);
            retenues = floor( GMPint_res.liste_chiffres / 10);
        end,
    end,
    liste_chiffres = liste_chiffres*2;
    retenues = floor( liste_chiffres / 10);
    while ~all(~retenues)
        liste_chiffres = rem( liste_chiffres , 10);
        liste_chiffres(1:end-1) = liste_chiffres(1:end-1) + retenues(2:end);
        retenues = floor( liste_chiffres / 10);
    end,
    liste_bits = liste_bits(1:end-1);
end,

GMPint_res.liste_bits = GMPint_res.liste_bits( find(GMPint_res.liste_bits,1,'first') : end);

GMPint_res.liste_chiffres = GMPint_res.liste_chiffres( find(GMPint_res.liste_chiffres,1,'first') : end);

%GMPint_res = class(GMPint_res,'GMPint');
res_char = char(GMPint_res.liste_chiffres+48);

GMPint_res = GMPint(res_char);