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
if strcmp(cle_entre, '"')
	if size(cle_entre,2) == 58 || size(cle_entre,2) == 66
		K0_texte = cle_entre(2:end-1);
		K0 = double(K0_texte)-48;
	else
		error('La cle doit faire 56 ou 64 bits');
	end
else
	cle_entre = str2num(cle_entre);
	rand('twister', cle_entre);
	K0 = rand(1,64)>0.5;
end,

if size(K0,2) == 64
	for i=1:8
		K0(i*8) = 1-mod(sum(K0((i-1)*8+1:i*8-1)),2);
	end,
else
	for i=1:8
		K0(i*8+1:end+1) = K0(i*8:end);
		K0(i*8) = 1-mod(sum(K0((i-1)*8+1:i*8-1)),2);
	end,
end,

% Generation des cles K1, ... , K16
PC1g = [ 57 , 49 , 41 , 33 , 25 , 17 , 9 , 1 , 58 , 50 , 42 , 34 , 26 , 18 , 10 , 2 , 59 , 51 , 43 , 35 , 27 , 19 , 11 , 3 , 60 , 52 , 44 , 36 ];
PC1d = [ 63 , 55 , 47 , 39 , 31 , 23 , 15 , 7 , 62 , 54 , 46 , 38 , 30 , 22 , 14 , 6 , 61 , 53 , 45 , 37 , 29 , 21 , 13 , 5 , 28 , 20 , 12 , 4 ];
L0 = K0(1,PC1g);
R0 = K0(1,PC1d);

PC2 = [ 14 , 17 , 11 , 24 , 1 , 5 , 3 , 28 , 15 , 6 , 21 , 10 , 23 , 19 , 12 , 4 , 26 , 8 , 16 , 7 , 27 , 20 , 13 , 2 , 41 , 52 , 31 , 37 , 47 , 55 , 30 , 40 , 51 , 45 , 33 , 48 , 44 , 49 , 39 , 56 , 34 , 53 , 46 , 42 , 50 , 36 , 29 , 32 ] ;
keys_bin = zeros(16,48);

for i=1:16
	vi = 2;
	if i==1 || i==2 || i==9 || i==16, vi=1; end
	%Permutation circulaire
	tmp = L0(1:vi);
	L0(1:end-vi) = L0(vi+1:end);
	L0(end-vi+1:end) = tmp;

	tmp = R0(1:vi);
	R0(1:end-vi) = R0(vi+1:end);
	R0(end-vi+1:end) = tmp;

	%Application de la fonction PC2
	S0 = [L0 R0];
	keys_bin(i,:) = S0(PC2);
	
end,

return,

