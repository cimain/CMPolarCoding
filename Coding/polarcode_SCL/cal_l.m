%%���������������û��u��Ϊ�������Ȼ��
%%�����ǲ���y���ϽǱ���½Ǳ꣬�Լ��ŵ����ݹ�������Ȼ�Ⱦ���
function y=cal_l(n1,n2,L)  

channel_LLR=L;
if n2==n1+1
    y=(channel_LLR(n1)*channel_LLR(n2)+1)./(channel_LLR(n1)+channel_LLR(n2));
else
    y=(cal_l(n1,(n1+n2)./2-0.5,channel_LLR)*cal_l((n1+n2)./2+0.5,n2,channel_LLR)+1) ./ ( cal_l(n1,(n1+n2)./2-0.5,channel_LLR)+cal_l((n1+n2)./2+0.5,n2,channel_LLR) );
end


end