%%%%这个函数用SCL的译码算法进行译码
%%y0是从信道来的接收向量
%%z和inds_of_free_position用来指示信息位和固定位的位置
%%no_of_L是保留的路径个数 只可以取2的幂次 比如4 8 16
%%ccitt是CRC校验多项式
function y=SC_decoder(y0,z,sigma)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L0=length(y0);  
y=zeros(L0,1);
u=zeros(1,L0);            %存储no_of_L条路径,最后一位为度量值
PM_i_1=zeros(1,1);        %存储每条路径对应的路径度量值
PM_i=zeros(2,1);          %存储每条路径对应的路径度量值

ui=0;
N=L0;
for i=1:L0
    for j=1:2
        ui=mod(j+1,2);
        PM_i(j)=Gen_PM(PM_i_1,N,i,y0,u(1:i-1),ui,z,sigma);
    end
        [value,index]=max(PM_i);  %最大值路径似然值
        u(i)=mod(index+1,2);
        PM_i_1=PM_i(index);       %选取最大似然值的路径
end
u(L0)=1-u(L0); %最后一位取反
y=u;%(inds_of_free_position).';
end