%%该函数用于构造当需要保留全部路径的时候的路径矩阵
%%输入为保留路径个数


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