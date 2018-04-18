%%该程序的输入向量是编码器传递给信道的x和信道的差错概率
%%输出为译码器的经过信道污染的x 用y来表示
%%输入x是一个列向量


function y=add_noise(x,SNRdB)

N=length(x);
x=2.*x-1;
% m=2; % BPSK调制
% EsN0dB = EbN0dB + 10*log10(R*log2(m));
%randn('state',0); 
%rand('state',0);
y=awgn(x,SNRdB,'measured');
% EsN0 = 10^(EsN0dB/10);                            % convert Eb/N0 from unit db to normal number
% ES=1; %bpsk
% noisePower=ES/EsN0;
% sigma=sqrt(noisePower);
%y=x+sigma*randn(N,1);

end