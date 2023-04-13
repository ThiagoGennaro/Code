%% Author: Sandeep Katragadda
% Date: 30 June 2017
% Go through ReadMe.doc and License.doc files before using the software.
%
% Requested citation acknowledgement when using this software:
% Sandeep Katragadda and Andrea Cavallaro, “A batch asynchronous tracker for wireless smart-camera networks”, Proceedings of the 14th IEEE International Conference on Advanced Video and Signal based Surveillance (AVSS), Lecce, Italy, 29 August - 1 September, 2017.
%
% This matlab script generates the clock ticks for capturing, processing, estimation and fusion phases of all cameras
% Timeline generation using simulated clocks
%% =======================================================================

disp('Generating timeline of local clocks...');

first_frame = 1;
last_frame = TF;
time_step = 1; %equal to 143ms

kVals = first_frame:time_step:last_frame;
Ticks_c = zeros(N,numel(kVals)); %flags indicating the capturing instants
Ticks_e = zeros(N,numel(kVals)); %flags indicating the estimation (processing) instants
Ticks_t = zeros(N,numel(kVals)); %flags indicating the transmission instants for the proposed methods (BAF-1, BAF-2)

T = alpha + min(taus) + alpha + max(taus) + 1; %inter-frame interval
offset = (alpha/2) + randi([-alpha/2 alpha/2],1,N);

for i = 1:N %define timeline for each camera
    for k = first_frame+offset(i):T:last_frame-T+offset(i)
%     disp(['Time:' num2str(im_timestamp)]);
    
        k_c = k;                %capturing instant
        k_se = k_c;             %start of estimation phase
%        k_ee = k_c + taus(i);  %end of estimation phase (constant processing delay)
        k_ee = k_c + randi([0 taus(i)]);%end of estimation phase (random processing delay)
        
        Ticks_c(i,k_c) = 2;
        Ticks_e(i,k_se:k_ee) = 3;
        Ticks_t(i,k_ee) = 1;    %one transmission per capturing
    end
end

cycle_st = first_frame+min(offset):T:last_frame-T+min(offset);% cycle start
cycle_end = first_frame+max(offset)+max(taus):T:last_frame-T+max(offset)+max(taus);% cycle end