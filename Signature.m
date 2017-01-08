function Signature
%%% Fonction permttant de signer une message

texte_clair = lecture_texte_entre;
Hm = SHA256(texte_clair);
[n,d] = lecture_cle;
for i = 1:8:size(Hm,2)
    m = Hm(1,i:i+7);
    m = bin2dec(num2str(uint8(m)));
    Sm = GMPintModPower(m,d,n);
    signature(1,i:i+7) = dec2hex(bin2dec(num2str(char(Sm))),8);
end

%Enregistrer la signature
fid = fopen('./signature.txt','w');
fwrite(fid,signature);
fclose(fid);
disp('La signature est enregistre dans singature.txt');
return

function [ texte_clair ] = lecture_texte_entre
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

string = input('Entrez le nom de fichier a signer\n', 's');
if exist(string)~=2
	error('Le fichier demande est introuvable');
end

fid = fopen(string);
texte_clair = fread(fid);
fclose(fid);
return,

%%%%% Fonction de lecture de la cle %%%%%%%%%%%%%%%
function [ n,d ] = lecture_cle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
choix = 0;
while (choix ~= 1) && (choix ~= 2)
    prompt = ['Veuillez choisir\n'...
    '->1<- Generer une cle privee et une cle public\n'...
    '->2<- Importer une cle privee\n'];
    choix = input(prompt);
end

if choix == 1
    prompt = ['Veuillez saisir la taille de cle (bits)\n'];
    nb_bits = input(prompt);
    [n,~,d] = generation_cleRSA(nb_bits);
else
    string = input('Entrez le nom de fichier contenant la cle privee\n', 's');
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
            d = cle (i+1:end,1);
            break
        end
    end
    n = bin2dec(num2str(n'-48));
    d = bin2dec(num2str(d'-48));
    n = GMPint(num2str(n));
    d = GMPint(num2str(d));
end
return,