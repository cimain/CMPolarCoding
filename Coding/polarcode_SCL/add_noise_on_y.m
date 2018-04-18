%%该程序的输入向量是编码器传递给信道的x和信道的差错概率
%%输出为译码器的经过信道污染的x 用y来表示
%%输入x是一个列向量


function y=add_noise_on_y(x,sigma)

N=length(x);
x=2.*x-1;
e = sigma*randn(N,1);

y=x+e;
 
end