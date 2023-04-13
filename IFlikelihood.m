%% Author: Sandeep Katragadda
% Date: 30 Nov 2016
% Go through ReadMe.doc and License.doc files before using the software.
%
% Requested citation acknowledgement when using this software:
% Sandeep Katragadda and Andrea Cavallaro, “A batch asynchronous tracker for wireless smart-camera networks”, Proceedings of the 14th IEEE International Conference on Advanced Video and Signal based Surveillance (AVSS), Lecce, Italy, 29 August - 1 September, 2017.
%
% This matlab function computes the likelihood using the Information Filter
%% =======================================================================

function [u,U] = IFlikelihood(z,H,Rinv)
    u = H' * Rinv * z;
    U = H' * Rinv * H;
end