function [n,e] = generation_cleRSA&PKCS(nb_bits)
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

%calcul de d,dp et dq
d = GMPinverse(e,phi_n);
dp = mod(d,p-1);
dq = mod(d,q-1);

%calcul inverse de q dans Zp
qinv = GMPinverse(q,p);

%enregistrer les cles
ecriture_clePublic(n,e,'./publicKey.txt');
ecriture_clePrivee(p,q,dp,dq,qinv,'./privateKey.txt');
return

%%%% Fonction d'ecriture d'une cle public %%
function ecriture_clePublic(GMPint1,GMPint2,nom)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


n = uint8(char(GMPint1)) + 48;
e = uint8(char(GMPint2)) + 48;
texte = [n,uint8(' '),e];
fid = fopen(nom,'w');
fwrite(fid,texte);
fclose(fid);
disp('La cle privee est enregistre dans privateKey.txt');
return

%%%% Fonction d'ecriture d'une cle privee %%
function ecriture_clePrivee(p,q,dp,dq,qinv,nom)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


p = uint8(char(p)) + 48;
q = uint8(char(q)) + 48;
dp = uint8(char(dp)) + 48;
dq = uint8(char(dq)) + 48;
qinv = uint8(char(qinv)) + 48;
texte = [p,uint8(' '),q,uint8(' '),dp,uint8(' '),dq,uint8(' '),qinv];
fid = fopen(nom,'w');
fwrite(fid,texte);
fclose(fid);
disp('La cle public est enregistre dans publicKey.txt');
return