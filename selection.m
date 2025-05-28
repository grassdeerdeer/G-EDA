function [chrom1] = selection(chrom,Z,Ps)

size_chrom=round(size(chrom,1)*Ps);  % ��ѡ����н�������Ⱦɫ����
Z=Z+0.00000001;
Z1=1./Z; % ȡ����
P=Z1./sum(Z1);
Q=cumsum(P,2);
chrom1=chrom(1:size_chrom,:);
for i=1:size_chrom
    temp=find(Q>rand,1);
    chrom1(i,:)=chrom(temp,:);
end