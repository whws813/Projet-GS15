function VCES_chiffrement
%fonction permettant le chiffrement d'un fichier avec VCES (AES + DES)

% Lecture du texte (voir fonction ci-dessous) et conversion pour pouvoir utilisable sous Matlab
texte_clair_bin = lecture_texte_entre;

% Lecture de la cl?(voir fonction ci-dessous) et g??ation des 16 les sous-cl? 
%cles = lecture_cle_entre;
return,

%%%%% Fonction de lecture du texte %%%%%%%%%%%%%%%
function [ texte_clair_bin ] = lecture_texte_entre
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

string = input('Entrez le nom de votre fichier\n', 's');
if exist(string)~=2
	error('Le fichier demande est introuvable');
end

fid = fopen(string);
texte_clair = fread(fid);
fclose(fid);
texte_clair_bin = dec2bin(texte_clair,8);

bit_stuff = ceil(size(texte_clair_bin,1)/16)*16;
if bit_stuff > size(texte_clair_bin,1)
	nb_char = bit_stuff - size(texte_clair_bin,1);
	texte_clair_bin(end+1:bit_stuff,:) = texte_clair_bin(end-nb_char+1:end,:);
end,
disp(texte_clair_bin);
texte_clair_bin = uint8(reshape(texte_clair_bin',32,[])')-48;
disp(texte_clair_bin);
return,

%%%%% Fonction de lecture du texte %%%%%%%%%%%%%%%
function [ keys_bin ] = lecture_cle_entre
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cle_entre = input('Entrez votre cle de chiffrement\n Soit un char de 64 ou 56 (\"01\"), soit un numerique (utilise comme graine) \n', 's');

cle_ok = 0;
while cle_ok == 0
    cle_entre = input('Entrez votre cle de chiffrement\n4 ou 8 ou 16 lettres ou numbres\n', 's');
    if (size(cle_entre,2) == 4) || (size(cle_entre,2) == 8) || (size(cle_entre,2) == 16)
        cle_ok = 1;
    end
end
cle_bin = dec2bin(cle_entre,8);
if size(cle_bin,1) == 4
    cle_bin(5:8,:) = cle_bin(1:4,:);
    cle_bin(9:16,:) = cle_bin(1:8,:);
elseif size(cle_bin,1) == 8
    cle_bin(9:16,:) = cle_bin(1:8,:);
end

return,

