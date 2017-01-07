function [ GMPint_res ] = GMPintModPower( GMPint1 , GMPint2 , GMPint3 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if ~isa(GMPint1,'GMPint')
	GMPint1 = GMPint( num2str(GMPint1) );
end
if ~isa(GMPint2,'GMPint')
	GMPint2 = GMPint( num2str(GMPint2) );
end
if ~isa(GMPint3,'GMPint')
	GMPint3 = GMPint( num2str(GMPint3) );
end


GMPint_res = GMPint('1');

while GMPint2 > 0
    [ GMPint2 , r ] = GMPint2 / 2;
    if (r==1)
        GMPint_res = GMPint_res * GMPint1;
    end,
    
    [ ~ , GMPint1 ] = ( GMPint1 * GMPint1 ) / GMPint3;
end


[ ~ , GMPint_res ] = GMPint_res / GMPint3;
