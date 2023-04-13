%% Author: Sandeep Katragadda
% Date: 30 Nov 2016
% Go through ReadMe.doc and License.doc files before using the software.
%
% Requested citation acknowledgement when using this software:
% Sandeep Katragadda and Andrea Cavallaro, “A batch asynchronous tracker for wireless smart-camera networks”, Proceedings of the 14th IEEE International Conference on Advanced Video and Signal based Surveillance (AVSS), Lecce, Italy, 29 August - 1 September, 2017.
%
% This matlab function computes the likelihood using the Information Filter
%% =======================================================================
function [y2,Y2] = IFpredict(y1,Y1,t1,t2,F,Q)

Y2 = inv(F(t1,t2)*pinv(Y1)*F(t1,t2)' + Q(t1,t2));
y2 = Y2*F(t1,t2)*(Y1\y1);


end