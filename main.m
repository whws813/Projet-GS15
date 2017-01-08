function main
% Fonction permettant a utilisateur de choisir une fonction de chiffrement

% fonction choisi
algo = 0;

%choix possibles
choix = [1,2,3,4,5,6,7];

while ismember(algo,choix) == 0
    prompt = ['Selectionner votre fonction de chiffrement\n'...
    '->1<- Chiffrement symetrique VCES\n'...
    '->2<- Dechiffrement symetrique VCES\n' ...
    '->3<- Generation une cle privee et une cle public\n'...
    '->4<- Chiffrement RSA avec module multiple\n'...
    '->5<- Dechiffrement RSA avec module multiple\n'...
    '->6<- Signature RSA\n'...
    '->7<- Verifier une signature RSA\n'];
    algo = input(prompt);
end

if algo == 1
    VCES_chiffrement;
elseif algo == 2
    VCES_dechiffrement;
elseif algo == 3
    prompt = ['Veuillez saisir la taille de cle (bits)\n'];
    nb_bits = input(prompt);
    [~,~,~] = generation_cleRSA(nb_bits);
elseif algo == 4
    RSA_chiffrement;
elseif algo == 5
    RSA_dechiffrement;
elseif algo == 6
    checkSignature;
end
