function GMPint_res = mtimes(GMPint1 , GMPint2)


if ~isa(GMPint1,'GMPint')
	GMPint1 = GMPint( num2str(GMPint1) );
end
if ~isa(GMPint2,'GMPint')
	GMPint2 = GMPint( num2str(GMPint2) );
end


taille_GMPint1 = numel(GMPint1);
taille_GMPint2 = numel(GMPint2);

if nargin~=2 || taille_GMPint1~=1 || taille_GMPint2~=1 
  error('Une multiplication avec plus de deux elements ?')
end

if ~isa(GMPint1,'GMPint')
	GMPint1 = GMPint( num2str(GMPint1) );
end
if ~isa(GMPint2,'GMPint')
	GMPint2 = GMPint( num2str(GMPint2) );
end

nb_chiffres1 = length(GMPint1.liste_chiffres);
nb_chiffres2 = length(GMPint2.liste_chiffres);
% nb_chiffres = max(nb_chiffres1,nb_chiffres2);

if nb_chiffres2>nb_chiffres1
    tmp=GMPint1;
    GMPint1=GMPint2;
    GMPint2=tmp;
    nb_chiffres1 = length(GMPint1.liste_chiffres);
    nb_chiffres2 = length(GMPint2.liste_chiffres);
end,

GMPint_res.signe = GMPint1.signe * GMPint2.signe;


GMPint_res.liste_chiffres = zeros( 1 , nb_chiffres1 + nb_chiffres2);

for indice_mult = 1:nb_chiffres2
    liste_chiffres = [ 0 GMPint1.liste_chiffres * GMPint2.liste_chiffres(end-indice_mult+1) , zeros(1,indice_mult-1)];
    retenues = (liste_chiffres > 9);
    while (~all(retenues==0))
        liste_chiffres_avant = liste_chiffres;
        liste_chiffres = mod(liste_chiffres , 10);
        retenues = (liste_chiffres_avant - liste_chiffres)/10;

        liste_chiffres(1:end-1) = retenues(2:end) + liste_chiffres(1:end-1);
        retenues = (liste_chiffres > 9);
    end,
    liste_chiffres = liste_chiffres( find(liste_chiffres,1,'first') : end);
%     liste_chiffres_char = num2str(liste_chiffres);
%     liste_chiffres = GMPint( liste_chiffres_char( find( liste_chiffres_char~= ' ' ) ) );
    GMPint_res.liste_chiffres(end-numel(liste_chiffres)+1:end) = GMPint_res.liste_chiffres(end-numel(liste_chiffres)+1:end) + liste_chiffres;
end,

retenues = (GMPint_res.liste_chiffres > 9);
while (~all(retenues==0))
    liste_chiffres_avant = GMPint_res.liste_chiffres;
    GMPint_res.liste_chiffres = mod(GMPint_res.liste_chiffres , 10);
    retenues = (liste_chiffres_avant - GMPint_res.liste_chiffres)/10;
    
    GMPint_res.liste_chiffres(1:end-1) = retenues(2:end) + GMPint_res.liste_chiffres(1:end-1);
    retenues = (GMPint_res.liste_chiffres > 9);
end,



GMPint_res = GMPint(GMPint_res.liste_chiffres , GMPint_res.signe);
