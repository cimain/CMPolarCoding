
clear all
%%polarcode仿真的主程序
%%%%%%%%%%%%%%%%%%%%%%%   初始化   %%%%%%%%%%%%%%%%%%%%%%%%%

block_size=10     % 该值为2的指数，表示码长
code_rate=0.5     %码率为0.2
no_of_frame=100;  %帧的数目为100
channel_type='AWGN';
sigma=0.5;             %%高斯噪声的标准差
% no_of_L=32;           %%这个参数表示SCL译码器保留路径的条数
channel_adaptive=1;  %%1表示用户指定的码率 0表示信道自己计算可用信道数量；理论上只有当码长为无穷大时才可以将该参数赋0
err=0;               %%程序开始之前没有误码

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
choose_SCorSCL=0    %%0表示用sc译码 1表示scl译码
% no_of_layer=2         %%对译码的码树的分层
% ccitt=[1 0 1 0 1 0 0 0 0 0 1 0 0 0 1 0]   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    参数计算

N=2^block_size;                                   %% N表示码长
channel_capacity=1-erasure_probability            %%对于BEC信道 容量是1-删除概率
if channel_adaptive==1                            %%计算可用信道的数量
    no_of_accessible_channel=round(N.*code_rate)
else
    no_of_accessible_channel=round(N.*channel_capacity)
end
SNR=10*log10(1./(2*sigma^2*code_rate))
syms y
z=double( int( sqrt(1/(2*pi)*exp(-1*(2*y^2-2*y+1)./(2*sigma^2))),y,-10,10) );
% z
[vals,inds] = get_bec_erasure_rates(block_size,z); %调用子程序g_b_e_r计算2^blocksize个信道的擦除概率，并且降序排列
% vals
% inds
inds_of_free_position=inds(N-no_of_accessible_channel+1:N);  %该参数是对应可用信道的索引
inds_of_frozen_position=inds(1:N-no_of_accessible_channel);   %该参数是对应纯噪声信道的索引

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     编译码

u=zeros(N,1);   %%u是一个列向量，作为信息向量，之后在可用信道的位置上赋值
z=zeros(N,1);   %%z是译码器知道的信息之一，是和信息向量对应的位置向量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%信息产生方式不同
if choose_SCorSCL==0
    info=info_gen(no_of_accessible_channel);  %%调用子程序产生随机信息比特串
else
    info=info_gen_CRC(no_of_accessible_channel,ccitt,no_of_layer);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u(inds_of_free_position)=info;        %%u是编码器的输入，在自由位上是信息比特，在固定位上是0
z(inds_of_free_position)=1;           %%z中，1对应信息位 ，0对应固定位
x=encode(u);                          %%调用子程序对u进行编码并输出
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if choose_SCorSCL==0
    L=add_noise(x,erasure_probability);   %%调用子程序对编码器输出加噪,输出对数似然比和信息比特的位置
else
    y_input=add_noise_on_y(x,sigma);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%译码
if choose_SCorSCL==0
    y=decoder(L,z,no_of_L);               %%调用子程序对加噪信息进行SC译码
else
    y=SCL_CRC_decoder(y_input,z,no_of_L,ccitt,no_of_layer);                        %%调用子程序对信息进行SCL_CRC译码
end
u_est=y(inds_of_free_position);
err= length(find(u_est~=info))+err;                  %%err用于统计当前的错误总个数         

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    计算BLER

error_rate=err./(N)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
