function outputPop = fill_pop(repeat_pop,need_size,num_op,num_job,total_op_num,operation_machine,operation_time,num_machine)
%去除种群repeat_pop中重复的个体，并将其数量添加到need_size

[outputPop,ia,ic] = unique(repeat_pop(:,total_op_num*3+1:total_op_num*3+3), 'rows');
if size(outputPop,1)<need_size
    temppop=initialization(num_op,num_job,total_op_num,need_size-size(outputPop,1),operation_machine,operation_time);
    POF_laten_temp = zeros(size(temppop,1), 3);
    [POF_laten_temp(:,1),POF_laten_temp(:,2),POF_laten_temp(:,3)]=fitness(temppop,num_machine,num_job,num_op);
        temppop = [temppop POF_laten_temp];
    outputPop=[repeat_pop(ia,:);temppop];
end
end

