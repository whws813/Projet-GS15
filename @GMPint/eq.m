function res_egalite = eq(GMPint1 , GMPint2)

if ~isa(GMPint1,'GMPint')
	GMPint1 = GMPint( num2str(GMPint1) );
end
if ~isa(GMPint2,'GMPint')
	GMPint2 = GMPint( num2str(GMPint2) );
end


taille_GMPint1 = numel(GMPint1);
taille_GMPint2 = numel(GMPint2);

if nargin~=2 || taille_GMPint1~=1 || taille_GMPint2~=1 
  error('Une égalite avec plus de deux elements ?')
end

nb_chiffres1 = length(GMPint1.liste_chiffres);
nb_chiffres2 = length(GMPint2.liste_chiffres);

if ( nb_chiffres1 ~= nb_chiffres2 )
    res_egalite=0;
else
    if ( all(GMPint1.liste_chiffres == GMPint2.liste_chiffres) && (GMPint1.signe == GMPint2.signe) )
        res_egalite=1;
    else
        res_egalite=0;
    end,
end,