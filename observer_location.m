%%Quantities p*cos(phi); p*sin(phi) needed for paralax correction
function [pcosphi,psinphi]=observer_location(Lat,h)
a=6378.14;
f=1/(298.257);
b=a*(1-f);
u=atand((b/a)*tand(Lat));
psinphi=a^(-1)*b*sind(u)+h*(6378140)^(-1)*sind(Lat);
pcosphi=cosd(u)+h*(6378140)^(-1)*cosd(Lat);
