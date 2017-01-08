function [message_hache] = SHA256(message)
message = uint8(reshape(dec2bin(message,8)',[],1)')-48;
Kcon = ['428a2f98', '71374491', 'b5c0fbcf', 'e9b5dba5', '3956c25b', '59f111f1', '923f82a4', 'ab1c5ed5',...
'd807aa98', '12835b01', '243185be', '550c7dc3', '72be5d74', '80deb1fe', '9bdc06a7', 'c19bf174',...
'e49b69c1', 'efbe4786', '0fc19dc6', '240ca1cc', '2de92c6f', '4a7484aa', '5cb0a9dc', '76f988da',...
'983e5152', 'a831c66d', 'b00327c8', 'bf597fc7', 'c6e00bf3', 'd5a79147', '06ca6351', '14292967',...
'27b70a85', '2e1b2138', '4d2c6dfc', '53380d13', '650a7354', '766a0abb', '81c2c92e', '92722c85',...
'a2bfe8a1', 'a81a664b', 'c24b8b70', 'c76c51a3', 'd192e819', 'd6990624', 'f40e3585', '106aa070',...
'19a4c116', '1e376c08', '2748774c', '34b0bcb5', '391c0cb3', '4ed8aa4a', '5b9cca4f', '682e6ff3',...
'748f82ee', '78a5636f', '84c87814', '8cc70208', '90befffa', 'a4506ceb', 'bef9a3f7', 'c67178f2'];

%initialisation des huits variables (hash)
H1 = '6a09e667';
H2 = 'bb67ae85';
H3 = '3c6ef372';
H4 = 'a54ff53a';
H5 = '510e527f';
H6 = '9b05688c';
H7 = '1f83d9ab';
H8 = '5be0cd19';
H1 = uint8(dec2bin(hex2dec(H1),32))-48;
H2 = uint8(dec2bin(hex2dec(H2),32))-48;
H3 = uint8(dec2bin(hex2dec(H3),32))-48;
H4 = uint8(dec2bin(hex2dec(H4),32))-48;
H5 = uint8(dec2bin(hex2dec(H5),32))-48;
H6 = uint8(dec2bin(hex2dec(H6),32))-48;
H7 = uint8(dec2bin(hex2dec(H7),32))-48;
H8 = uint8(dec2bin(hex2dec(H8),32))-48;
%completer le message
l = size(message,2);
message(1,end+1) = 1; 
while mod(size(message,2),512) ~= 448
    message(1,end+1) = 0;        
end 
%completer le longeur a 512*kbits
if l<=512
    message(1,end+1:end+64) = 1;
else
    message(1,end+1:end+512) = 0;
    message(1,end+1:end+64) = 1;    
end
%Le message compl¨¦t¨¦ est d¨¦coup¨¦ en 16k mots de 32 bits
message = reshape(message',32,[])';
line_message = size(message,1);
count = 1;
%calcul du hache
for i=1:16:line_message
    %remplir le tableau Wt
    Wt(1:16,:) = message(i:i+15,:);
    for t=17:64
        Wt(t,:) = xor(xor(xor(Transformer1(Wt(t-2,:)),Wt(t-7,:)),Transformer0(Wt(t-15,:))),Wt(t-16,:));
    end
    %initialise a,b,c,d,e,f,g,h
    a= H1;
    b= H2;
    c= H3;
    d= H4;
    e= H5;
    f= H6;
    g= H7;
    h= H8;
    %tournee de transformation
    for t=1:64
        T1 = xor(xor(xor(xor(h,Addition1(e)),Change(e,f,g)),uint8(dec2bin(hex2dec(Kcon(8*t-7:8*t)),32))-48),Wt(t,:));
        T2 = xor(Addition0(a),Maj(a,b,c));
        h=g;
        g=f;
        f=e;
        e=xor(d,T1);
        d=c;
        c=b;
        b=a;
        a=xor(T1,T2);
    end
    %Calcul des valeurs de hachage interm¨¦diaires
    H1 =  xor(a,H1);
    H2 =  xor(b,H2);
    H3 =  xor(c,H3);
    H4 =  xor(d,H4);
    H5 =  xor(e,H5);
    H6 =  xor(f,H6);
    H7 =  xor(g,H7);
    H8 =  xor(h,H8);
    message_hache(count,1:256) = [H1 H2 H3 H4 H5 H6 H7 H8];
    count = count + 1;
end
return,

%definition des fonctions utilisees dans le calcul
function [Wt_temp] = Transformer1(Wt_temp)
    Wt_temp = xor(xor(ROTR(Wt_temp,17),ROTR(Wt_temp,19)),SHR(Wt_temp,10));
return,

function [Wt_temp] = Transformer0(Wt_temp)
    Wt_temp = xor(xor(ROTR(Wt_temp,7),ROTR(Wt_temp,18)),SHR(Wt_temp,3));
return,

function [e] = Addition1(e)
    e = xor(xor(ROTR(e,6),ROTR(e,11)),ROTR(e,25));
return,

function [a] = Addition0(a)
    a = xor(xor(ROTR(a,2),ROTR(a,13)),ROTR(a,22));
return,

function [variable_change] = Change(e,f,g)
    ef = e & f;
    eg = (~e) & g;
    variable_change = xor(ef,eg);
return,

function [variable_change] = Maj(a,b,c)
    ab = a & b;
    ac = a & c;
    bc = b & c;
    variable_change = xor(xor(ab,ac),bc);
return,


function [Wt_temp] = ROTR(Wt_temp,n)
  if n~=32 && n~=0
    Wt_temp_1(1,1:n) = 0;
    for round=n+1:32
        Wt_temp_1(1,round) = Wt_temp(1,round-1);
    end
    Wt_temp_2(1,n+1:32) = 0;
    for round=1:n
        Wt_temp_2(1,round) = Wt_temp(1,round+32-n);
    end
  else
      Wt_temp_1(1,1:32) = 0;
      Wt_temp_2(1,1:32) = Wt_temp(1,:);
  end
  %Wt_temp_1 = uint8(Wt_temp_1)-48;
  %Wt_temp_2 = uint8(Wt_temp_2)-48;
  Wt_temp = Wt_temp_1 | Wt_temp_2;
return,

function [Wt_temp] = SHR(Wt_temp,n)
  if n~=32 && n~=0
    Wt_temp_1(1,1:n) = 0;
    for round=n+1:32
        Wt_temp_1(1,round) = Wt_temp(1,round-1);
    end
  elseif n==32
      Wt_temp_1(1,1:32) = 0;
  else 
      Wt_temp_1(1,1:32) = Wt_temp(1,:);
  end
  Wt_temp(1,:) = Wt_temp_1(1,:);
return,
