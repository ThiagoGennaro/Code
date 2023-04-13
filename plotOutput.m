%% Author: Sandeep Katragadda
% Date: 30 June 2017
% Go through ReadMe.doc and License.doc files before using the software.
%
% Requested citation acknowledgement when using this software:
% Sandeep Katragadda and Andrea Cavallaro, “A batch asynchronous tracker for wireless smart-camera networks”, Proceedings of the 14th IEEE International Conference on Advanced Video and Signal based Surveillance (AVSS), Lecce, Italy, 29 August - 1 September, 2017.
%
% This matlab script plots and saves the results of the experiments.
% Root Mean Square Error vs maximum asynchronism
% Root Mean Square Error vs maximum delay
%% =======================================================================

loadPrevResult = 0; %1
if loadPrevResult
    clc;
    clear all;
    close all;
    
    % set input settings
    delay = true;
    async = true;

    if delay
        load BAF_Result_delay.mat
    else
        load BAF_Result_noDelay.mat
    end
    

    if async
        load BAF_Result_async.mat
    else
        load BAF_Result_sync.mat
    end
end

%% plot RMSE vs asynchronism - LoS, BAF and PF
h_fig_async_1 = figure(1);
clf;
fs = 14;
plot(alphas,flip(armse_async(1,:),2),'c+-','LineWidth',1,'MarkerSize',10); hold on;
plot(alphas,flip(armse_async(2,:),2),'rx-','LineWidth',1,'MarkerSize',10); hold on;
plot(alphas,flip(armse_async(3,:),2),'kx-','LineWidth',1,'MarkerSize',10); hold on;
xlabel('\alpha^{max} (time steps)','fontsize',fs);
ylabel('\epsilon (pixels)','fontsize',fs);
ylim([0 max(max(armse_async))]);
legend('LoS \alpha^{max} = 0 and \tau^{max} = 0','BAF','PF')
grid on
set(gca,'FontSize',fs);

%% plot RMSE vs delays - LoS, BAF and PF
h_fig_delays_1 = figure(2);
clf;
fs = 14;
plot(mtaus,flip(armse_delays(1,:),2),'c+-','LineWidth',1,'MarkerSize',10); hold on;
plot(mtaus,flip(armse_delays(2,:),2),'rx-','LineWidth',1,'MarkerSize',10); hold on;
plot(mtaus,flip(armse_delays(3,:),2),'kx-','LineWidth',1,'MarkerSize',10); hold on;
xlabel('\tau^{max} (time steps)','fontsize',fs);
ylabel('\epsilon (pixels)','fontsize',fs);
ylim([0 max(max(armse_delays))]);
legend('BAF (delay transmition)','PF')
grid on
set(gca,'FontSize',fs);

%% plot RMSE vs asynchronism - BAF and BAF consensus
h_fig_async_2 = figure(3);
clf;
fs = 12;
plot(alphas,flip(armse_async(2,:),2),'rx-','LineWidth',1,'MarkerSize',10); hold on;
plot(alphas,flip(armse_async(4,:),2),'bx-','LineWidth',1,'MarkerSize',10); hold on;
xlabel('\alpha^{max} (time steps)','fontsize',fs);
ylabel('\epsilon (pixels)','fontsize',fs);
ylim([0 max(max(armse_async(4,:)))]);
legend('BAF (delay transmition)',strcat('BAF (delay transmission) with Consensus: ','p = ',num2str(p_consensus)))
grid on
set(gca,'FontSize',fs);

%% plot RMSE vs delays - BAF and BAF consensus
h_fig_delays_2 = figure(4);
clf;
fs = 12;
plot(mtaus,flip(armse_delays(2,:),2),'rx-','LineWidth',1,'MarkerSize',10); hold on;
plot(mtaus,flip(armse_delays(4,:),2),'bx-','LineWidth',1,'MarkerSize',10); hold on;
xlabel('\tau^{max} (time steps)','fontsize',fs);
ylabel('\epsilon (pixels)','fontsize',fs);
ylim([0 max(max(armse_delays(4,:)))]);
legend('BAF (delay transmition)',strcat('BAF (delay transmission) with Consensus: ','p = ',num2str(p_consensus)))
grid on
set(gca,'FontSize',fs);

%% plot RMSE vs asynchronism - PF and PF consensus
h_fig_async_3 = figure(5);
clf;
fs = 12;
plot(alphas,flip(armse_async(3,:),2),'kx-','LineWidth',1,'MarkerSize',10); hold on;
plot(alphas,flip(armse_async(5,:),2),'mx-','LineWidth',1,'MarkerSize',10); hold on;
xlabel('\alpha^{max} (time steps)','fontsize',fs);
ylabel('\epsilon (pixels)','fontsize',fs);
ylim([0 max(max(armse_async))]);
legend('PF',strcat('PF with Consensus: ','p = ',num2str(p_consensus)))
grid on
set(gca,'FontSize',fs);

%% plot RMSE vs delays - PF and PF consensus
h_fig_delays_3 = figure(6);
clf;
fs = 12;
plot(mtaus,flip(armse_delays(3,:),2),'kx-','LineWidth',1,'MarkerSize',10); hold on;
plot(mtaus,flip(armse_delays(5,:),2),'mx-','LineWidth',1,'MarkerSize',10); hold on;
xlabel('\tau^{max} (time steps)','fontsize',fs);
ylabel('\epsilon (pixels)','fontsize',fs);
ylim([0 max(max(armse_delays))]);
legend('PF',strcat('PF with Consensus: ','p = ',num2str(p_consensus)))
grid on
set(gca,'FontSize',fs);

