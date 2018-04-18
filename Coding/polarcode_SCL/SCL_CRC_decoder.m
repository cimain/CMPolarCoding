%%%%���������SCL�������㷨��������
%%y0�Ǵ��ŵ����Ľ�������
%%z����ָʾ��Ϣλ�͹̶�λ��λ��
%%no_of_L�Ǳ�����·������ ֻ����ȡ2���ݴ� ����4 8 16
%%ccitt��CRCУ�����ʽ
%%layer_number�ǰ������ֵĲ���
 
function y=SCL_CRC_decoder(y0,z,no_of_L,ccitt,layer_number)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%��ʼ��

[L xx]=size(y0);                 %%z����ָʾ����λ�͹̶�λ��λ�ã�y0�Ǵ��ŵ����յ���������L���볤
Lo=no_of_L;                      %%Lo��SCL��L��ֵ
Flag=log2(Lo);                   %%Flag����ָʾLo��·����ѡȡ�������л�
u_matrix=zeros(Lo,L+1);          %%��һ��Lo*��L+1���ľ���ÿһ�ж�Ӧһ�����֣����һλ���봮�ĸ���
u_temp=zeros(2*Lo,2);            %%���2Lo�����ִ����ж�λ�ã�����ѡ��Lo�����ִ�����ʱ����
u_temp(1:2:2*Lo,1)=ones(Lo,1)
reserve_all=travel(Lo)
flag=0;                          %%��ʾ��ǰ��û��������һ����Ϣλ
free_position=find(z==1);        %%����������������Ϣλ��λ������
free_length=length(free_position)%%��Ϣλ�ĳ���


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SCL����

for i=1:L                             %%i��ʾ�Ѿ��о��ˣ�i-1����bit
%     i
%     u_matrix
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%�����ʼ��
%     if i==1                             %%��ʱ�ǳ�ʼ��u_matrix ��Ȼ���ʲ��ܴﵽ1����ô��һλ��Ȼ�ǹ̶�λ
%         u_matrix(:,1)=zeros(Lo,1);      %%��һλȫ����0
%         %u_matrix(:,L+1)=ones(Lo,1);     %%����λ��ȫ����1
%         continue;
%     end
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
     %%i��ʾ��ǰҪ�ж������еĵ�iλ flag��ʾҪ�жϵ�ǰ�ĵ�flag����Ϣ
    if z(i)==0                          %%���ڹ̶�λ�� �ڸ�λ��Ϊ0�ĸ��ʸ�ֵ1
        u_matrix(:,i)=zeros(Lo,1);
    else                                %%��������λ  Ҫ��������� 1.��Ҫȫ������·�� 2.ѡȡ����·��
        flag=flag+1;                    %%��ʱ��flag��ʾ�����жϵڼ�����Ϣλ
%         flag
        
        if flag<=Flag                   %%��ʱҪ��������·�� �������
             u_matrix(:,i)=reserve_all(:,flag);
             if flag==Flag
                 for j=1:Lo                 %%jѭ����ʾ����Lo���봮
                     u_matrix(j,L+1)=channel_transfer(L,i,y0,u_matrix(j,1:i-1),u_matrix(j,i));
                 end
             end
%              u_matrix
             
        else                            %%��ʱҪѡȡ����·��
            
            for j=1:Lo                  %%jѭ����ʾ����Lo���봮
                u_temp(2*j-1,2)=channel_transfer(L,i,y0,u_matrix(j,1:i-1),1);    
                u_temp(2*j,2)  =channel_transfer(L,i,y0,u_matrix(j,1:i-1),0);                                        %%�����м������ڵ�ǰ�����·ֱ���һλȡ0��1����·������
                [vals,inds]    =sort(u_temp(:,2),'descend');                                                         %%������ֵ��������
                temp=[];
                for k=1:Lo                                                                                           %%%���ѭ�����ڴ�2Lo������ֵ��ѡȡ����
                    if  mod(inds(k),2)==1                                                                            %%��������ֵ��ʾ���һλ��1��tempcode���һλ�Ǹ�·���ĸ���
                        tempcode=[u_matrix((inds(k)+1)/2,1:i-1),1,vals(k)];
                        temp=[temp;tempcode];
                    else                                                                                             %%ż��������ʾ���һλ��0 ��tempcode���һλ�Ǹ�·���ĸ���
                        tempcode=[u_matrix(inds(k)/2,1:i-1),0,vals(k)];
                        temp=[temp;tempcode];
                    end   
                end                       %%end of k_cycle
            end                           %%end of j_cycle
%             temp
            u_matrix(:,1:i)=temp(:,1:i);
            u_matrix(:,L+1)=temp(:,i+1);
            
        end                               %%end of if 
        
        if mod(flag,free_length./layer_number)==0      %%���жϵĵ�ǰλ�������ǲ�ı߽�ʱ ����CRCУ�� ��ѡ�������ʵ����
            no_of_rank=flag./(free_length./layer_number);           %%no_of_rank������ŵ�ǰ�Ĳ���
            for ii=1:Lo
                [values,index]=sort(u_matrix(:,L+1),'descend');
                err=cyclic_redundancy_decode( u_matrix(index(ii),free_position((no_of_rank-1).*free_length./layer_number+1:no_of_rank.*free_length./layer_number)),ccitt );
                if err == 0               %%У��ʽͨ��CRC
                    for jj=1:Lo
                        u_matrix(jj,free_position((no_of_rank-1).*free_length./layer_number+1:no_of_rank.*free_length./layer_number))=u_matrix(index(ii),free_position((no_of_rank-1).*free_length./layer_number+1:no_of_rank.*free_length./layer_number));
                    end
                    u_matrix(:,L+1)=ones(Lo,1);
                    break;
                else                     %%��ʱerr=1 ��ʽû��ͨ��CRC 
                    continue;
                end
            end
        end
    end                                   %%end of if
    
end                                       %%end of i_cycle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%����Lo��·����ѡȡ����һ�����

y=u_matrix(1,1:L)';

end