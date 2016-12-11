function texte_hexa_ecriture(texte_hexa, B, path);
%%%%% Fonction d'ecriture du texte (par bloc de 2 octets, 16 bits) %%%%%%%%%%%%%%%
% Cette fonction a pour but "d ecrire" dans un fichier une suite de nombres réels.
% Attention, dans votre algorithme vous pouvez avoir des données (chiffrées) de plus de 16 bits, il faut donc préciser le nombre B de bits à utiliser 
% Entrées : 
% texte_hexa (double) : données sous forme d'entiers (double) représentant le texte à écrire
% B (double) entier : nombre de bits de chaque bloc à écrire
% si ces variables ne sont pas fournies en entrée, le code demande de renseigner les variables.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

texte_bin = dec2bin(texte_hexa, B);
texte_bin = texte_bin';
texte_bin = texte_bin(:);

% Il faut s'assurer que les données contiennent un nombre de bits multiple de 8 pour l'écriture sous forme d'octets avec Matlab
texte_bin(end:end+8-mod(numel(texte_bin),8)) = texte_bin(end-(8-mod(numel(texte_bin),8)):end);
texte_bin = reshape(texte_bin, 8 , [])';

texte_bin_char = char(bin2dec(num2str(uint8(texte_bin)-48)))';
fid = fopen(path, 'w');
fwrite(fid,texte_bin_char);

return,