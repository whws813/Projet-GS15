function main
% Fonction permettant a utilisateur de choisir une fonction de chiffrement

% fonction choisi
algo = 0;

%choix possibles
choix = [1,2,3,4,5];

while ismember(algo,choix) == 0
    prompt = ['Selectionner votre fonction de chiffrement\n'...
    '->1<- Chiffrement symetrique VCES\n'...
    '->2<- Dechiffrement symetrique VCES\n' ...
    '->3<- Chiffrement RSA avec module multiple\n'...
    '->4<- Dechiffrement RSA avec module multiple\n'...
    '->5<- Signature RSA\n'...
    '->6<- Verifier une signature RSA\n'];
    algo = input(prompt);
end

if algo == 1
    VCES_chiffrement;
elseif algo == 2
    VCES_dechiffrement;
elseif algo == 3
    RSA_chiffrement;
elseif algo == 4
    RSA_dechiffrement;
end
