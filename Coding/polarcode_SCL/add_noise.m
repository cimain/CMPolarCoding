%%该程序的输入向量是编码器传递给信道的x和信道的差错概率
%%输出为译码器的接收似然比
%%此函数针对BEC信道

function L=add_noise(x,erasure_probability)

N=length(x);
BigNumber=100;
e = randsrc(N,1,[0 1; 1-erasure_probability erasure_probability]);
L= (1-x).*BigNumber+x.*(1/BigNumber);

L(find(e == 1)) = 1;
 
end