function probMatrix = EDA(total_op_num,num_machine,num_op,num_job,pop)
%计算种群的分布估计概率矩阵
%   此处显示详细说明
probMatrix=zeros(total_op_num,num_machine);
for i=1:size(pop,1)
    num_op_count=0;
    for j=1:num_job
        temp=find(pop(i,1:total_op_num)==j);
        for m=1:length(temp)
           probMatrix(num_op_count+m,pop(i,total_op_num+temp(m)))=probMatrix(num_op_count+m,pop(i,total_op_num+temp(m)))+1;
        end
        num_op_count=num_op_count+num_op(j);
    end
end
probMatrix=probMatrix./sum(probMatrix,2);
end

