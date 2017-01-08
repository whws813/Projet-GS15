function RSA_chiffrement
%%% Fonction permettant le chiffrement d'un fichier avec RSA

% Lecture du texte (voir fonction ci-dessous) et conversion pour pouvoir utilisable sous Matlab
texte_clair = lecture_texte_entre;
[n,e] = lecture_cle;
disp('Chiffrement en cours...');
for i = 1:size(texte_clair,1)
    C = GMPintModPower(texte_clair(i,:),e,n);
    texte_chiffre(1,8*i-7:8*i) = dec2hex(bin2dec(num2str(char(C))),8);
end

%Enregistrer la message chiffre
fid = fopen('./RSAchiff.txt','w');
fwrite(fid,texte_chiffre);
fclose(fid);
disp('Message chiffre:');
disp(texte_chiffre);
disp('Enregistre dans RSAchiff.txt');
return

%%%%% Fonction de lecture du texte %%%%%%%%%%%%%%%
function [ texte_clair ] = lecture_texte_entre
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

string = input('Entrez le nom de fichier a chiffrer\n', 's');
if exist(string)~=2
	error('Le fichier demande est introuvable');
end

fid = fopen(string);
texte_clair = fread(fid);
fclose(fid);
return,

%%%%% Fonction de lecture de la cle %%%%%%%%%%%%%%%
function [ n,e ] = lecture_cle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
string = input('Entrez le nom de fichier contenant la cle public\n', 's');
if exist(string)~=2
    error('Le fichier demande est introuvable');
end
fid = fopen(string);
cle = fread(fid);
fclose(fid);
%cle = char(reshape(cle,1,[]));
for i = 1:size(cle,1)
    if cle(i,1) == 32
        n = cle (1:i-1,1);
        e = cle (i+1:end,1);
        break
    end
end
n = bin2dec(num2str(n'-48));
e = bin2dec(num2str(e'-48));
n = GMPint(num2str(n));
e = GMPint(num2str(e));
return,