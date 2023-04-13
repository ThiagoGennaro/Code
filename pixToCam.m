function Xcam = pixToCam( p, intrinsec)
        
%coordenadas distocidas [mm]
Xd = ((p(:,1) - intrinsec.cx).* intrinsec.dx) ./ intrinsec.sx;
Yd = (p(:,2) - intrinsec.cy).* intrinsec.dy;

%coordenadas sem distocao [mm]
r = sqrt(Xd.^2 + Yd.^2);
Xu = Xd .* (1 + intrinsec.kappa1 .* (r.^2));
Yu = Yd .* (1 + intrinsec.kappa1 .* (r.^2));

%coordenadas em mm
zc = intrinsec.f;
xc = (Xu .* zc) ./ intrinsec.f;
yc = (Yu .* zc) ./ intrinsec.f;
zc_ = repmat(zc,[size(xc,1),size(xc,2)]);
Xcam = [xc yc zc_];

end
