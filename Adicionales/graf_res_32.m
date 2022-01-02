colores=rand(975,3);
figure;
hold on;
warning off
for j=12:1:34
   disp(j);
  [tiempo,e,a,peri,incli,node,M,n]=leer_experimento(j);
  plot(a.^1.5,'.','Color',colores(j,:),'Line','-')
end