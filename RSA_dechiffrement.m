function RSA_dechiffrement
%%% Fonction permettant le dechiffrement d'un fichier avec RSA

% Lecture du texte (voir fonction ci-dessous) et conversion pour pouvoir utilisable sous Matlab
texte_clair = lecture_texte_entre;
[n,d] = lecture_cle;
disp('Dechiffrement en cours...');
for i = 1:size(texte_clair,1)
    C = GMPintModPower(texte_clair(i,:),d,n);
    texte_dechiffre(1,i) = char(bin2dec(num2str(char(C))));
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

%%%%% Fonction de lecture du texte %%%%%%%%%%%%%%%
function [ n,d ] = lecture_cle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
string = input('Entrez le nom de fichier contenant la cle privee\n', 's');
if exist(string)~=2
    error('Le fichier demande est introuvable');
end
fid = fopen(string);
cle = fread(fid);
fclose(fid);
for i = 1:size(cle,1)
    if cle(i,1) == 32
        n = cle (1:i-1,1);
        d = cle (i+1:end,1);
        break
    end
end
    n = bin2dec(num2str(n'-48));
    d = bin2dec(num2str(d'-48));
    n = GMPint(num2str(n));
    d = GMPint(num2str(d));
return,