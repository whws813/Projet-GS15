function checkSignature
message = lecture_texte_entre;
signature = lecture_signature_entre;
Hm = SHA256(message);
[n,e] = lecture_cle;
disp('Verification en cours...');
ok = 1;
for i = 1:size(signature,1)
    s = GMPintModPower(signature(i,:),e,n);
    s = uint8(dec2bin(bin2dec(num2str(char(s))),8)) - 48;
    hm = uint8(Hm(1,8*i-7:8*i));
    if ( s ~= hm)
        ok = 0;
        break
    end
end

if ok
    disp('Signature valide!');
else
    disp('Signature non valide!');
end
return

%%%%% Fonction de lecture de la signature %%%%%%%%%%%%%%%
function [ texte ] = lecture_signature_entre
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

string = input('Entrez le nom de fichier contenant la signature\n', 's');
if exist(string)~=2
	error('Le fichier demande est introuvable');
end

fid = fopen(string);
signature = fread(fid);
fclose(fid);
for i=1:8:size(signature,1)
    s = signature(i:i+7);
    texte((i+7)/8,:) = hex2dec(char(s'));
end
return,

%%%%% Fonction de lecture du texte %%%%%%%%%%%%%%%
function [ texte_clair ] = lecture_texte_entre
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

string = input('Entrez le nom de fichier contenant le message\n', 's');
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