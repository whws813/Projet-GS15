function RSA_dechiffrement
%%% Fonction permettant le dechiffrement d'un fichier avec RSA

% Lecture du texte (voir fonction ci-dessous) et conversion pour pouvoir utilisable sous Matlab
texte_chiffre = lecture_texte_entre;
[p,q,dp,dq,qinv] = lecture_cle;
disp('Dechiffrement en cours...');
for i = 1:size(texte_chiffre,1)
    mp = GMPintModPower(texte_chiffre(i,:),dp,p);
    mq = GMPintModPower(texte_chiffre(i,:),dq,p);
    mprime = (mp - mq)*q;
    m = mprime * qinv + mq;
    texte_dechiffre(1,i) = char(bin2dec(num2str(char(m))));
end

fid = fopen('./RSAdechiff.txt','w');
fwrite(fid,texte_dechiffre);
fclose(fid);
disp('Message dechiffre:');
disp(texte_dechiffre);
disp('Enregistre dans RSAdechiff.txt');
return

%%%%% Fonction de lecture du texte %%%%%%%%%%%%%%%
function [ texte ] = lecture_texte_entre
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

string = input('Entrez le nom de fichier a dechiffrer\n', 's');
if exist(string)~=2
	error('Le fichier demande est introuvable');
end

fid = fopen(string);
texte_chiffre = fread(fid);
fclose(fid);
for i=1:8:size(texte_chiffre,1)
    message = texte_chiffre(i:i+7);
    texte((i+7)/8,:) = hex2dec(char(message'));
end
return,

%%%%% Fonction de lecture de la cle privee %%%%%%%%%%%%%%%
function [ p,q,dp,dq,qinv ] = lecture_cle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
string = input('Entrez le nom de fichier contenant la cle privee\n', 's');
if exist(string)~=2
    error('Le fichier demande est introuvable');
end
fid = fopen(string);
cle = fread(fid);
fclose(fid);

%trouver la position des espaces pour savoir la taille de chaque nombre
j = 1;
for i = 1:size(cle,1)
    if cle(i,1) == 32
        position(1,j) = i;
        j = j+1;
    end
end
p = cle(1:position(1)-1);
q = cle(position(1)+1:position(2)-1);
dp = cle(position(2)+1:position(3)-1);
dq = cle(position(3)+1:position(4)-1);
qinv = cle(position(4)+1:end);

p = bin2dec(num2str(p'-48));
q = bin2dec(num2str(q'-48));
dp = bin2dec(num2str(dp'-48));
dq = bin2dec(num2str(dq'-48));
qinv = bin2dec(num2str(qinv'-48));

p = GMPint(num2str(p));
q = GMPint(num2str(q));
dp = GMPint(num2str(dp));
dq = GMPint(num2str(dq));
qinv = GMPint(num2str(qinv));
return,