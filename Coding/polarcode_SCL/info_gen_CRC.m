%%������� len ��Ϣλ���ܳ��ȣ�crc CRC��У�����ʽ ��layer_number �����ֲ����
%%���볤��Ϊlen���봮�����з�Ϊlayer_number�Σ�ÿһ�ε�ǰһ�����������Ϣ ���洮����Ϣ��CRCУ�����ʽ
%%crc����������ʾ
%%�����y��һ��������

function y=info_gen_CRC(len,crc,layer_number) 


len_of_one_layer=len./layer_number;
len_crc=length(crc);
y=[];                                    %%������Ϣ֮ǰ����Ϊ�վ���
for i=1:layer_number
    y1=randsrc(1,len_of_one_layer-len_crc,[0 1]);
    y_layer=cyclic_redundancy_code(y1,crc);
    y=[y,y_layer];
end
y=y';
end