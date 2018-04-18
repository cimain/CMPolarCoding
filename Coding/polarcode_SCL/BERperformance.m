ber1=[0.803 0.315 0.072 0.011 1.1e-3]
ber2=[0.212 0.048 9.332e-3 1.01e-3 1.05e-4]
ber3=[0.011 3.3e-3 4.4e-4 3.6e-5 4.4e-6]
ber4=[0.078 2e-2 4e-3 5.0e-4 6.9e-5]
ber5=[0.015 5.9e-3 6.2e-4 5.2e-5 5.9e-6]
ber6=[0.112 2.5e-2 5.1e-3 6.3e-4 9.1e-5]
EbNo=1:0.5:3
EBNO=1:0.25:2
semilogy(EbNo,ber1,'-ko',EbNo,ber2,'-k*',EBNO,ber3,'-rx',EBNO,ber4,'-r>',EBNO,ber5,'-b<',EBNO,ber6,'-b+')
legend('SC','SCL(32)','SCL-AD-CRC','SCL-CRC(32)','SCL-AD-CRC(LA)','SCL-CRC(32,LA)')
title('BLER performance')
xlabel('Eb/No');
ylabel('BLER')