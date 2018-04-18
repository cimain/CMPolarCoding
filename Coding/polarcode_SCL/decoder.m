function y=decoder(Lr,z,no_of_L)

[L xx]=size(Lr);      %%z用来指示自由位和固定位的位置，Lr是由信道过来的似然比矩阵，L是码长
h=[];                 %%h保存输出的似然比 y是通过似然比硬判决得到的值
Lo=no_of_L;           %%Lo是SCL中L的值
u_matrix=[];          %%在程序结束是是一个Lo*（L+1）的矩阵，每一行对应一串麻子，最后一位是码字的概率
u_temp=[];            %%存放2Lo个码字串，用于选出Lo个码字串的临时矩阵
u_est=zeros(L,1);             %%u_est存放u的估计 在程序末端u的估计完成时将该值赋给y

% for i=1:L
%     h(i,log2(L)+1)=Lr(i);  %%在矩阵的最右端赋信道得到的似然比矩阵Lr
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SC译码

for i=1:L
    if z(i)==0
        u_est(i)=0;
    else
        h(i)=cal_llr(L,Lr,i,u_est);     %%计算当前元素的似然比
        if h(i)>=1                      %%通过似然比来判断u是0或者是1
            u_est(i)=0;
        else
            u_est(i)=1;
        end
        %u_est=u_est.*z;                 %%在每一位判断后要对固定位强行赋值0
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y=u_est;

end