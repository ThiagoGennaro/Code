function Xc = worldToCamCoord( Xw, R, C_tilde)

% Xw = [Xw,Yw,Zw]
% Xc = R*Xw + C_tilde;
% C_tilde is the translational matrix given in camera coordinates frame. We
% don´t need to multiply R in translational factor on the equation bellow
% because C_tilde is in camera coordinates frame.

Xc = R*Xw + C_tilde;