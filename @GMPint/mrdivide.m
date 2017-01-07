function [ GMPint_quotient GMPint_reste ] = mrdivide(GMPint1 , GMPint2)

if ~isa(GMPint1,'GMPint')
	GMPint1 = GMPint( num2str(GMPint1) );
end
if ~isa(GMPint2,'GMPint')
	GMPint2 = GMPint( num2str(GMPint2) );
end


taille_GMPint1 = numel(GMPint1);
taille_GMPint2 = numel(GMPint2);

if nargin~=2 || taille_GMPint1~=1 || taille_GMPint2~=1 
  error('Une division avec plus de deux elements ?')
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
    GMPint_quotient.liste_chiffres=0;
end,

GMPint_quotient.signe = GMPint1.signe * GMPint2.signe;


if ~isfield(GMPint_quotient,'liste_chiffres')
    decalage=nb_chiffres1-nb_chiffres2;
    GMPint_quotient.liste_chiffres = zeros(1, decalage+1);
    index_decalage=0;
    
    numerateur=GMPint(GMPint1.liste_chiffres , 1);
    denominateur=GMPint(GMPint2.liste_chiffres , 1);
    
    while (index_decalage <=decalage)
        index_decalage = index_decalage+1;
        soustracteur=GMPint([ denominateur.liste_chiffres zeros(1, decalage+1-index_decalage) ] , 1);
        reste = numerateur - soustracteur;
        while (reste.signe >= 0)
            GMPint_quotient.liste_chiffres(index_decalage) = GMPint_quotient.liste_chiffres(index_decalage) + 1;
            numerateur = numerateur - soustracteur;
            reste = numerateur - soustracteur;
        end,
    end,
    %     end
end,

GMPint_quotient = GMPint(GMPint_quotient.liste_chiffres , GMPint_quotient.signe);

GMPint_reste = GMPint1 - GMPint_quotient * GMPint2;

if (GMPint_quotient * GMPint2 + GMPint_reste ) ~= GMPint1
    error('GLOUPS')
end