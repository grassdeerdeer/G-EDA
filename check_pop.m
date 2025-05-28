function chrom=check_pop(chroms,total_op_num,operation_machine,operation_time)
%检查种群是否正确
for i=1:size(chroms,1)
    chrom=chroms(i,:);
    for k=1:total_op_num
        job=chrom(k);
        job_ind=find(chrom(1:total_op_num)==job);
        jj=find(job_ind==k);  % 所选位置的工序
        machines=operation_machine{job}{jj};  % 对应的加工机器集
        times=operation_time{job}{jj}; %  对应的加工时间集
        time_ind=find(machines==chrom(total_op_num+k));
        if(isempty(time_ind))
            disp(k);
            disp("!!!!!!!该机器无法生产该工序")
        else
            if(times(time_ind)~=chrom(total_op_num*2+k))
                disp(k);
                disp("*****时间错误");
            end
        end
    end
end


end

