function y=W_base(i,j)
%%这个函数用来调用基础信道的转移概率
%%该信道是AWGN信道
%%基本信道的输入为i 输出为j 信道的转移概率为y

y=1./sqrt(2*pi).*exp( -(i-j)^2./2 );



end
