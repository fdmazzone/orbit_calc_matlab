function [X, Y]=foto(AR,DE,AR0,DE0)
X=-(cosd(DE).*sind(AR-AR0))./(cosd(DE0).*cosd(DE).*cosd(AR-AR0)+sind(DE0).*sind(DE));
Y=-(sind(DE0).*cosd(DE).*cosd(AR-AR0)-cosd(DE0).*sind(DE))./(cosd(DE0).*cosd(DE).*cosd(AR-AR0)+sind(DE0).*sind(DE));