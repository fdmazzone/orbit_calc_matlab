function [M,A]=matriz_colocacion(q)

i=1:q-1;
j=1:q-1;
j=[j,j(1:q-2)];
i=[i,i(2:q-1)];
s(1:q-1)=1;
s(q:2*q-3)=-1;
A=sym(sparse(i,j,s));
B=A;
for k=2:q-1
    B(k,k-1)=0;
    A=B*A;
end
j=1:q-1;
l=2:q;
for k=1:length(j)
    M(k,:)=(j(k)-1).^(l-2);
end
% M=sym(M);
M=A*M;
M=inv(M);
Matriz_iteracion=sparse(double(M));
Matriz_diferencias=sparse(double(A));
save('matrices.mat','Matriz_iteracion','Matriz_diferencias');