 function [L,I] = get_bec_erasure_rates(n,eps);

e = eps;
for i=1:n

    L=length(e);
    for ii=1:L
        temp(2*ii-1)=2*e(ii)-e(ii).*e(ii);
        temp(2*ii)  =e(ii).*e(ii);
    end
    e=temp;
    
end

 [L I] = sort(e,'descend');
end