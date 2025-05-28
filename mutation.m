function chroms = mutation(chroms,total_op_num,Pm,num_machine,num_job,num_op,operation_machine,operation_time)
%% ��Թ����룬��Ʊ��������
for i=1:size(chroms,1)
    if Pm>rand
        chrom=chroms(i,:);
        chrom_best=[];
        Z_best=[];
        tau_min=2;
        tau_max=4;
        for tau=tau_min:tau_max
            % ѡ��tau����ͬλ�á�����ͬ�����Ļ���
            job=randperm(num_job,tau);  % ѡ��Ĺ���
            job_ind=zeros(1,tau);  % ������λ��
            for j=1:tau
                temp=find(chrom(1:total_op_num)==job(j));
                jj=randperm(num_op(job(j)),1);
                job_ind(j)=temp(jj);
            end
        
            % tau��λ�õ�ȫ���У�������
            ind=perms(1:tau);
            % ���۵�ǰ���������Ÿ���
            Z=zeros(1,length(ind));
            chrom_neigh=[];  % �����
            for k=1:length(ind)
                chrom1=chrom;
                chrom1(job_ind)=job(ind(k,:));
                for mac=1:length(job)
                    mac_ind=find(chrom(1:total_op_num)==job(mac));
                    machines=chrom(total_op_num+mac_ind);
                    times=chrom(total_op_num*2+mac_ind);
                    mac_ind=find(chrom1(1:total_op_num)==job(mac));
                    chrom1(total_op_num+mac_ind)=machines;
                    chrom1(total_op_num*2+mac_ind)=times;
                end
                
                chrom_neigh=[chrom_neigh;chrom1];
                [Z(k),~,~] = fitness(chrom1,num_machine,num_job,num_op);
            end
            % ���µ�ǰ��
            [val,ii]=min(Z);
            Z_best=[Z_best,val];
            chrom_best=[chrom_best;chrom_neigh(ii,:)];
        end
        [~,ii]=min(Z_best);
        
        chroms(i,:)=chrom_best(ii,:);
        
    end
end

%% ��Ի����룬��Ƶ������,���滻��ѡ����
for i=1:size(chroms,1)
    if Pm>rand
        chrom=chroms(i,:);
        ind=randperm(total_op_num,1);  % ���ѡ���λ��
        job=chrom(ind);  % ��ѡ����
        job_ind=find(chrom(1:total_op_num)==job);
        op=find(job_ind==ind);  % ��ѡλ�õĹ���
        machines=operation_machine{job}{op};  % ��Ӧ�ļӹ�������
        times=operation_time{job}{op}; %  ��Ӧ�ļӹ�ʱ�伯
        if length(machines)>1
            ii=randperm(length(machines)-1,1);
            ind1=find(machines==chrom(total_op_num+ind));
            machines(ind1)=[];
            times(ind1)=[];
            chrom(total_op_num+ind)=machines(ii);
            chrom(total_op_num*2+ind)=times(ii);
        end
        chroms(i,:)=chrom;
    end
end