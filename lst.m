function LST=lst(JD,longitud)
if ~(longitud==0)
longitud=-longitud+floor(180/longitud)*360;
end
%JD=gre2jul(D,M,A); %% Aca invocamos el calculo de la fecha juliana. 
T=(JD-2451545)/36525;

LSTG=280.46061837+360.98564736629*(JD-2451545)+0.000387933*T.^2-(T.^3/38710000);
LST1=(LSTG-floor(LSTG/360)*360-longitud); %% %% la función floor() redondea números, así floor(7.5)=7. 
LST=LST1-floor(LST1/360)*360;