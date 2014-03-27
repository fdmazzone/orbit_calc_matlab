function [tiempo,e_cuerpo,a_cuerpo,w_cuerpo,incli_cuerpo,node_cuerpo,M_cuerpo,n_cuerpo]=leer_experimento(nro_cuerpo)
%function [PosSis,tiempo]=leer_experimento(cuerpo,ini,fin)

%function leer_experimento
tiempo=[];
e_cuerpo=[];
a_cuerpo=[];
w_cuerpo=[];
incli_cuerpo=[];
node_cuerpo=[];
M_cuerpo=[];
n_cuerpo=[];
%PosSis=[];
GM=sistema(0);
GM=GM(1,1);
%
II=1:10:500;


for IndBloque=300:437;
    NombreBloque=num2str(IndBloque);
    Falta0=5-length(NombreBloque);
    NombreBloque=[repmat('0',[1,Falta0]),NombreBloque,'.mat'];
    load(NombreBloque);
    tiempo=[tiempo;epocas(II)];
    Cuerpo=squeeze(pos_helio(nro_cuerpo,:,II));
    VCuerpo=squeeze(vel_helio(nro_cuerpo,:,II));
    [a, e, incli, node, peri, M,n]=vector2kepler([Cuerpo',VCuerpo'],GM);
   e_cuerpo=[e_cuerpo;e];
   a_cuerpo=[a_cuerpo;a];
   w_cuerpo=[w_cuerpo;peri];
   incli_cuerpo=[incli_cuerpo;incli];
   node_cuerpo=[node_cuerpo;node];
   M_cuerpo=[M_cuerpo;M];
   n_cuerpo=[n_cuerpo;n];
  %PosSis=[PosSis;pos];
   
    IndBloque=IndBloque+1;
    
    
    

end

%tiempo=(tiempo-tiempo(1))/365.25;

% PosSis=permute(reshape(PosSis',[3,5,size(PosSis,1)]),[2,1,3]);
% 
%    figure;hold on; 
%   for j=1:5  
%    if j<5
%        color='b';
%    else
%        color='r';
%    end
%    plot3(pos(:,3*j-2),pos(:,3*j-1),pos(:,3*j),'.','Color',color)
%   end
%   set(gca,'DataAspectRatio',[1,1,1]);