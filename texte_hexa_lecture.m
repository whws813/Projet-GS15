function [ texte_clair_hexa ] = texte_hexa_lecture(path,B);
%%%%% Fonction de lecture du texte (par bloc de 2 octets, 16 bits) %%%%%%%%%%%%%%%
% Cette fonction a pour but de "lire" un texte sous Matlab et de retourner le résultat sous la forme de nombres (réels).
% La lecture se fait par bloc de B bits (B=16 pour le fichier à chiffrer)  afin d'agrandir l'espace de travail (clés, etc ...)
% Entrées : 
% path (char) : chemin d'accès du fichier à lire
% B (double) entier : nombre de bits de chaque bloc à lire
% si ces variables ne sont pas fournies en entrée, le code demande de renseigner les variables.
% Sorties :
% texte_clair_hexa : fichier lu par bloc de B (B=16 pour le fichier à chiffrer) bits retourné sous forme de nombre réels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialisation
if nargin < 1,
	path = input('Entrez le nom de votre fichier\n', 's');
end

while ~isa(path, 'char') || exist(path)~=2
	warning('L entrée n est pas du type "char" ou bien le fichier n existe pas ; recommencez !')
end

if nargin < 2,
	B = input('Entrez le nombre de bits de chaque bloc\n Typiquement 16 pour la lecture du fichier a chiffrer (mais différent pour le fichier chiffré)' );
end

fid = fopen(path);
texte_clair = fread(fid);
fclose(fid);

texte_clair_bin = dec2bin(texte_clair,8);
% S'assurer que le texte contient un nombre de bits multiple de B (notamment pour le fichier à chiffrer).
texte_clair_bin = texte_clair_bin';
texte_clair_bin = texte_clair_bin(:);
% On tronque le message 
texte_clair_bin = texte_clair_bin(1:end-mod(numel(texte_clair_bin),B));

texte_clair_hexa = reshape(texte_clair_bin, B , [])';
texte_clair_hexa = bin2dec(texte_clair_hexa);
% Le résultat est retourné sous la forme d'un vecteur 'colonne' dont chaque élément est compris entre 0 et 65535.
% Bien que ces résultats pourrais être changer ("caster") en type uint16 il est important de NE PAS LE FAIRE pour pouvoir effectuer les opération suivantes !

return,
