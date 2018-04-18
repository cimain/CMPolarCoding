
clear all
%%polarcode�����������
%%%%%%%%%%%%%%%%%%%%%%%   ��ʼ��   %%%%%%%%%%%%%%%%%%%%%%%%%

block_size=10     % ��ֵΪ2��ָ������ʾ�볤
code_rate=0.5     %����Ϊ0.2
no_of_frame=100;  %֡����ĿΪ100
channel_type='AWGN';
sigma=0.5;             %%��˹�����ı�׼��
% no_of_L=32;           %%���������ʾSCL����������·��������
channel_adaptive=1;  %%1��ʾ�û�ָ�������� 0��ʾ�ŵ��Լ���������ŵ�������������ֻ�е��볤Ϊ�����ʱ�ſ��Խ��ò�����0
err=0;               %%����ʼ֮ǰû������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
choose_SCorSCL=0    %%0��ʾ��sc���� 1��ʾscl����
% no_of_layer=2         %%������������ķֲ�
% ccitt=[1 0 1 0 1 0 0 0 0 0 1 0 0 0 1 0]   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    ��������

N=2^block_size;                                   %% N��ʾ�볤
channel_capacity=1-erasure_probability            %%����BEC�ŵ� ������1-ɾ������
if channel_adaptive==1                            %%��������ŵ�������
    no_of_accessible_channel=round(N.*code_rate)
else
    no_of_accessible_channel=round(N.*channel_capacity)
end
SNR=10*log10(1./(2*sigma^2*code_rate))
syms y
z=double( int( sqrt(1/(2*pi)*exp(-1*(2*y^2-2*y+1)./(2*sigma^2))),y,-10,10) );
% z
[vals,inds] = get_bec_erasure_rates(block_size,z); %�����ӳ���g_b_e_r����2^blocksize���ŵ��Ĳ������ʣ����ҽ�������
% vals
% inds
inds_of_free_position=inds(N-no_of_accessible_channel+1:N);  %�ò����Ƕ�Ӧ�����ŵ�������
inds_of_frozen_position=inds(1:N-no_of_accessible_channel);   %�ò����Ƕ�Ӧ�������ŵ�������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     ������

u=zeros(N,1);   %%u��һ������������Ϊ��Ϣ������֮���ڿ����ŵ���λ���ϸ�ֵ
z=zeros(N,1);   %%z��������֪������Ϣ֮һ���Ǻ���Ϣ������Ӧ��λ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%��Ϣ������ʽ��ͬ
if choose_SCorSCL==0
    info=info_gen(no_of_accessible_channel);  %%�����ӳ�����������Ϣ���ش�
else
    info=info_gen_CRC(no_of_accessible_channel,ccitt,no_of_layer);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u(inds_of_free_position)=info;        %%u�Ǳ����������룬������λ������Ϣ���أ��ڹ̶�λ����0
z(inds_of_free_position)=1;           %%z�У�1��Ӧ��Ϣλ ��0��Ӧ�̶�λ
x=encode(u);                          %%�����ӳ����u���б��벢���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if choose_SCorSCL==0
    L=add_noise(x,erasure_probability);   %%�����ӳ���Ա������������,���������Ȼ�Ⱥ���Ϣ���ص�λ��
else
    y_input=add_noise_on_y(x,sigma);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%����
if choose_SCorSCL==0
    y=decoder(L,z,no_of_L);               %%�����ӳ���Լ�����Ϣ����SC����
else
    y=SCL_CRC_decoder(y_input,z,no_of_L,ccitt,no_of_layer);                        %%�����ӳ������Ϣ����SCL_CRC����
end
u_est=y(inds_of_free_position);
err= length(find(u_est~=info))+err;                  %%err����ͳ�Ƶ�ǰ�Ĵ����ܸ���         

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    ����BLER

error_rate=err./(N)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
