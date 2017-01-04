function VCES_chiffrement
%fonction permettant le chiffrement d'un fichier avec VCES (AES + DES)

% Lecture du texte (voir fonction ci-dessous) et conversion pour pouvoir utilisable sous Matlab
texte_clair_bin = lecture_texte_entre;

% Lecture de la cl?(voir fonction ci-dessous) et g??ation des 16 les sous-cl? 
cle = lecture_cle_entre;
cleDES1 = SousCleDES(cle(1:8,:));
cleDES2 = SousCleDES(cle(9:16,:));
cleAES = SousCleAES(cle);

for line = 1:4:size(texte_clair_bin)
    state = texte_clair_bin(line:line+3,:);
    for round = 1:10
        
        G1 = state(2,:);
        D1 = xor(state(1,:),Feistel_DES(state(2,:),cleDES1(round,:)));
        
        G2 = state(4,:);
        D2 = xor(state(3,:),Feistel_DES(state(4,:),cleDES2(round,:)));
        
        state = [G1;D1;G2;D2];
        
        %chiffrement AES
        state = AES_chiffrement(state,cleAES,round);
    end
    texte_chiffre_bin(line:line+3,:) = state;
end
texte_chiffre_bin = reshape(texte_chiffre_bin',8,[])';
texte_chiffre = char(bin2dec(num2str(uint8(texte_chiffre_bin))))';
fid = fopen('./chiffrer.txt', 'w');
fwrite(fid,texte_chiffre);
fclose(fid);
disp('Message chiffre: ');
disp(texte_chiffre);
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

%remplisser le texte_claire_bin par espace
size_texte = size(texte_clair_bin,1);
bit_stuff = ceil(size_texte/16)*16;
if bit_stuff > size_texte
    for i = size_texte+1:bit_stuff
        texte_clair_bin(i,:) = dec2bin(' ',8);
    end 
end,

texte_clair_bin = uint8(reshape(texte_clair_bin',32,[])')-48;
return,

%%%%% Fonction de lecture de la cle %%%%%%%%%%%%%%%
function [ cle_bin ] = lecture_cle_entre
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%% Fonction de generation des sous-cles DES
function [sous_cle] = SousCleDES(cle_bin)
K0 = uint8(reshape(cle_bin',1,[]))-48;
PC1g = [ 57 , 49 , 41 , 33 , 25 , 17 , 9 , 1 , 58 , 50 , 42 , 34 , 26 , 18 , 10 , 2 , 59 , 51 , 43 , 35 , 27 , 19 , 11 , 3 , 60 , 52 , 44 , 36 ];
PC1d = [ 63 , 55 , 47 , 39 , 31 , 23 , 15 , 7 , 62 , 54 , 46 , 38 , 30 , 22 , 14 , 6 , 61 , 53 , 45 , 37 , 29 , 21 , 13 , 5 , 28 , 20 , 12 , 4 ];
L0 = K0(1,PC1g);
R0 = K0(1,PC1d);

PC2 = [ 14 , 17 , 11 , 24 , 1 , 5 , 3 , 28 , 15 , 6 , 21 , 10 , 23 , 19 , 12 , 4 , 26 , 8 , 16 , 7 , 27 , 20 , 13 , 2 , 41 , 52 , 31 , 37 , 47 , 55 , 30 , 40 , 51 , 45 , 33 , 48 , 44 , 49 , 39 , 56 , 34 , 53 , 46 , 42 , 50 , 36 , 29 , 32 ] ;
sous_cle = zeros(10,48);

for i=1:10
	vi = 2;
    if i==1 || i==2 || i==9
        vi=1; 
    end
	%Permutation circulaire
	tmp = L0(1:vi);
	L0(1:end-vi) = L0(vi+1:end);
	L0(end-vi+1:end) = tmp;

	tmp = R0(1:vi);
	R0(1:end-vi) = R0(vi+1:end);
	R0(end-vi+1:end) = tmp;

	%Application de la fonction PC2
	S0 = [L0 R0];
	sous_cle(i,:) = S0(PC2);
	
end,
return,

function [sous_cle] = SousCleAES(cle)
 cle = uint8(reshape(cle',32,[])')-48;
sous_cle = cle;
return,

%%%%% Fonction de la ronde de Feistel du DES %%%%%%%%%%%%%%%
function [ cipher_bloc ] = Feistel_DES(Droite, cle)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

E = [ 32 , 1 , 2 , 3 , 4 , 5 , 4 , 5 , 6 , 7 , 8 , 9 , 8 , 9 , 10 , 11 , 12 , 13 , 12 , 13 , 14 , 15 , 16 , 17 , 16 , 17 , 18 , 19 , 20 , 21 , 20 , 21 , 22 , 23 , 24 , 25 , 24 , 25 , 26 , 27 , 28 , 29 , 28 , 29 , 30 , 31 , 32 , 1 ];
S1 = [14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7; 0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8; 4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0; 15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13];
S2 = [15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10; 3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5; 0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15; 13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9];
S3 = [10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8; 13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1; 13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7; 1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12];
S4 = [7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15; 13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9; 10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4; 3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14];
S5 = [2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9; 14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6; 4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14; 11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3];
S6 = [12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11; 10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8; 9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6; 4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13];
S7 = [4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1; 13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6; 1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2; 6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12];
S8 = [13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7; 1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2; 7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8; 2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11];
SboxFeistel = [S1;S2;S3;S4;S5;S6;S7;S8];
Pf = [16,7,20,21,29,12,28,17,1,15,23,26,5,18,31,10,2,8,24,14,32,27,3,9,19,13,30,6,22,11,4,25];

Dprime = Droite(1,E);
B = xor(Dprime,cle);

%Application de S-box
j = 1 ;
for i = 1:8
    num_line = B(6*i-5)*2 + B(6*i) + 1;
    num_column = B(6*i-4)*8 + B(6*i-3)*4 + B(6*i-2)*2 + B(6*i-1) + 1;
    C(1,j:j+3) = dec2bin(SboxFeistel(4*(i-1)+num_line,num_column),4);
    j = j + 4;

end,

cipher_bloc = uint8(C(1,Pf))-48;
return,

%%%%% Fonction permettant de realiser une iteration de AES
function [cipher_bloc] = AES_chiffrement(state,key,round)

if (round == 1)
    state = AddRoundKey(state,key);
    state = SubBytes(state);
    state = ShiftRows(state);
    state = MixColumns(state);
    %key = KeyExpansion(key);
    state = AddRoundKey(state,key);
elseif((round>1)&&(round<10))
    state = SubBytes(state);
    state = ShiftRows(state);
    state = MixColumns(state);
    state = AddRoundKey(state,key);
else
    state = SubBytes(state);
    state = ShiftRows(state);
    state = AddRoundKey(state,key);
end

cipher_bloc = state;
return,

function [cipher_bloc] = AddRoundKey(state,key)
cipher_bloc = xor(state,key);
cipher_bloc = uint8(cipher_bloc);
return,

function [cipher_bloc] = SubBytes(state)

SboxSubBytes = ['63' '7c' '77' '7b' 'f2' '6b' '6f' 'c5' '30' '01' '67' '2b' 'fe' 'd7' 'ab' '76';
    'ca' '82' 'c9' '7d' 'fa' '59' '47' 'f0' 'ad' 'd4' 'a2' 'af' '9c' 'a4' '72' 'c0';
    'b7' 'fd' '93' '26' '36' '3f' 'f7' 'cc' '34' 'a5' 'e5' 'f1' '71' 'd8' '31' '15';
    '04' 'c7' '23' 'c3' '18' '96' '05' '9a' '07' '12' '80' 'e2' 'eb' '27' 'b2' '75';
    '09' '83' '2c' '1a' '1b' '6e' '5a' 'a0' '52' '3b' 'd6' 'b3' '29' 'e3' '2f' '84';
    '53' 'd1' '00' 'ed' '20' 'fc' 'b1' '5b' '6a' 'cb' 'be' '39' '4a' '4c' '58' 'cf';
    'd0' 'ef' 'aa' 'fb' '43' '4d' '33' '85' '45' 'f9' '02' '7f' '50' '3c' '9f' 'a8';
    '51' 'a3' '40' '8f' '92' '9d' '38' 'f5' 'bc' 'b6' 'da' '21' '10' 'ff' 'f3' 'd2';
    'cd' '0c' '13' 'ec' '5f' '97' '44' '17' 'c4' 'a7' '7e' '3d' '64' '5d' '19' '73';
    '60' '81' '4f' 'dc' '22' '2a' '90' '88' '46' 'ee' 'b8' '14' 'de' '5e' '0b' 'db';
    'e0' '32' '3a' '0a' '49' '06' '24' '5c' 'c2' 'd3' 'ac' '62' '91' '95' 'e4' '79';
    'e7' 'c8' '37' '6d' '8d' 'd5' '4e' 'a9' '6c' '56' 'f4' 'ea' '65' '7a' 'ae' '08';
    'ba' '78' '25' '2e' '1c' 'a6' 'b4' 'c6' 'e8' 'dd' '74' '1f' '4b' 'bd' '8b' '8a';
    '70' '3e' 'b5' '66' '48' '03' 'f6' '0e' '61' '35' '57' 'b9' '86' 'c1' '1d' '9e';
    'e1' 'f8' '98' '11' '69' 'd9' '8e' '94' '9b' '1e' '87' 'e9' 'ce' '55' '28' 'df';
    '8c' 'a1' '89' '0d' 'bf' 'e6' '42' '68' '41' '99' '2d' '0f' 'b0' '54' 'bb' '16'];

for i = 1:4
    for j = 1:8:32
        row = 0;
        column = 0;
        for m = j : (j+3)
            row = state(i,m)*(2^(3-m+j)) + row;
        end
        for m = (j+4):(j+7)
            column = state(i,m)*(2^(7-m+j)) + column;
        end
        row = row + 1;
        column = column + 1;
        A = SboxSubBytes(row,column*2-1:column*2);
        C(i,j:j+7) = dec2bin(hex2dec(A),8);
    end
end
cipher_bloc = uint8(C)-48;
return,

function [cipher_bloc] = ShiftRows(state)
for i = 1:4
    for j = 1:32
        row = mod((j+8*(i-1))-1,32) + 1;
        cipher_bloc(i,j) = state(i,row);
    end
end
return,

function [cipher_bloc] = MixColumns(state)
 for i=1:8:32
     byte1 = state(1,i:i+7);
     byte2 = state(2,i:i+7);
     byte3 = state(3,i:i+7);
     byte4 = state(4,i:i+7);
     state(1,i:i+7) = xor(xor(xor(multi2(byte1),multi3(byte2)),byte3),byte4);
     state(2,i:i+7) = xor(xor(xor(byte1,multi2(byte2)),multi3(byte3)),byte4);
     state(3,i:i+7) = xor(xor(xor(byte1,byte2),multi2(byte3)),multi3(byte4));
     state(4,i:i+7) = xor(xor(xor(multi3(byte1),byte2),byte3),multi2(byte4));
 end
 cipher_bloc = uint8(state);
return,

function [round_key] = KeyExpansion(key)
round_key = key;
return,

function [new_byte] = multi2(byte)
table2 = ['00','02','04','06','08','0a','0c','0e','10','12','14','16','18','1a','1c','1e', ...
     '20','22','24','26','28','2a','2c','2e','30','32','34','36','38','3a','3c','3e', ...
     '40','42','44','46','48','4a','4c','4e','50','52','54','56','58','5a','5c','5e', ...
     '60','62','64','66','68','6a','6c','6e','70','72','74','76','78','7a','7c','7e', ...
     '80','82','84','86','88','8a','8c','8e','90','92','94','96','98','9a','9c','9e', ...
     'a0','a2','a4','a6','a8','aa','ac','ae','b0','b2','b4','b6','b8','ba','bc','be', ...
     'c0','c2','c4','c6','c8','ca','cc','ce','d0','d2','d4','d6','d8','da','dc','de', ...
     'e0','e2','e4','e6','e8','ea','ec','ee','f0','f2','f4','f6','f8','fa','fc','fe', ...
     '1b','19','1f','1d','13','11','17','15','0b','09','0f','0d','03','01','07','05', ...
     '3b','39','3f','3d','33','31','37','35','2b','29','2f','2d','23','21','27','25', ...
     '5b','59','5f','5d','53','51','57','55','4b','49','4f','4d','43','41','47','45', ...
     '7b','79','7f','7d','73','71','77','75','6b','69','6f','6d','63','61','67','65', ...
     '9b','99','9f','9d','93','91','97','95','8b','89','8f','8d','83','81','87','85', ...
     'bb','b9','bf','bd','b3','b1','b7','b5','ab','a9','af','ad','a3','a1','a7','a5', ...
     'db','d9','df','dd','d3','d1','d7','d5','cb','c9','cf','cd','c3','c1','c7','c5', ...
     'fb','f9','ff','fd','f3','f1','f7','f5','eb','e9','ef','ed','e3','e1','e7','e5'];
 num = bin2dec(num2str(byte));
 new_byte = table2(2*num+1:2*num+2);
 new_byte = uint8(dec2bin(hex2dec(new_byte),8))-48;
return,

function [new_byte] = multi3(byte)
table3 = ['00','03','06','05','0c','0f','0a','09','18','1b','1e','1d','14','17','12','11', ...
     '30','33','36','35','3c','3f','3a','39','28','2b','2e','2d','24','27','22','21', ...
     '60','63','66','65','6c','6f','6a','69','78','7b','7e','7d','74','77','72','71', ...
     '50','53','56','55','5c','5f','5a','59','48','4b','4e','4d','44','47','42','41', ...
     'c0','c3','c6','c5','cc','cf','ca','c9','d8','db','de','dd','d4','d7','d2','d1', ...
     'f0','f3','f6','f5','fc','ff','fa','f9','e8','eb','ee','ed','e4','e7','e2','e1', ...
     'a0','a3','a6','a5','ac','af','aa','a9','b8','bb','be','bd','b4','b7','b2','b1', ...
     '90','93','96','95','9c','9f','9a','99','88','8b','8e','8d','84','87','82','81', ...
     '9b','98','9d','9e','97','94','91','92','83','80','85','86','8f','8c','89','8a', ...
     'ab','a8','ad','ae','a7','a4','a1','a2','b3','b0','b5','b6','bf','bc','b9','ba', ...
     'fb','f8','fd','fe','f7','f4','f1','f2','e3','e0','e5','e6','ef','ec','e9','ea', ...
     'cb','c8','cd','ce','c7','c4','c1','c2','d3','d0','d5','d6','df','dc','d9','da', ...
     '5b','58','5d','5e','57','54','51','52','43','40','45','46','4f','4c','49','4a', ...
     '6b','68','6d','6e','67','64','61','62','73','70','75','76','7f','7c','79','7a', ...
     '3b','38','3d','3e','37','34','31','32','23','20','25','26','2f','2c','29','2a', ...
     '0b','08','0d','0e','07','04','01','02','13','10','15','16','1f','1c','19','1a'];
 num = bin2dec(num2str(byte));
 new_byte = table3(2*num+1:2*num+2);
 new_byte = uint8(dec2bin(hex2dec(new_byte),8))-48;
return,
