%%�ó�������������Ǳ��������ݸ��ŵ���x���ŵ��Ĳ�����
%%���Ϊ�������ľ����ŵ���Ⱦ��x ��y����ʾ
%%����x��һ��������


function y=add_noise(x,SNRdB)

N=length(x);
x=2.*x-1;
% m=2; % BPSK����
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