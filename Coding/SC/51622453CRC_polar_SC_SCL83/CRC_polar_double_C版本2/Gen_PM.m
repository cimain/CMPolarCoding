% PM_i_1 i-1ʱ��·������ֵ
% N
% i
% y0
% u_i_1 ǰi-1ʱ�̵��о�ֵ
% ui    iʱ�̵��о�����ֵ
% sigma ������׼��
function PM=Gen_PM(PM_i_1,N,i,y0,u_i_1,ui,z,sigma)

f=Gen_f(N,i,y0,u_i_1,sigma);
% f=1.1;
% if(z(i)==0 && ui==1) 
%     PM=-inf;
% else
%     if ( z(i)==1 && 1-2*ui==sign(f) )
%         PM=PM_i_1;
%     else
%         PM=PM_i_1-abs(f);    
%     end
% end
if(z(i)==0 && ui==1) 
    PM=-inf;
else
    if ( (z(i)==1 || ui==0) && 1-2*ui==sign(f) )
        PM=PM_i_1;
    else
        PM=PM_i_1-abs(f);    
    end
end