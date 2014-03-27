%% Esta función calcula el tiempo en días julianos para una determinada
%% fecha. Es valida a partir del cambio al calendario gregoriano, que fue
%% hace mucho. Igual esto no importa mucho. 
%%  El tiempo es medido en tiempo universal. D es medido en días, con decimales si es necesario. M es el número del
%%  mes y A el año. Así el 23 de febrero de 1997 alas 12hs correspondería a
%%  D=23.5,   M=2, A=1997.
%% El resultadeo es JD indicando el tiempo en días julianos. 
%% la función floor() redondea números, así floor(7.5)=7. 

function JD=gre2jul(D,M,A)

I=find(M<3);
    A(I)=A(I)-1;
    M(I)=M(I)+12;

C=floor(A/100);

B=2-C+floor(C/4);

JD=floor(365.25*(A+4716))+floor(30.6001*(M+1))+D-1524.5+B;
return