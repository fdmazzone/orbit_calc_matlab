function [AR, DE]=correcparal(ARg,DEg,delta,JD,long,pcosphi,psenphi)
cantidad_cuerpos=size(ARg,1);
[i,j]=size(JD);
if i>j
   JD=JD';
end
%%JD tiempo debe entrarse en fila
ARg=ARg*15;
sinpi=sind(2.442777777777778e-003)./delta;
H=repmat(reshape(lst(JD,long),[1,1,length(JD)]),[cantidad_cuerpos,1,1])-ARg;

tandeltaal=-pcosphi*sinpi.*sind(H)./(cosd(DEg)-pcosphi*sinpi.*cosd(H));
deltaal=atand(tandeltaal);
AR=(ARg+deltaal)/15;

tanDE=(sind(DEg)-psenphi*sinpi).*cosd(deltaal)./(cosd(DEg)-pcosphi*sinpi.*cosd(H));
DE=atand(tanDE);