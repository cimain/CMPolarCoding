%%输入是参数N表示当前递归位置的信道个数，以及信道似然比矩阵的当前递归似然比channel_LLR，当前正要被判决元素的序号i以及已经判决好的前（i-1）个u的估计
%%u的估计,必须完整的作为参数uu输入过来，程序取用有用的部分 
%%u是一个任意的N长【0 1】列向量
%%输出是当前判决元素的似然比

function y=cal_llr(N,channel_LLR,i,uu)  

L=channel_LLR;  %% L是信道端输入的似然比矩阵
u=uu;           %%


if N==2    %%N==2相邻代表已到了递归的倒数第二层，可以利用信道参数了
    if mod(i,2)==1  %%这是第一个信道 不需要u的估计
        y=(L(1)*L(2)+1)./(L(1)+L(2));
    else            %%这是第二个信道 需要上一个估计
        y=L(1)^(1-2*u(i-1))*L(2);
    end
else      %%当N~==2的时候 表示递归还要继续
    if mod(i,2)==1   %% i为奇数的时候
        uoe=mod(u(1:2:i-1)+u(2:2:i-1),2);
        ue=u(2:2:i-1);
        y=(cal_llr(N/2,L(1:N/2),(i+1)/2,uoe)*cal_llr(N/2,L(N/2+1:N),(i+1)/2,ue)+1)./(cal_llr(N/2,L(1:N/2),(i+1)/2,uoe)+cal_llr(N/2,L(N/2+1:N),(i+1)/2,ue));
        if y>100
            y=100;
        elseif y<=100 && y>=0.01
                ;
        else
            y=0.01;
        end
            
    else             %% i为偶数的时候
        uoe=mod(u(1:2:i-2)+u(2:2:i-2),2 );
        ue =u(2:2:i-2);
        y=cal_llr(N/2,L(1:N/2),i/2,uoe)^(1-2*u(i-1))*cal_llr(N/2,L(N/2+1:N),i/2,ue);
        if y>100
            y=100;
        elseif y<=100 && y>=0.01
                ;
        else
            y=0.01;
        end
    end
end



end