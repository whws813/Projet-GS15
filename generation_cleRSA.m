function [n,e,d] = generation_cleRSA(nb_bits)
% Function permettant de generer un cle privee et un cle public
% [n,e] est la cle privee, b est la cle public
% d est l'inverse de e dans Z/phi(n)
% nb_bits est la taille de n

disp('Generation en cours...');
% generation de p
p = GMPrand_impair(nb_bits/2);
while(test_primality(p) == 0)
    p = GMPrand_impair(nb_bits/2);
end

%genertion de q
q = GMPrand_impair(nb_bits/2);
while(test_primality(q) == 0)
    q = GMPrand_impair(nb_bits/2);
end

%generation de e
e = GMPrand(4);
while((pgcdGMP(e,p-1) ~= 1) || (pgcdGMP(e,q-1) ~= 1))
    e = GMPrand(4);
end

n = p*q;
phi_n = (p-1)*(q-1);

%calcul de d
d = GMPinverse(e,phi_n);

ecriture_cle(n,e,'publicKey.txt','cle public');
ecriture_cle(n,d,'privateKey.txt','cle privee');
return

%%%% Fonction d'ecriture d'une cle public %%
function ecriture_cle(GMPint1,GMPint2,nom,type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a = uint8(char(GMPint1)) + 48;
b = uint8(char(GMPint2)) + 48;
texte = [a,uint8(' '),b];
fid = fopen(nom,'w');
fwrite(fid,texte);
fclose(fid);
fprintf('La %s est enregistre dans %s\n',type,nom);
return