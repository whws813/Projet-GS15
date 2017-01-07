function [ res_prime ] = test_primality( GMPint1 , nb_iter )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin<1
	error('vous devez entrer au moins 1 augument (l entier long dont on veut tester la primalité')
end
if nargin==1
	nb_iter=40;
end
if ~isa(GMPint1,'GMPint')
	GMPint1 = GMPint( num2str(GMPint1) );
end

liste_premiers = [2 3 5 7 11 13 17 19];
for nb_div = 1:numel(liste_premiers)
    if GMPint1 == liste_premiers(nb_div)
        res_prime = 1;
        return
    end
    [~,r] = GMPint1/liste_premiers(nb_div);
    if (r==0)
        %fprintf('votre nombre est divisible par %d \n' , liste_premiers(nb_div) );
        res_prime=0;
        return
    end,
end,

%décomposition de GMPint1 
GMPint1m1 = GMPint1 - 1;
%décomposition en binaire de a pour compter le nombre de zéros ? la fin ...
c = char(GMPint1m1);
s = numel(c)-find(c, 1, 'last');
d = GMPint1m1/2^s;

% %alternative possible 
% s=0; impair=0; d_new = GMPint1m1;
% while impair==0
%   d_old = d_new;
%   [d_new,impair] = d_new/2;
%   s=s+1;
% end
% d = d_old;
% s=s-1;
res_prime=1;

for k=1:nb_iter
    [ ~ , a ] = GMPrand(numel(c)) / GMPint1;
    x=GMPintModPower(a,d,GMPint1);
    if ( x == 0) || ( x == 1) || ( x == GMPint1m1)
        continue;
    end
    
    r = 1;
    fin=0;
    while fin==0
        [ ~ , x ] = ( x * x ) / GMPint1;
        if ( x == GMPint1m1)
            fin=1;
        end
        if r==s
            res_prime=0;
            fin=1;
        end,
        r=r+1;
    end,
    if res_prime==0
        break;
    end,
end,
return