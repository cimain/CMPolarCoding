%%%%���������SCL�������㷨��������
%%y0�Ǵ��ŵ����Ľ�������
%%z��inds_of_free_position����ָʾ��Ϣλ�͹̶�λ��λ��
%%no_of_L�Ǳ�����·������ ֻ����ȡ2���ݴ� ����4 8 16
%%ccitt��CRCУ�����ʽ
function y=SC_decoder(y0,z,sigma)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L0=length(y0);  
y=zeros(L0,1);
u=zeros(1,L0);            %�洢no_of_L��·��,���һλΪ����ֵ
PM_i_1=zeros(1,1);        %�洢ÿ��·����Ӧ��·������ֵ
PM_i=zeros(2,1);          %�洢ÿ��·����Ӧ��·������ֵ

ui=0;
N=L0;
for i=1:L0
    for j=1:2
        ui=mod(j+1,2);
        PM_i(j)=Gen_PM(PM_i_1,N,i,y0,u(1:i-1),ui,z,sigma);
    end
        [value,index]=max(PM_i);  %���ֵ·����Ȼֵ
        u(i)=mod(index+1,2);
        PM_i_1=PM_i(index);       %ѡȡ�����Ȼֵ��·��
end
u(L0)=1-u(L0); %���һλȡ��
y=u;%(inds_of_free_position).';
end