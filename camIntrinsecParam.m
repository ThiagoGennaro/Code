%% Intrinsec Parameters

% Cx,Cy: coordinates of center of radial lens distortion and the piercing 
% point of the camera coordinate frame´s Z axis with the camera's sensor plane;

% dx: X dimension of camera´s sensor element (in mm/sel);

% dy: Y dimension of camera´s sensor element (in mm/sel);

% dpx: effective X dimension of pixel in frame grabber (in mm/pixel);

% dpy: effective Y dimension of pixel in frame grabber (in mm/pixel);

% Ncx: number of sensor elements in camera´s x direction (in sels);

% Nfx: number of pixels in frame grabber´s x direction (in pixels);

% f: effective focal length of the pin-hole camera;

% sx: scale factor to account for any uncertaninty in the framegrabber's
% resampling of the horizontal scanline; and

% k: 1st order radial lens distortion coefficient. 

%%
function intrinsec = camIntrinsecParam(camera)

switch camera
    
    case 1 %Camera 1
        intrinsec.ncx    = 7.9500000000e+02;
        intrinsec.nfx    = 7.5200000000e+02;
        intrinsec.dx     = 4.8500000000e-03;
        intrinsec.dy     = 4.6500000000e-03;
        intrinsec.dpx    = 5.1273271277e-03;
        intrinsec.dpy    = 4.6500000000e-03;
        intrinsec.f      = 5.5549183034e+00;
        intrinsec.kappa1 = 5.1113043639e-03;
        intrinsec.cx     = 3.2422149053e+02;
        intrinsec.cy     = 2.8256650051e+02;
        intrinsec.sx     = 1.0937855397e+00;
                          
    case 2 %Camera 2
        intrinsec.ncx    = 7.9500000000e+02;
        intrinsec.nfx    = 7.5200000000e+02;
        intrinsec.dx     = 4.8500000000e-03;
        intrinsec.dy     = 4.6500000000e-03;
        intrinsec.dpx    = 5.1273271277e-03;
        intrinsec.dpy    = 4.6500000000e-03;
        intrinsec.f      = 3.1316979686e+00;
        intrinsec.kappa1 = 3.7880262468e-02;
        intrinsec.cx     = 3.6105480377e+02;
        intrinsec.cy     = 3.0732879992e+02;
        intrinsec.sx     = 1.0894268482e+00;
    
    case 3 %Camera 3
        intrinsec.ncx    = 7.9500000000e+02;
        intrinsec.nfx    = 7.5200000000e+02;
        intrinsec.dx     = 4.8500000000e-03;
        intrinsec.dy     = 4.6500000000e-03;
        intrinsec.dpx    = 5.1273271277e-03;
        intrinsec.dpy    = 4.6500000000e-03;
        intrinsec.f      = 6.8289664701e+00;
        intrinsec.kappa1 = -1.2058925618e-02;
        intrinsec.cx     = 3.7284162282e+02;
        intrinsec.cy     = 3.1659953686e+02;
        intrinsec.sx     = 1.0749039449e+00;
        
    case 4 %Camera 4
        intrinsec.ncx    = 7.9500000000e+02;
        intrinsec.nfx    = 7.5200000000e+02;
        intrinsec.dx     = 4.8500000000e-03;
        intrinsec.dy     = 4.6500000000e-03;
        intrinsec.dpx    = 5.1273271277e-03;
        intrinsec.dpy    = 4.6500000000e-03;
        intrinsec.f      = 1.8579748488e+01;
        intrinsec.kappa1 = -1.0419523154e-04;
        intrinsec.cx     = 3.5192780774e+02;
        intrinsec.cy     = 2.8796348569e+02;
        intrinsec.sx     = 1.0804745826e+00;
        
    case 5 % Camera 5
        intrinsec.ncx    = 1.6000000000e+03;
        intrinsec.nfx    = 1.6000000000e+03;
        intrinsec.dx     = 4.6500000000e-03;
        intrinsec.dy     = 4.6500000000e-03;
        intrinsec.dpx    = 4.6500000000e-03;
        intrinsec.dpy    = 4.6500000000e-03;
        intrinsec.f      = 3.8593934840e+00;
        intrinsec.kappa1 = 2.2757857614e-02;
        intrinsec.cx     = 2.4853856155e+02;
        intrinsec.cy     = 3.3791011750e+02;
        intrinsec.sx     = 1.0000000000e+00;                  
    
    case 6 % Camera 6
        intrinsec.ncx    = 1.6000000000e+03;
        intrinsec.nfx    = 1.6000000000e+03;
        intrinsec.dx     = 4.6500000000e-03;
        intrinsec.dy     = 4.6500000000e-03;
        intrinsec.dpx    = 4.6500000000e-03;
        intrinsec.dpy    = 4.6500000000e-03;
        intrinsec.f      = 4.0766744114e+00;
        intrinsec.kappa1 = 1.8390355585e-02;
        intrinsec.cx     = 5.4778587794e+02;
        intrinsec.cy     = 2.0025964732e+02;
        intrinsec.sx     = 1.0000000000e+00;
    
    case 7 % Camera 7
        intrinsec.ncx    = 1.6000000000e+03;
        intrinsec.nfx    = 1.6000000000e+03;
        intrinsec.dx     = 4.6500000000e-03;
        intrinsec.dy     = 4.6500000000e-03;
        intrinsec.dpx    = 4.6500000000e-03;
        intrinsec.dpy    = 4.6500000000e-03;
        intrinsec.f      = 3.6936729025e+00;
        intrinsec.kappa1 = 6.1986350417e-02;
        intrinsec.cx     = 4.3610005997e+02;
        intrinsec.cy     = 2.5792023557e+02;
        intrinsec.sx     = 1.0000000000e+00;
    
    case 8 % Camera 8
        intrinsec.ncx    = 1.6000000000e+03;
        intrinsec.nfx    = 1.6000000000e+03;
        intrinsec.dx     = 4.6500000000e-03;
        intrinsec.dy     = 4.6500000000e-03;
        intrinsec.dpx    = 4.6500000000e-03;
        intrinsec.dpy    = 4.6500000000e-03;
        intrinsec.f      = 3.4345527587e+00;
        intrinsec.kappa1 = 3.2678605363e-02;
        intrinsec.cx     = 5.9220854519e+02;
        intrinsec.cy     = 3.9728183795e+02;
        intrinsec.sx     = 1.0000000000e+00;
        
end

% Mapping 3D point in a CCD camera coordinates system to image pixels 
% frame:
% [px, py, 1] = [f/dpx 0 cx, 0 f/dpy cy, 0 0 1]*[Xc, Yc, Zc] 
intrinsec.K = [  intrinsec.f/intrinsec.dpx  0                          intrinsec.cx;
                 0                          intrinsec.f/intrinsec.dpy  intrinsec.cy;
                 0                          0                                     1 ];