%% plot RMSE vs asynchronism - BAF, BAF fusion, PF and PF fusion
h_fig_async_4 = figure(7);
clf;
fs = 10;
%plot(alphas,flip(armse_async(1,:),2),'gx-','LineWidth',2,'MarkerSize',10); hold on;
plot(alphas,flip(armse_async(2,:),2),'rx-','LineWidth',2,'MarkerSize',10); hold on;
plot(alphas,flip(armse_async(3,:),2),'kx-','LineWidth',2,'MarkerSize',10); hold on;
plot(alphas,flip(armse_async(4,:),2),'bx-','LineWidth',2,'MarkerSize',10); hold on;
plot(alphas,flip(armse_async(5,:),2),'mx-','LineWidth',2,'MarkerSize',10); hold on;
xlabel('\alpha^{max} (time steps)','fontsize',fs);
ylabel('\epsilon (pixels)','fontsize',fs);
ylim([0 max(max(armse_async))]);
%legend('BAF fused measurement and local estimation','PF fused measurement and local estimation',strcat('BAF-LLM fused measurement and fusion window - steps: ','p = ',num2str(p_consensus)),strcat('SA-PF fused measurement and fusion window - steps: ','p = ',num2str(p_consensus)),'fontsize',fs)
legend('BAF com fusão de medidas e estimativa local','PF com fusão de medidas e estimativa local',strcat('BAF-LLM medidas fundidas e janela de fusão - passos: ','p = ',num2str(p_consensus)),strcat('SA-PF medidas fundidas e janela de fusão - passos: ','p = ',num2str(p_consensus)),'fontsize',fs)
grid on
set(gca,'FontSize',fs);
saveas(h_fig_async_4,strcat('BAF_ARMSE_',num2str(p_consensus),'_delay_',num2str(p_consensus),'.png'));
saveas(h_fig_async_4,strcat('BAF_ARMSE_',num2str(p_consensus),'_delay_',num2str(p_consensus),'.eps'),'epsc');

%% plot RMSE vs delays - BAF, BAF fusion, PF and PF fusion
h_fig_delays_4 = figure(8);
clf;
fs = 10;
%plot(mtaus,flip(armse_delays(1,:),2),'gx-','LineWidth',2,'MarkerSize',10); hold on;
plot(mtaus,flip(armse_delays(2,:),2),'rx-','LineWidth',2,'MarkerSize',10); hold on;
plot(mtaus,flip(armse_delays(3,:),2),'kx-','LineWidth',2,'MarkerSize',10); hold on;
plot(mtaus,flip(armse_delays(4,:),2),'bx-','LineWidth',2,'MarkerSize',10); hold on;
plot(mtaus,flip(armse_delays(5,:),2),'mx-','LineWidth',2,'MarkerSize',10); hold on;
xlabel('\tau^{max} (time steps)','fontsize',fs);
ylabel('\epsilon (pixels)','fontsize',fs);
ylim([0 max(max(armse_delays))]);
%legend('BAF fused measurement and local estimation','PF fused measurement and local estimation',strcat('BAF-LLM fused measurement and fusion window - steps: ','p = ',num2str(p_consensus)),strcat('SA-PF fused measurement and fusion window - steps: ','p = ',num2str(p_consensus)),'fontsize',fs)
legend('BAF com fusão de medidas e estimativa local','PF com fusão de medidas e estimativa local',strcat('BAF-LLM medidas fundidas e janela de fusão - passos: ','p = ',num2str(p_consensus)),strcat('SA-PF medidas fundidas e janela de fusão - passos: ','p = ',num2str(p_consensus)),'fontsize',fs)
grid on
set(gca,'FontSize',fs);
saveas(h_fig_delays_4,strcat('BAF_ARMSE_',num2str(p_consensus),'_async_',num2str(p_consensus),'.png'));
saveas(h_fig_delays_4,strcat('BAF_ARMSE_',num2str(p_consensus),'_async_',num2str(p_consensus),'.eps'),'epsc');

%% save results
if delay

    saveas(h_fig_async_1,strcat('BAF_ARMSE_',num2str(p_consensus),'_delay_',num2str(p_consensus),'.png'));
    saveas(h_fig_async_1,strcat('BAF_ARMSE_',num2str(p_consensus),'_delay_',num2str(p_consensus),'.eps'),'epsc');
    
    save(strcat('BAF_Result_delay_consensus_',num2str(p_consensus),'.mat'),'armse_async','alphas','mtaus');
end

if async

    saveas(h_fig_delays_1,strcat('BAF_ARMSE_',num2str(p_consensus),'_async_',num2str(p_consensus),'.png'));
    saveas(h_fig_delays_1,strcat('BAF_ARMSE_',num2str(p_consensus),'_async_',num2str(p_consensus),'.eps'),'epsc');

    save(strcat('BAF_Result_async_consensus_',num2str(p_consensus),'.mat'),'armse_delays','alphas','mtaus');
end

