%%�ó�������������Ǳ��������ݸ��ŵ���x���ŵ��Ĳ�����
%%���Ϊ�������Ľ�����Ȼ��
%%�˺������BEC�ŵ�

function L=add_noise(x,erasure_probability)

N=length(x);
BigNumber=100;
e = randsrc(N,1,[0 1; 1-erasure_probability erasure_probability]);
L= (1-x).*BigNumber+x.*(1/BigNumber);

L(find(e == 1)) = 1;
 
end