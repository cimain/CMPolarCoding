function x=encode(u);

N = size(u,1); 
n = log2(N);
if n==1
    x = [mod(u(1)+u(2),2); u(2)];
else
    u(1:2:N)=mod(u(1:2:N)+u(2:2:N),2);
    u=rvsl(u);
    x1 = encode(u(1:N/2));
    x2 = encode(u(N/2+1:N));
    x = [x1; x2];
end
end




    