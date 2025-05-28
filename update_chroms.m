function [chroms_u,Z_u,chrom_best] = update_chroms(chroms_o,chroms_n,Z_o,Z_n,sizepop)
ZZ=[Z_o,Z_n];  % �ϲ������Ӧ��
chroms=[chroms_o;chroms_n];  % �ϲ����Ⱦɫ��
[ZZ,ind]=sort(ZZ);  % ����Ӧ�ȴ�С��������
chroms_u=chroms(ind(1:sizepop),:);  % ѡ��ǰsizepop������(������Ⱥ)
Z_u=ZZ(1:sizepop);
chrom_best=chroms_u(1,:);  % ����Ⱦɫ��
end