function chrom=check_pop(chroms,total_op_num,operation_machine,operation_time)
%�����Ⱥ�Ƿ���ȷ
for i=1:size(chroms,1)
    chrom=chroms(i,:);
    for k=1:total_op_num
        job=chrom(k);
        job_ind=find(chrom(1:total_op_num)==job);
        jj=find(job_ind==k);  % ��ѡλ�õĹ���
        machines=operation_machine{job}{jj};  % ��Ӧ�ļӹ�������
        times=operation_time{job}{jj}; %  ��Ӧ�ļӹ�ʱ�伯
        time_ind=find(machines==chrom(total_op_num+k));
        if(isempty(time_ind))
            disp(k);
            disp("!!!!!!!�û����޷������ù���")
        else
            if(times(time_ind)~=chrom(total_op_num*2+k))
                disp(k);
                disp("*****ʱ�����");
            end
        end
    end
end


end

