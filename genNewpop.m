function chroms = genNewpop(num_op,num_job,total_op_num,sizepop,operation_machine,operation_time,genprobMatrix,bestprobMatrix,weight)
% ͨ�����»��ƣ�����pop-pop&EA������
genprobMatrix=cumsum(genprobMatrix,2);
bestprobMatrix=cumsum(bestprobMatrix,2);
cum_numop=cumsum([0 num_op(1:end-1)]);
cum_numop=cum_numop-cum_numop(1);

a=1;
for j=1:num_job
    b=num_op(j);
    temp(1,a:(a+b-1))=j;
    a=a+b;
end   
% Ⱦɫ���һ��Ϊ����ţ��ڶ���Ϊ��Ӧ�ӹ�������������Ϊ��Ӧ�ӹ�ʱ��
chroms=zeros(sizepop,total_op_num*3);
for i=1:sizepop
    %�������α�����
    ms=rand(total_op_num,1);
    % ������ɹ�����
    rt=randperm(total_op_num);
    chroms(i,1:total_op_num)=temp(rt);
    % ����PM�������ɻ����룬����¼��Ӧ�Ĺ�ʱ
    if rand<weight
        selectvalue=bestprobMatrix;
    else
        selectvalue=genprobMatrix;
    end
    for j=1:num_job
        job=find(chroms(i,1:total_op_num)==j);
        for k=1:length(job)
            machines=operation_machine{j}{k};  % ����j����k����ѡ��Ļ�����
            times=operation_time{j}{k};  % ��Ӧ�Ĺ�ʱ��
            %�������̶�ѡ�����
            flag=0;
            for pm_mac=1:length(machines)
               
                if( ms(cum_numop(j)+k) < selectvalue(cum_numop(j)+k,machines(pm_mac)))
                    ind=pm_mac;
                    flag=1;
                    break;
                end
            end
            if(flag==0)
                ind=pm_mac;
            end
            chroms(i,total_op_num+job(k))=machines(ind);
            chroms(i,total_op_num*2+job(k))=times(ind);
        end
    end
end
end

