%%%%这个函数用SCL的译码算法进行译码
%%y0是从信道来的接收向量
%%z用来指示信息位和固定位的位置
%%no_of_L是保留的路径个数 只可以取2的幂次 比如4 8 16
%%ccitt是CRC校验多项式
%%layer_number是把码树分的层数
 
function y=SCL_CRC_decoder(y0,z,no_of_L,ccitt,layer_number)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%初始化

[L xx]=size(y0);                 %%z用来指示自由位和固定位的位置，y0是从信道接收的列向量，L是码长
Lo=no_of_L;                      %%Lo是SCL中L的值
Flag=log2(Lo);                   %%Flag用于指示Lo条路径的选取方法的切换
u_matrix=zeros(Lo,L+1);          %%是一个Lo*（L+1）的矩阵，每一行对应一串码字，最后一位是码串的概率
u_temp=zeros(2*Lo,2);            %%存放2Lo个码字串的判断位置，用于选出Lo个码字串的临时矩阵
u_temp(1:2:2*Lo,1)=ones(Lo,1)
reserve_all=travel(Lo)
flag=0;                          %%表示当前还没有遇到第一个信息位
free_position=find(z==1);        %%这个矩阵用来存放信息位的位置索引
free_length=length(free_position)%%信息位的长度


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SCL译码

for i=1:L                             %%i表示已经判决了（i-1）个bit
%     i
%     u_matrix
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%矩阵初始化
%     if i==1                             %%此时是初始化u_matrix 既然码率不能达到1，那么第一位必然是固定位
%         u_matrix(:,1)=zeros(Lo,1);      %%第一位全部赋0
%         %u_matrix(:,L+1)=ones(Lo,1);     %%概率位置全部赋1
%         continue;
%     end
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
     %%i表示当前要判断码字中的第i位 flag表示要判断当前的第flag个信息
    if z(i)==0                          %%对于固定位置 在该位置为0的概率赋值1
        u_matrix(:,i)=zeros(Lo,1);
    else                                %%对于自由位  要分两种情况 1.需要全部保留路径 2.选取最优路径
        flag=flag+1;                    %%此时的flag表示正在判断第几个信息位
%         flag
        
        if flag<=Flag                   %%此时要保留所有路径 并算概率
             u_matrix(:,i)=reserve_all(:,flag);
             if flag==Flag
                 for j=1:Lo                 %%j循环表示遍历Lo个码串
                     u_matrix(j,L+1)=channel_transfer(L,i,y0,u_matrix(j,1:i-1),u_matrix(j,i));
                 end
             end
%              u_matrix
             
        else                            %%此时要选取最优路径
            
            for j=1:Lo                  %%j循环表示遍历Lo个码串
                u_temp(2*j-1,2)=channel_transfer(L,i,y0,u_matrix(j,1:i-1),1);    
                u_temp(2*j,2)  =channel_transfer(L,i,y0,u_matrix(j,1:i-1),0);                                        %%上两行计算了在当前条件下分别下一位取0和1的总路径概率
                [vals,inds]    =sort(u_temp(:,2),'descend');                                                         %%将概率值降序排列
                temp=[];
                for k=1:Lo                                                                                           %%%这个循坏用于从2Lo个概率值中选取最优
                    if  mod(inds(k),2)==1                                                                            %%奇数索引值表示最后一位是1，tempcode最后一位是该路径的概率
                        tempcode=[u_matrix((inds(k)+1)/2,1:i-1),1,vals(k)];
                        temp=[temp;tempcode];
                    else                                                                                             %%偶数索引表示最后一位是0 ，tempcode最后一位是该路径的概率
                        tempcode=[u_matrix(inds(k)/2,1:i-1),0,vals(k)];
                        temp=[temp;tempcode];
                    end   
                end                       %%end of k_cycle
            end                           %%end of j_cycle
%             temp
            u_matrix(:,1:i)=temp(:,1:i);
            u_matrix(:,L+1)=temp(:,i+1);
            
        end                               %%end of if 
        
        if mod(flag,free_length./layer_number)==0      %%当判断的当前位置正好是层的边界时 进行CRC校验 并选择最大概率的输出
            no_of_rank=flag./(free_length./layer_number);           %%no_of_rank用来存放当前的层数
            for ii=1:Lo
                [values,index]=sort(u_matrix(:,L+1),'descend');
                err=cyclic_redundancy_decode( u_matrix(index(ii),free_position((no_of_rank-1).*free_length./layer_number+1:no_of_rank.*free_length./layer_number)),ccitt );
                if err == 0               %%校验式通过CRC
                    for jj=1:Lo
                        u_matrix(jj,free_position((no_of_rank-1).*free_length./layer_number+1:no_of_rank.*free_length./layer_number))=u_matrix(index(ii),free_position((no_of_rank-1).*free_length./layer_number+1:no_of_rank.*free_length./layer_number));
                    end
                    u_matrix(:,L+1)=ones(Lo,1);
                    break;
                else                     %%此时err=1 码式没有通过CRC 
                    continue;
                end
            end
        end
    end                                   %%end of if
    
end                                       %%end of i_cycle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%最后从Lo条路径中选取最大的一条输出

y=u_matrix(1,1:L)';

end