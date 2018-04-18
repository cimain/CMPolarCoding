%                                                         
%  �ú���ͨ�������ź����к���Ӧѡ��16��CCITT_CRC���ɶ���ʽ 
%  ����ѭ����������(CRC)�����������β����������       
%  ��һ����������Ǳ����� �ڶ�����������ǳ��� ������Ϻõ�CRC��ʽ                                                 

function crc_coded_sequence = cyclic_redundancy_code(uncode_sequence,crc)

sequence_length = length(uncode_sequence);                                    % �õ�ԭʼ�źų���
crc_ccitt =crc;                                                         % ���õ�CRC���ɶ���ʽ1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1
uncode_sequence=[uncode_sequence,zeros(1,length(crc_ccitt))];                     
remainder_bits=uncode_sequence(1:length(crc_ccitt));

for k = 1:(sequence_length-length(crc_ccitt)+1)                               % ��ʼѭ�����㳤���õ���������
    register_bits=crc_ccitt;
    if remainder_bits(1) == 0                               
        register_bits = zeros(1,length(register_bits));
    end
    remainder_bits=bitxor(register_bits,remainder_bits);
    if (k~=sequence_length-length(crc_ccitt)+1)
        remainder_bits = [remainder_bits(2:length(register_bits)),uncode_sequence(k+length(register_bits))];
    end
end                                                                              %�õ�CRC����������ʽ

add_len = length(uncode_sequence) - length(remainder_bits);       
% �����������е�����λ�Ե��ӵ���������
remainder_bits = [zeros(1,add_len),remainder_bits];        % ���������������
crc_coded_sequence = uncode_sequence + remainder_bits;  % �ϳɱ�������

