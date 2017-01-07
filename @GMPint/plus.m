function GMPint_res = plus(GMPint1 , GMPint2)


if ~isa(GMPint1,'GMPint')
	GMPint1 = GMPint( num2str(GMPint1) );
end
if ~isa(GMPint2,'GMPint')
	GMPint2 = GMPint( num2str(GMPint2) );
end

taille_GMPint1 = numel(GMPint1);
taille_GMPint2 = numel(GMPint2);

if nargin~=2 || taille_GMPint1~=1 || taille_GMPint2~=1 
  error('Une addition avec plus de deux elements ?')
end

nb_chiffres1 = length(GMPint1.liste_chiffres);
nb_chiffres2 = length(GMPint2.liste_chiffres);

if nb_chiffres1>nb_chiffres2
	GMPint2.liste_chiffres(nb_chiffres1-nb_chiffres2+1:nb_chiffres1) = GMPint2.liste_chiffres;
	GMPint2.liste_chiffres(1:nb_chiffres1-nb_chiffres2)=0;
    GMPint_res.signe=GMPint1.signe;

elseif nb_chiffres2>nb_chiffres1
	GMPint1.liste_chiffres(nb_chiffres2-nb_chiffres1+1:nb_chiffres2) = GMPint1.liste_chiffres;
	GMPint1.liste_chiffres(1:nb_chiffres2-nb_chiffres1)=0;
    GMPint_res.signe=GMPint2.signe;

end,  

if ~exist('GMPint_res','var')
    if ( GMPint1.signe == GMPint2.signe )
        GMPint_res.signe=GMPint1.signe;
        GMPint1.signe=1;
        GMPint2.signe=1;
    end,
end,

if ~exist('GMPint_res','var')
    for indice=1:max( nb_chiffres1 , nb_chiffres2 ),
        if (GMPint1.liste_chiffres(indice) > GMPint2.liste_chiffres(indice))
            GMPint_res.signe=GMPint1.signe;
            break;
        end,
        if (GMPint2.liste_chiffres(indice) > GMPint1.liste_chiffres(indice))
            GMPint_res.signe=GMPint2.signe;
            break;
        end,
    end,
end,

indice_inv=1;
if ( GMPint1.signe ==-1 && GMPint2.signe ==-1 ) || ( GMPint1.signe ~= GMPint2.signe ) && (GMPint_res.signe ==-1)
    indice_inv=-1;
end,

liste_chiffres = indice_inv * [ 0 GMPint1.signe * GMPint1.liste_chiffres + GMPint2.signe * GMPint2.liste_chiffres];
retenues = (liste_chiffres > 9) | (liste_chiffres < 0);

while (~all(retenues==0))
    liste_chiffres_avant = liste_chiffres;
    liste_chiffres = mod(liste_chiffres , 10);
    retenues = (liste_chiffres_avant - liste_chiffres)/10;
    
    liste_chiffres(1:end-1) = retenues(2:end) + liste_chiffres(1:end-1);
    retenues = (liste_chiffres > 9) | (liste_chiffres < 0);
end,

GMPint_res.liste_chiffres = liste_chiffres;

GMPint_res = GMPint(GMPint_res.liste_chiffres , GMPint_res.signe);
