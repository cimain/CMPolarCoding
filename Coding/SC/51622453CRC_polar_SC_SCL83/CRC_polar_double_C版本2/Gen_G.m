function [G,temp_B,temp_F] = Gen_G(N)
    F = [1 0; 1 1];

n = log2(N);

B = @(B_n) kron(eye(2),B_n);
temp_B = eye(2);

for i = 2:n

temp_B = B(temp_B);
N = 2^i;
I = eye(N);

Odd_col = 1 : 2 : N-1;
Even_col = 2 : 2 : N;
R = [I(:,Odd_col) I(:,Even_col)];
temp_B = R*(temp_B);
end

temp_F = 1;
for i = 1 : n
    temp_F = kron(temp_F ,F);
end

G = temp_B*temp_F;