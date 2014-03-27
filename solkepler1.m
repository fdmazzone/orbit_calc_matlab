%%Resuelve la ecuación de kepler E=M-e*sen(E)
function E=solkepler1(M,e,tol)
e0=e*180/pi;
% E=fsolve(@(E)M+e0*sind(E)-E,M);
delta=tol+1;
filtro=1:1:length(M);
E=M;

cantidad_inicial=length(M);

while delta>tol 
    E1=M(filtro)+e0(filtro).*sind(E(filtro));
    Error=abs(E(filtro)-E1);
    delta=max(Error);
    E(filtro)=E1;
    filtro_filtro=find(Error>tol);
    filtro=filtro(filtro_filtro);
end

