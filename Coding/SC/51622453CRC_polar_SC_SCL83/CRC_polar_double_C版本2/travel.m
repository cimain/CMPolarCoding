%%�ú������ڹ��쵱��Ҫ����ȫ��·����ʱ���·������
%%����Ϊ����·������


function y=travel(L)

logL=log2(L);
if logL==1
    y=[0;1];
else
    above=[zeros(L/2,1),travel(L/2)];
    below=[ones(L/2,1),travel(L/2)];
    y=[above;below];
end

end