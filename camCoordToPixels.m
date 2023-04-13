function pixels = camCoordToPixels(Xcc, intrinsec)


Xu = intrinsec.f*(Xcc(1)/Xcc(3));
Yu = intrinsec.f*(Xcc(2)/Xcc(3));

r = sqrt(Xu^2+Yu^2);

Xd = Xu*(1 + intrinsec.kappa1*(r^2));
Yd = Yu*(1 + intrinsec.kappa1*(r^2));

Xf = ((intrinsec.sx*Xd)/intrinsec.dx) + intrinsec.cx;
Yf = (Yd/intrinsec.dy) + intrinsec.cy;

pixels = [Xf;Yf];
 

