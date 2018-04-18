%%这个函数用来计算没有u作为输入的似然比
%%输入是参数y的上角标和下角标，以及信道传递过来的似然比矩阵
function y=cal_l(n1,n2,L)  

channel_LLR=L;
if n2==n1+1
    y=(channel_LLR(n1)*channel_LLR(n2)+1)./(channel_LLR(n1)+channel_LLR(n2));
else
    y=(cal_l(n1,(n1+n2)./2-0.5,channel_LLR)*cal_l((n1+n2)./2+0.5,n2,channel_LLR)+1) ./ ( cal_l(n1,(n1+n2)./2-0.5,channel_LLR)+cal_l((n1+n2)./2+0.5,n2,channel_LLR) );
end


end