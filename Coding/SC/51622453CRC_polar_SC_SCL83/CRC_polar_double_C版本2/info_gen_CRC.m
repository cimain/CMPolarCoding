%%������� len ��Ϣλ���ܳ��ȣ�crc CRC��У�����ʽ ��layer_number �����ֲ����
%%���볤��Ϊlen���봮�����з�Ϊlayer_number�Σ�ÿһ�ε�ǰһ�����������Ϣ ���洮����Ϣ��CRCУ�����ʽ
%%crc����������ʾ
%%�����y��һ��������

function y=info_gen_CRC(len) 

len_of_one_layer=len;
%len_crc=length(crc)-1;
y=[];                                    %%������Ϣ֮ǰ����Ϊ�վ���

%y1=randsrc(1,len_of_one_layer-len_crc,[0 1]);
%randn('state',0); rand('state',0);
%y1=randi([0 1],1,len_of_one_layer-len_crc);
%y_layer=cyclic_redundancy_code(y1.',crc);

y_layer=randi([0 1],1,len_of_one_layer);
%y_layer=randsrc(1,len_of_one_layer,[0 1]);
y=[y,y_layer];

end