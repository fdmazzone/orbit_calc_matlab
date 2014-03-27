function [AR1 DE mag1 Delta motion1 PA]=orbit_calcDEcome(epoca,tfin,estadocom, H,G)
global GMS;
GMS=sistema(0);
GMS=GMS(1);
Jini=epoca;
Jfin=tfin;
tlapso=Jfin-Jini;
k=6*(fix(abs(tlapso))+1);
h=tlapso/k;
for indi=1:1:k
    A1=fuerzaDE_2b(estadocom,GMS);
    A2=fuerzaDE_2b(estadocom+0.5*h*A1,GMS);
    A3=fuerzaDE_2b(estadocom+0.5*h*A2,GMS);
    A4=fuerzaDE_2b(estadocom+h*A3,GMS);
    estadocom=estadocom+(h/6)*(A1+2*A2+2*A3+A4);
end
min=10*0.000694444444444444;
postierra=efemvsop87jul([tfin;tfin+min],'ear');
%%===============Corrección por la velocidad de la luz===================
Delta=(postierra(1,:)-estadocom(1:3)).^2;
Delta=sqrt(sum(Delta,2));
luztiempo=-0.0057755183*Delta;
    A1=fuerzaDE_2b(estadocom,GMS);
    A2=fuerzaDE_2b(estadocom+0.5*luztiempo*A1,GMS);
    A3=fuerzaDE_2b(estadocom+0.5*luztiempo*A2,GMS);
    A4=fuerzaDE_2b(estadocom+luztiempo*A3,GMS);
    estadocom= estadocom+(luztiempo/6)*(A1+2*A2+2*A3+A4);
Delta=(postierra(1,:)-estadocom(1:3)).^2;
Delta=sqrt(sum(Delta,2));


r=sqrt(sum(estadocom(1:3).^2,2)); 

pos=ecli2ecua(estadocom(1:3));
pos_t=ecli2ecua(-postierra(1,:));

AR1=atan2(pos_t(2)+pos(2),pos_t(1)+pos(1));
DE=asind((pos_t(3)+pos(3))./Delta);

redond=floor(AR1/pi);
AR1=AR1-redond*2*pi;
AR1=12*AR1/pi;





%%%Calculo del movimiento


    A1=fuerzaDE_2b(estadocom,GMS);
    A2=fuerzaDE_2b(estadocom+0.5*min*A1,GMS);
    A3=fuerzaDE_2b(estadocom+0.5*min*A2,GMS);
    A4=fuerzaDE_2b(estadocom+min*A3,GMS);
    estadocom1min= estadocom+(min/6)*(A1+2*A2+2*A3+A4);


pos1=ecli2ecua(estadocom(1:3));
pos_t1=ecli2ecua(postierra(2,:));
Delta1=(postierra(2,:)-estadocom1min(1:3)).^2;
Delta1=sqrt(sum(Delta1,2));

AR2=atan2(pos_t1(2)+pos1(2),pos_t1(1)+pos1(1));
DE1=asind((pos_t1(3)+pos1(3))./Delta1);

redond=floor(AR2/pi);
AR2=AR2-redond*2*pi;
AR2=12*AR2/pi;



[motion1, PA]=motioncom(AR1,DE,AR2,DE1);
 motion1=motion1/10;

 R1=norm(pos_t);

mag1=H+5*log10(Delta)+2.5*G.*log10(r);
