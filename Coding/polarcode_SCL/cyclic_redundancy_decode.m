%      ����������ʽ�϶�Ҫ�ȳ�������ʽ���������������                                                                    
%      �����Ƕ�Ӧ�ı������е���ʽ�����������Ϣ���ش����Ƿ��д���                                                                           
function err = cyclic_redundancy_decode(crc_coded_sequence,crc)
        crc_ccitt =crc; 
        crc_length=length(crc);
        original_sequence = crc_coded_sequence(1:(length(crc_coded_sequence)-crc_length)) ;                          % ��ʼ���������
        sequence_length=length(original_sequence)    ;            %��Ϣ���ش��ĳ���                       
        add_zeros=zeros(1,sequence_length-crc_length);
        p=crc_coded_sequence((1+sequence_length):length(crc_coded_sequence));
        sequence=bitxor(original_sequence,[add_zeros p]);      %�õ�������
        remainder_bits = sequence(1:crc_length);                  % ��ʼ����������
        cycle_length = sequence_length-crc_length+1;              % ���㳤������ѭ������ 
        
        for k = 1:cycle_length                                    % ��ʼѭ�����㳤���õ���������
            register_bits=crc_ccitt;
            if remainder_bits(1) == 0                               
                register_bits = zeros(1,length(register_bits));
            end
            remainder_bits=bitxor(register_bits,remainder_bits);
            if (k~=sequence_length-length(crc)+1)
                remainder_bits = [remainder_bits(2:length(register_bits)),sequence(k+length(register_bits))];
            end
        end
        
        if sum(remainder_bits) == 0                             % ������Ԫ��û�з�������������
%             original_sequence = crc_coded_sequence(1:sequence_length);
            err = 0 ;
        else
            err = 1  ;                                                  % ��Ԫ���䷢������
%             original_sequence = zeros(1:sequence_length);
        end
end
    