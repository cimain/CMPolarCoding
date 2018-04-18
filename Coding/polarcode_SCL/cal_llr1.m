function y=cal_llr1(N,channel_out,i,u,p)  
L=channel_out;
if N==2    %%N==2相邻代表已到了递归的倒数第二层，可以利用信道参数了
    if mod(i,2)==1  %%这是第一个信道 不需要u的估计
        if u(1)==1
            if L(1)==1
                if L(2)==1
                    y=0;
                else
                    y=(1-p)^2/2;
                end
            else if L(1)==0
                    if L(2)==1
                        y=(1-p)^2/2;
                    else
                        y=0;
                    end
                else
                    if L(2)==1
                        y=(1-p)^2/2;
                    else
                        y=0;
                    end
            end
        else
            if L(1)==1
                if L(2)==1
                    y=(1-p)^2/2;
                else
                    y=0;
                end
            else
                if L(2)==1
                    y=0;
                else
                    y=(1-p)^2/2;
                end
            end
        end                    
    else            %%这是第二个信道 需要上一个估计
        if u(2)==1
            if L(2)==0
                y=0;
            else
                if L(1)~=u(1)
                    y=(1-p)^2/2;
                else
                    y=0;
                end
            end
        else
            if L(2)==0
                y=0;
            else
                if L(1)==u(1)
                    y=(1-p)^2/2;
                else
                    y=0
                end
            end
        end
    end      %%当N~==2的时候 表示递归还要继续
else
    if mod(i,2)==1   %% i为奇数的时候
        uoe=mod(u(1:2:i-1)+u(2:2:i-1),2);
        ue=u(2:2:i-1);
        y=(cal_llr1(N/2,L(1:N/2),i,[uoe, u(i)],p)*cal_llr1(N/2,L(N/2+1:N),i,[ue, 0],p)+cal_llr1(N/2,L(1:N/2),i,[uoe, mod(u(i)+1,2)],p)*cal_llr1(N/2,L(N/2+1:N),i,[ue, 1],p))/2;
    else             %% i为偶数的时候
        uoe=mod(u(1:2:i-2)+u(2:2:i-2),2 );
        ue =u(2:2:i-2);
        y=0.5*cal_llr1(N/2,L(1:N/2),i,[uoe, mod(u(i)+u(i-1),2)],p)*cal_llr1(N/2,L(N/2+1:N),i,[ue, u(i)],p)
    end
end



end