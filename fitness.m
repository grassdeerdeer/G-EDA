function [ max_mac_time,max_mac_workload,sum_mac_workload] = fitness(chroms,num_machine,num_job,num_op)
sizepop=size(chroms,1);
max_mac_time=zeros(1,sizepop); % 最大机器时间值，对应makespan
max_mac_workload=zeros(1,sizepop); %最大负荷机器
sum_mac_workload=zeros(1,sizepop);  %总机器负荷
total_op_num=sum(num_op);  % 总工序数
for k=1:sizepop
    chrom=chroms(k,:);
   [sum_mac_workload(k),max_mac_workload(k),max_mac_time(k),mac_serial,mac_start,mac_end]=decode(total_op_num,num_machine,num_job,chrom);
   
end

