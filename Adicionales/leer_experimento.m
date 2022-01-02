function [tiempo,e_cuerpo,a_cuerpo,w_cuerpo,incli_cuerpo,node_cuerpo]=leer_experimento(nro_cuerpo,IndicesLeer)
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
II=1:1:10000;


for IndBloque=1:length(IndicesLeer)
    NombreBloque=num2str(IndicesLeer(IndBloque));
    Falta0=5-length(NombreBloque);
    NombreBloque=[repmat('0',[1,Falta0]),NombreBloque,'.mat'];
    if exist(NombreBloque,'file')
        load(NombreBloque);
        tiempo=[tiempo;mean(epocas(II))];
        Cuerpo=squeeze(PosHelio(nro_cuerpo,:,II));
        VCuerpo=squeeze(VelHelio(nro_cuerpo,:,II));
        [a, e, incli, node, peri]=vector2kepler([Cuerpo',VCuerpo'],GM);
%         e_cuerpo=[e_cuerpo;e];
%         a_cuerpo=[a_cuerpo;a];
%         w_cuerpo=[w_cuerpo;peri];
%         incli_cuerpo=[incli_cuerpo;incli];
%         node_cuerpo=[node_cuerpo;node];
%         M_cuerpo=[M_cuerpo;M];
%         n_cuerpo=[n_cuerpo;n];
        %%%%%promedios
        e_cuerpo=[e_cuerpo;mean(e)];
        a_cuerpo=[a_cuerpo;mean(a)];
        w_cuerpo=[w_cuerpo;mean(peri)];
        incli_cuerpo=[incli_cuerpo;mean(incli)];
        node_cuerpo=[node_cuerpo;mean(node)];
    end
  %PosSis=[PosSis;pos];
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