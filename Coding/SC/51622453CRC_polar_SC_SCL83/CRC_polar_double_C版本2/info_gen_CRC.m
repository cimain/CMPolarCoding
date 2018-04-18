%%输入参数 len 信息位的总长度；crc CRC的校验多项式 ；layer_number 码树分层层数
%%输入长度为len的码串，其中分为layer_number段，每一段的前一部分是随机信息 后面串联信息的CRC校验多项式
%%crc用行向量表示
%%输出的y是一个列向量

function y=info_gen_CRC(len) 

len_of_one_layer=len;
%len_crc=length(crc)-1;
y=[];                                    %%产生信息之前矩阵为空矩阵

%y1=randsrc(1,len_of_one_layer-len_crc,[0 1]);
%randn('state',0); rand('state',0);
%y1=randi([0 1],1,len_of_one_layer-len_crc);
%y_layer=cyclic_redundancy_code(y1.',crc);

y_layer=randi([0 1],1,len_of_one_layer);
%y_layer=randsrc(1,len_of_one_layer,[0 1]);
y=[y,y_layer];

end