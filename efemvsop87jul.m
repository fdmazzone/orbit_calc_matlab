%X Y Z = heliocentric ecliptic coordinates 
%% T = time in julian days
%% cuerpo= body ear=earth, mar=mars, etc.  emb=earth-moon barycenter
function pos=efemvsop87jul(T,cuerpo)
T=(T-2451545)/365250;
load(['VSOP87',cuerpo,'.mat'], 'TX','TY','TZ')
[alpha,T1]=meshgrid(TX(:,4),T);
Talpha=T1.^alpha;
X=(sum(Talpha'.*((diag(TX(:,1))*cos(TX(:,2)*ones(1,length(T))+TX(:,3)*T'))),1))';
[alpha,T1]=meshgrid(TY(:,4),T);
Talpha=T1.^alpha;
Y=(sum(Talpha'.*((diag(TY(:,1))*cos(TY(:,2)*ones(1,length(T))+TY(:,3)*T'))),1))';
[alpha,T1]=meshgrid(TZ(:,4),T);
Talpha=T1.^alpha;
Z=(sum(Talpha'.*((diag(TZ(:,1))*cos(TZ(:,2)*ones(1,length(T))+TZ(:,3)*T'))),1))';
pos=[X Y Z];