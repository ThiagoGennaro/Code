function [P,Q,d] = reversalLOSAndDistanceMinimization(P1,v1,P2,v2)
 
num1 = ((norm(v2))^2)*(dot((P1-P2),v1)) + (dot(v1,v2))*(dot((P2-P1),v2));
den1 = (dot(v1,v2))^2 - ((norm(v1))^2)*((norm(v2))^2);
lambda = num1/den1;

num2 = dot((P1-P2),v2) + lambda*(dot(v1,v2));
den2 = norm(v2)^2;
beta = num2/den2;

P = P1 + lambda.*v1;

Q = P2 + beta.*v2;

d = sqrt( (P(1)-Q(1))^2 + (P(2)-Q(2))^2 + (P(3)-Q(3))^2 );

end