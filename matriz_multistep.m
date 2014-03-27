function matriz_multistep(q,opcion)

if opcion=='implicito'
    m=2;
elseif opcion=='explicito'
    m=1;
else
    disp('Argumento desconocido');
    return
end
    
i=1:q-1;
j=1:q-1;
j=[j,j(1:q-2)];
i=[i,i(2:q-1)];
s(1)=1;
s(2:q-1)=-1;
s(q:2*q-3)=1;
A=sym(sparse(i,j,s));
B=A;
for k=2:q-1
    B(k,k-1)=0;
    B(k,k)=1;
    A=B*A;
end

j=1:q-1;
l=2:q;
for j=1:q-1
    M(j,:)=(m-j).^(l-2);
end
% M=sym(M);
M=A*M;
M=inv(M);
Matriz_iteracion_multistep=double(M);
Matriz_diferencias_backward=double(A);
save(['matrices_multistep_',opcion,'.mat'],'Matriz_iteracion_multistep','Matriz_diferencias_backward');