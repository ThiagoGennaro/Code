% Extrinsec Parameters: 
    % Ref: Rigid Body Dynamics for Beginners - Euler angles & Quaternions
    %                           Author: Phil Kim
    % R-> Euler´s three rotation matrix:
    %
    % Cx(theta) = [ 1         0            0;
    %               0    cos(theta)   sin(theta);
    %               0    -sin(theta)  cos(theta) ];
    %
    % Cy(theta) = [ cos(theta)    0     -sin(theta);
    %                  0          1         0;
    %               sin(theta)    0     cos(theta) ];
    %
    % Cz(theta) = [ cos(theta)    sin(theta)      0;
    %               -sin(theta)   cos(theta)      0;
    %                  0              0           1 ];
    %
    % Rotation XYZ: R = Cz(theta)*Cy(theta)*Cx(theta);
    %
    % t-> Translational Matrix in World coordinates system:
    %     where t = - R'*C_tilde;
    % C_tilde is the translational position given in global system 
    % coordinates [Xw,Yw,Zw] frame
    %                                 
    % T-> Homogeneous Representation in World coordinates frame:
    %
    % T = [ R' -R'*C_tilde;
    %       0       1      ];

    % R: Rotation Matrix - XYZ rotation;
    % t (cameras in world position): Translational matrix t = - R'*C_tilde.
    
function extrinsec = camExtrinsecParam(camera)


% Extrinsec Parameters: rx,ry and rz [rad]
%                       tx,ty and tz [mm]
switch camera
    
    case 1 %Camera 1
        tx =     8.2873214225e+02;
        ty =    -3.1754796051e+03;
        tz =     3.5469298547e+04;
        rx =     2.0405458695e+00;
        ry =    -8.9337703748e-01;
        rz =    -4.3056124791e-01;
                
    case 2 %Camera 2
        tx =     7.4969800372e+03;
        ty =    -1.9402122072e+03;
        tz =     2.3838027680e+04;
        rx =     1.8665618542e+00;
        ry =     1.5219705811e-01;
        rz =     4.5968889283e-02;

    case 3 %Camera 3
        tx =      2.5602150080e+03;
        ty =     -1.4836633370e+03;
        tz =      5.1063732312e+04;
        rx =      1.7637554450e+00;
        ry =     -6.8268312644e-01;
        rz =     -6.3321351894e-02;

    case 4 %Camera 4
        tx =     -2.9524368798e+03;
        ty =      1.4102854260e+03;
        tz =      8.0157550249e+04;
        rx =     -1.6296461530e+00;
        ry =      3.6853070326e-01;
        rz =      3.1252104484e+00;
             
    case 5 %Camera 5
        tx =    -7.6101258932e+03;
        ty =    -9.8639923333e+02;
        tz =     1.2748530990e+04;
        rx =    -2.1094320856e+00;
        ry =    -1.0807782908e+00;
        rz =    -2.6584356063e+00;
        
    case 6 %Camera 6
        tx =    -9.4185059582e+03;
        ty =    -6.8342071459e+02;
        tz =     1.8334013493e+04;
        rx =     2.2181263060e+00;
        ry =    -1.3115850224e+00;
        rz =    -6.2222518243e-01; 
    
    case 7 %Camera 7
        tx =      8.6041235949e+03;
        ty =     -4.4715843627e+02;
        tz =      1.4593893245e+04;
        rx =      1.7745394894e+00;
        ry =      3.6370404431e-01;
        rz =      9.2805843657e-02;
              
    case 8 %Camera 8
        tx =     3.2069863258e+03;
        ty =     2.3119343215e+03;
        tz =    -2.8740583612e+02;
        rx =    -2.5947507242e+00;
        ry =     1.1385785426e+00;
        rz =     2.2484536187e+00;
end       

%(Tait-Bryan angles) XYZ rotational sequence [rad]
r11 = cos(ry)*cos(rz);
r12 = sin(rx)*sin(ry)*cos(rz) - cos(rx)*sin(rz);
r13 = sin(rx)*sin(rz) + cos(rx)*sin(ry)*cos(rz);
r21 = cos(ry)*sin(rz);
r22 = sin(rx)*sin(ry)*sin(rz) + cos(rx)*cos(rz);
r23 = cos(rx)*sin(ry)*sin(rz) - sin(rx)*cos(rz);
r31 = -sin(ry);
r32 = sin(rx)*cos(ry);
r33 = cos(rx)*cos(ry);

% rotation matrix
extrinsec.R = [ r11 r12 r13
                r21 r22 r23
                r31 r32 r33 ];

% Translational Matrix in camera coordinates
extrinsec.C_t = [ tx;ty;tz ].*(1e-3); %[m]

% World Position of a camera [m]
extrinsec.t = - extrinsec.R' * extrinsec.C_t;

% Homogeneous Representation
extrinsec.T = [extrinsec.R' extrinsec.t;zeros(1,3) 1];
