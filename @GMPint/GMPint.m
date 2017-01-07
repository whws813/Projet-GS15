function GMPint_res = GMPint(int_char,signe)
% Constructeur de class GMP_int
%Programmer : R�mi Cogranne
%date : 01/2016
%definir comme un GMPint

GMPint_res = [];

nb_chiffres = size(int_char);
if (nb_chiffres(1)==0 || nb_chiffres(2)==0)
    int_char='0';
end
if (nb_chiffres(1)>1)
    error('Vous devez un unique nombre')
end

if ( nargin==1 )

    if int_char(1) == '-';
        GMPint_res.signe = -1;
        int_char = int_char(2:end);
    else
        GMPint_res.signe = 1;
    end


    nb_chiffres = nb_chiffres(2);
    if ~all(ismember(int_char,'0123456789')),
        error('Vous devez un unique nombre')
    end,

    GMPint_res.liste_chiffres = double(int_char)-48;


elseif ( nargin==2 )
    
    GMPint_res.signe = signe;
    GMPint_res.liste_chiffres = int_char;
    
end,

liste_chiffres = GMPint_res.liste_chiffres;
% GMPint_res.liste_bits = zeros( 1 , ceil(numel(GMPint_res.liste_chiffres)*log2(10)) );
% indice_bits=1;
% while ~all(liste_chiffres==0),
%     GMPint_res.liste_bits(end-indice_bits+1) = mod(liste_chiffres(end) , 2 );
%     retenues = rem(liste_chiffres,2);
%     liste_chiffres = floor(liste_chiffres/2);
%     liste_chiffres(2:end)=liste_chiffres(2:end)+retenues(1:end-1)*5;
%     indice_bits = indice_bits + 1;
% end,
% 
% GMPint_res.liste_bits = GMPint_res.liste_bits( find(GMPint_res.liste_bits,1,'first') : end);

GMPint_res.liste_chiffres = GMPint_res.liste_chiffres( find(GMPint_res.liste_chiffres,1,'first') : end);

% if isempty(GMPint_res.liste_bits)
if isempty(GMPint_res.liste_chiffres)
    GMPint_res.signe = 0 ;
%     GMPint_res.liste_bits = 0 ;
    GMPint_res.liste_chiffres = 0;
end,

GMPint_res = class(GMPint_res,'GMPint');
superiorto('double','single','int8','uint8','int16', ...
  'uint16','int32','uint32','int64','uint64','logical')

