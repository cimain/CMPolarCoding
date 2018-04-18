
function f=Gen_f(N,i,y0,u_i_1,sigma)

if N==1
    f=2*y0/(sigma*sigma);
else
    if mod(i,2)==1
        ue=u_i_1(2:2:i-1);
        uoe=mod(u_i_1(1:2:i-1)+u_i_1(2:2:i-1),2);
        L1=Gen_f(N/2,(i+1)/2,y0(1:N/2),uoe,sigma);
        L2=Gen_f(N/2,(i+1)/2,y0(N/2+1:N),ue,sigma);
        f=sign(L1*L2)*min(abs(L1),abs(L2));
    else
        ue=u_i_1(2:2:i-2);
        uoe=mod(u_i_1(1:2:i-2)+u_i_1(2:2:i-2),2);
        L1=Gen_f(N/2,i/2,y0(1:N/2),uoe,sigma);
        L2=Gen_f(N/2,i/2,y0(N/2+1:N),ue,sigma);
        f=(-1)^(u_i_1(i-1))*L1+L2;
    end
    
end
