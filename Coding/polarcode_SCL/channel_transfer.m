%%�ó������ڼ����ŵ���ת�������е�ֵ���õݹ���
%%�������N���ڵ�ǰ�ݹ�����е��ŵ�������i����N�������ŵ��еĵ�i�����ŵ�
%%W_base�ǻ����ŵ�������д����һ���ӳ��򹩵���
%%uu��ǰi-1����֪�Ĺ��ƣ��ǳ���Ϊi-1��������u�ǵ�i����Ҫ���жϵĹ���
%%W���ŵ���� ת�Ƹ���

%%�������
%%��i=1ʱ������ʱ�涨uuΪ�վ���


function W=channel_transfer(N,i,y,uu,u)



if N==2                      %%N ==2�Ѿ����˵ݹ�����һ��
    if mod(i,2)==1           %%i=1��ʱ�� ��ʽ19
        W=log( 0.5*W_base(u+0,y(1))*W_base(0,y(2))+0.5*W_base(mod(u+1,2),y(1))*W_base(1,y(2)) );
    else                     %%i==2��ʱ�� ��ʽ20
        W=log( 0.5*W_base(mod(uu(1)+u,2),y(1))*W_base(u,y(2)) );
    end
else
    if mod(i,2)==1           %%iΪ����,����Ϊ��ǰ����һλ�ı���
        uoe=mod(uu(1:2:i-1)+uu(2:2:i-1),2);
        ue=uu(2:2:i-1);
        W=log(0.5*exp(channel_transfer(N/2,(i+1)/2,y(1:N/2),uoe,0+u))*exp(channel_transfer(N/2,(i+1)/2,y(N/2+1:N),ue,0)) + 0.5*exp(channel_transfer(N/2,(i+1)/2,y(1:N/2),uoe,mod(1+u,2)))*exp(channel_transfer(N/2,(i+1)/2,y(N/2+1:N),ue,1)));  %%ʽ22
    else                     %%iΪż�� ֻ�е�ǰ����
        uoe=mod(uu(1:2:i-2)+uu(2:2:i-2),2);
        ue=uu(2:2:i-2);
        W=log (0.5*exp(channel_transfer(N/2,i/2,y(1:N/2),uoe,mod(uu(i-1)+u,2)))*exp(channel_transfer(N/2,i/2,y(N/2+1:N),ue,u)));  %%��ʽ23����ǰi-1���о���ǰ���� ����i=1��i=0��ת�Ƹ���
    end
end



end