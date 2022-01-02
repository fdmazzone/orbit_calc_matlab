function rotados=givens(pos,nro_cuerpo)
nro_cuerpos=size(pos,1);
R=   (sum(pos(nro_cuerpo,:,:).^2,2) ).^(-0.5);
R(:,2,:)=R;
rotador=pos(nro_cuerpo,1:2,:).*R;
clear R
rotador=repmat(rotador,[nro_cuerpos,1,1]);
rotados(:,1,:)=sum(pos(:,1:2,:).*rotador,2);
rotados(:,2,:)= pos(:,1,:).*(-rotador(:,2,:))+pos(:,2,:).*rotador(:,1,:);
rotados(:,3,:)=pos(:,3,:);
