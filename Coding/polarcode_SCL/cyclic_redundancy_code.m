%                                                         
%  该函数通过输入信号序列和相应选择16阶CCITT_CRC生成多项式 
%  生成循环冗余检错码(CRC)，返回添加了尾比特码序列       
%  第一个输入变量是被除数 第二个输入变量是除数 输出整合好的CRC码式                                                 

function crc_coded_sequence = cyclic_redundancy_code(uncode_sequence,crc)

sequence_length = length(uncode_sequence);                                    % 得到原始信号长度
crc_ccitt =crc;                                                         % 常用的CRC生成多项式1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1
uncode_sequence=[uncode_sequence,zeros(1,length(crc_ccitt))];                     
remainder_bits=uncode_sequence(1:length(crc_ccitt));

for k = 1:(sequence_length-length(crc_ccitt)+1)                               % 开始循环计算长除得到最终余数
    register_bits=crc_ccitt;
    if remainder_bits(1) == 0                               
        register_bits = zeros(1,length(register_bits));
    end
    remainder_bits=bitxor(register_bits,remainder_bits);
    if (k~=sequence_length-length(crc_ccitt)+1)
        remainder_bits = [remainder_bits(2:length(register_bits)),uncode_sequence(k+length(register_bits))];
    end
end                                                                              %得到CRC的余数多项式

add_len = length(uncode_sequence) - length(remainder_bits);       
% 生成余数序列的冗余位以叠加到编码序列
remainder_bits = [zeros(1,add_len),remainder_bits];        % 余数序列添加冗余
crc_coded_sequence = uncode_sequence + remainder_bits;  % 合成编码序列

