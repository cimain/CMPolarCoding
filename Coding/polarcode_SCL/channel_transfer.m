%%该程序用于计算信道在转化过程中的值，用递归解决
%%输入参数N是在当前递归过程中的信道总数，i是这N个复合信道中的第i个子信道
%%W_base是基础信道参数，写在另一个子程序供调用
%%uu是前i-1个已知的估计，是长度为i-1的向量，u是第i个正要被判断的估计
%%W是信道输出 转移概率

%%特殊情况
%%当i=1时，调用时规定uu为空矩阵


function W=channel_transfer(N,i,y,uu,u)



if N==2                      %%N ==2已经到了递归的最后一层
    if mod(i,2)==1           %%i=1的时候 公式19
        W=log( 0.5*W_base(u+0,y(1))*W_base(0,y(2))+0.5*W_base(mod(u+1,2),y(1))*W_base(1,y(2)) );
    else                     %%i==2的时候 公式20
        W=log( 0.5*W_base(mod(uu(1)+u,2),y(1))*W_base(u,y(2)) );
    end
else
    if mod(i,2)==1           %%i为奇数,输入为当前和下一位的遍历
        uoe=mod(uu(1:2:i-1)+uu(2:2:i-1),2);
        ue=uu(2:2:i-1);
        W=log(0.5*exp(channel_transfer(N/2,(i+1)/2,y(1:N/2),uoe,0+u))*exp(channel_transfer(N/2,(i+1)/2,y(N/2+1:N),ue,0)) + 0.5*exp(channel_transfer(N/2,(i+1)/2,y(1:N/2),uoe,mod(1+u,2)))*exp(channel_transfer(N/2,(i+1)/2,y(N/2+1:N),ue,1)));  %%式22
    else                     %%i为偶数 只有当前输入
        uoe=mod(uu(1:2:i-2)+uu(2:2:i-2),2);
        ue=uu(2:2:i-2);
        W=log (0.5*exp(channel_transfer(N/2,i/2,y(1:N/2),uoe,mod(uu(i-1)+u,2)))*exp(channel_transfer(N/2,i/2,y(N/2+1:N),ue,u)));  %%公式23，在前i-1个判决的前提下 计算i=1和i=0的转移概率
    end
end



end