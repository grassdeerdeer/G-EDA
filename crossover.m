function [ chroms_new] = crossover(chroms,Pc,total_op_num,num_job,num_op)
size_chrom=size(chroms,1);  % Ⱦɫ����
chroms_new=chroms;
%% ��������Ľ������
for i=1:2:size_chrom-1 
    anotheri=randperm(size_chrom,1);
    if Pc>rand
        % ����Ⱦɫ��
        parent1=chroms(i,:);
        parent2=chroms(anotheri,:);
        Job=randperm(num_job);
        % ����������ֳ���������
        J1=Job(1:round(num_job/2));
        J2=Job(length(J1)+1:end);
        % �Ӵ�Ⱦɫ��
        child1=parent1;
        child2=parent2;
        op_p1=[];
        op_p2=[];
        for j=1:length(J2)
            %�ҳ�����������J2Ƭ�ζ�Ӧ��λ��
            op_p1=[op_p1,find(parent1(1:total_op_num)==J2(j))];
            op_p2=[op_p2,find(parent2(1:total_op_num)==J2(j))];
        end
        op_s1=sort(op_p1);
        op_s2=sort(op_p2);
        % �Ӵ�1����J2Ƭ�εĻ��򣬻������Ӧλ�õĻ��򣬹�ʱ���Ӧλ�õĻ���
        child1(op_s1)=parent2(op_s2);
        child1(total_op_num+op_s1)=parent2(total_op_num+op_s2);
        child1(total_op_num*2+op_s1)=parent2(total_op_num*2+op_s2);
        % �Ӵ�2ͬ��
        child2(op_s2)=parent1(op_s1);
        child2(total_op_num+op_s2)=parent1(total_op_num+op_s1);
        child2(total_op_num*2+op_s2)=parent1(total_op_num*2+op_s1);
        chroms_new(i,:)=child1;
        chroms_new(anotheri,:)=child2;
    end
end
%% ���������Ľ������
for k=1:2:size_chrom-1
    anotherk=randperm(size_chrom,1);
    if Pc>rand
        parent1=chroms_new(k,:);
        parent2=chroms_new(anotherk,:);
        child1=parent1;
        child2=parent2;
        % ���������Ⱦɫ�峤����ȵ�0,1����
        rand0_1=randi([0,1],1,total_op_num);
        count_op=0;
        for n=1:num_job
            ind_0=find(rand0_1(count_op+1:count_op+num_op(n))==0);
            count_op=count_op+num_op(n);
            if ~isempty(ind_0)
                temp1=find(parent1(1:total_op_num)==n);
                temp2=find(parent2(1:total_op_num)==n);
                child1(total_op_num+temp1(ind_0))=parent2(total_op_num+temp2(ind_0));
                child2(total_op_num+temp2(ind_0))=parent1(total_op_num+temp1(ind_0));
                child1(total_op_num*2+temp1(ind_0))=parent2(total_op_num*2+temp2(ind_0));
                child2(total_op_num*2+temp2(ind_0))=parent1(total_op_num*2+temp1(ind_0));
            end
        end
        chroms_new(k,:)=child1;
        chroms_new(anotherk,:)=child2;
    end
end