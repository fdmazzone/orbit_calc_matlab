function [a, e, incli, node, peri, M,n]=vector2kepler3(PosHelio,VelHelio,GMS)
% [GM1]= sistema(0);
% GMS=GM1(1,1);
R=sqrt(sum(PosHelio.^2,2));
V=sqrt(sum(VelHelio.^2,2));
a=(2./R-V.^2/GMS).^(-1);
H=cross(PosHelio,VelHelio,2);
h=sqrt(sum(H.^2,2));
e=sqrt(1-h.^2./(GMS*a));
incli=acosd(H(:,3,:)./h);
%signos=sign(H(:,3));
node=atan2(H(:,1,:),-H(:,2,:));
signos=sign(node);
node=(node+0.5*(1-signos)*2*pi)*180/pi;
sinwf=PosHelio(:,3,:)./(R.*sind(incli));
coswf=(PosHelio(:,1,:)./R+sind(node).*sinwf.*cosd(incli))./cosd(node);
%I=(~(imag(sinwf)==0))+(~(imag(coswf)==0));
%sinwf(I>0)=NaN;
wmasf=atan2(sinwf,coswf);
wmasf=(wmasf+0.5*(1-sign(wmasf))*2*pi)*180/pi;
signos=sign(sum(PosHelio.*VelHelio,2));
Rdot=signos.*sqrt(V.^2-h.^2./R.^2);
sinf=real((a.*(1-e.^2).*Rdot)./(h.*e));
cosf=real((a.*(1-e.^2)./R-1)./e);
f=atan2(sinf,cosf);
f=(f+0.5*(1-sign(f))*2*pi).*180/pi;
peri=wmasf-f;
peri=squeeze(peri+0.5.*(1-sign(peri))*360);
tanE2=((1-e)./(1+e)).^0.5.*tand(f/2);
E=2*atand(tanE2);
M=E-e.*sind(E).*180/pi;
M=squeeze(M+0.5.*(1-sign(M)).*360);
n=squeeze(2*pi./a.^(3/2));
a=squeeze(a);
e=squeeze(e);
incli=squeeze(incli);
node=squeeze(node);
