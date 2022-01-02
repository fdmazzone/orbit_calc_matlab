%Convierte coordenadas eclìpticas a ecuatoriales
%pos_eclip puede ser un arreglo tridimensional la primera dimension 
%son los cuerpos la segunda las coordenadas y la tercera las epocas.
%Retorna la misma estructura convertida

function [pos_ecua]=ecli2ecua(pos_eclip)

[i j k]=size(pos_eclip);
pos_eclip=permute(pos_eclip,[2,1,3]);
  
  A= [1.00000000128145 -2.16882289677805e-010  6.95395237154022e-009;
    2.44260791168993e-006  0.917481648663067 -0.397763900774267;
    6.33164190952311e-007  0.397777048770251  0.91748549802439];

pos_ecua=A*pos_eclip(:,:);
pos_ecua=permute(reshape(pos_ecua,[3,i,k]),[2,1,3]);






% 
% function [X Y Z]=ecli2ecua(X1,Y1,Z1)
% 
%   
%   X= 1.00000000128145*X1-2.16882289677805e-010 *Y1+6.95395237154022e-009*Z1;
%  Y=2.44260791168993e-006*X1+ 0.917481648663067 *Y1-0.397763900774267*Z1;
%  Z=6.33164190952311e-007*X1+0.397777048770251*Y1+0.91748549802439*Z1;

  
  
%    A=[         1.00000000128145    -2.16882289677805e-010     6.95395237154022e-009;
%      2.44260791168993e-006         0.917481648663067        -0.397763900774267;
%      6.33164190952311e-007         0.397777048770251          0.91748549802439];
%  
%   R=A*[X1;Y1;Z1];
%   X=R(1);
%   Y=R(2);
%   Z=R(3);
%   
  
  

% X= 1.000000000000*X1+0.000000440360*Y1-0.000000190919*Z1;
% Y=-0.000000479966*X1+0.917482137087*Y1-0.397776982902*Z1;
% Z=                  +0.397776982902*Y1+0.917482137087*Z1;
