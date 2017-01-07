function display(GMPint)

fprintf('valeur binaire : \n');
if ( GMPint.signe == -1 )
	fprintf('-');
end

liste_bits = char(GMPint);
for k=1:numel(liste_bits),
	fprintf('%d', liste_bits(k));
end
fprintf('\n');

fprintf('valeur decimale : \n');
if ( GMPint.signe == -1 )
	fprintf('-');
end

for k=1:numel(GMPint.liste_chiffres),
	fprintf('%d', GMPint.liste_chiffres(k));
end


fprintf('\n')