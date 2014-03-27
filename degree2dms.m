%%entrega una terna de con grados minutos y segundos, el resultado es
%%siempre positivo
function dms=degree2dms(DE)
format short g
d=fix(DE); 
mant=abs(DE-d);
m=fix(mant*60);
mant=mant*60-m;
s=mant*60;
s=round(s*100)/100;
dms=[abs(d) m s];

    