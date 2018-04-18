% PM_i_1 i-1时的路径度量值
% N
% i
% y0
% u_i_1 前i-1时刻的判决值
% ui    i时刻的判决输入值
% sigma 噪声标准差
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