%%�ó�������������Ǳ��������ݸ��ŵ���x���ŵ��Ĳ�����
%%���Ϊ�������ľ����ŵ���Ⱦ��x ��y����ʾ
%%����x��һ��������


function y=add_noise_on_y(x,sigma)

N=length(x);
x=2.*x-1;
e = sigma*randn(N,1);

y=x+e;
 
end