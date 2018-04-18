%      被除数的码式肯定要比除数的码式长，否则程序会出错                                                                    
%      输入是对应的编码序列的码式，输出的是信息比特串和是否有错误                                                                           
function err = cyclic_redundancy_decode(crc_coded_sequence,crc)
        crc_ccitt =crc; 
        crc_length=length(crc);
        original_sequence = crc_coded_sequence(1:(length(crc_coded_sequence)-crc_length)) ;                          % 初始化输出序列
        sequence_length=length(original_sequence)    ;            %信息比特串的长度                       
        add_zeros=zeros(1,sequence_length-crc_length);
        p=crc_coded_sequence((1+sequence_length):length(crc_coded_sequence));
        sequence=bitxor(original_sequence,[add_zeros p]);      %得到被除数
        remainder_bits = sequence(1:crc_length);                  % 初始化余数数组
        cycle_length = sequence_length-crc_length+1;              % 计算长除法的循环周期 
        
        for k = 1:cycle_length                                    % 开始循环计算长除得到最终余数
            register_bits=crc_ccitt;
            if remainder_bits(1) == 0                               
                register_bits = zeros(1,length(register_bits));
            end
            remainder_bits=bitxor(register_bits,remainder_bits);
            if (k~=sequence_length-length(crc)+1)
                remainder_bits = [remainder_bits(2:length(register_bits)),sequence(k+length(register_bits))];
            end
        end
        
        if sum(remainder_bits) == 0                             % 传输码元中没有发生奇数个错误
%             original_sequence = crc_coded_sequence(1:sequence_length);
            err = 0 ;
        else
            err = 1  ;                                                  % 码元传输发生错误
%             original_sequence = zeros(1:sequence_length);
        end
end
    