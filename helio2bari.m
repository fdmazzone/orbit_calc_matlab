function [coor_bari,vel_bari]=helio2bari(coor_helio,vel_helio,pos_solar_bari,vel_solar_bari,GM1);
R=(reshape(pos_solar_bari',[3,length(GM1)-1]))';
R0=(-GM1(2:end)/GM1(1))*R;
cantidad_cuerpos=size(coor_helio,2)/3;
coor_bari=coor_helio+repmat(R0,[1,cantidad_cuerpos]);
V=reshape(vel_solar_bari,[3,length(GM1)-1])';
V0=(-GM1(2:end)/GM1(1))*V;
vel_bari=vel_helio+repmat(V0,[1,cantidad_cuerpos]);
