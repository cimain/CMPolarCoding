 
function x = rvsl(y);

N = size(y,1);
if N == 2
    x = y;
else
    x = [y(1:2:N,1);y(2:2:N,1)];
end
        
    
