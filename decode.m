%输入：解码
%输出：二维矩阵，行数i对应原编码中第i个元素，第一列对应工件，第二列对应该工件的工艺
function [sum_mac_workload,max_mac_workload,max_mac_time,mac_serial,mac_start,mac_end]=decode(total_op_num,num_machine,num_job,code)


%解码生成工作序列，二维矩阵，第i行为编码的第i个工序，第一列为工件代号，第二列为工序代号
job_serial=[];
for i=1:total_op_num
    job_serial(end+1,:)=[code(i),sum(code(1:i)==code(i))];
end
%解码生成机器序列，元胞组，组内第i个元胞组为机器代号，内部是按照先后顺序的工序向量，工序格式为job_serial格式
%解码生成机器各工序开始、结束时间，工件开始、结束时间
mac_serial=cell(1,num_machine);
job_start=cell(1,num_job);
job_end=cell(1,num_job);
mac_start=cell(1,num_machine);
mac_end=cell(1,num_machine);
for i=1:total_op_num
    %此部分求出第i号工序加工机器:the_mac
    the_mac=code(total_op_num+i);
    the_time=code(total_op_num*2+i);
    
    %求出工件最早可以开始时间（不是真正的开始时间）
    if job_serial(i,2)==1
        job_start{job_serial(i,1)}(1)=[0];
    else
        job_start{job_serial(i,1)}(end+1)=job_end{job_serial(i,1)}(job_serial(i,2)-1);
    end
    
    %将第i个工序插入到机器中加工，如果机器间隔合适，插入间隔中，如不合适，插入到最后一位
    
    [mac_start{the_mac},mac_end{the_mac},job_end_time,insert_pot]=insert_mac(mac_start{the_mac},mac_end{the_mac},job_start{job_serial(i,1)}(job_serial(i,2)),job_end{job_serial(i,1)},the_time);
    mac_serial{the_mac}=[mac_serial{the_mac}(1:insert_pot-1,:);job_serial(i,:);mac_serial{the_mac}(insert_pot:end,:)];

    job_end{job_serial(i,1)}(end+1)=job_end_time;

end
%求出机器最大完工时间
max_mac_time=0;
max_mac_workload=0;
sum_mac_workload=0;
for i=1:num_machine
    if ~isempty(mac_end{i})
        max_mac_time=max(max_mac_time,max(mac_end{i}));
        every_mac_workload=sum(mac_end{i}-mac_start{i});
        max_mac_workload=max(max_mac_workload,every_mac_workload);
        sum_mac_workload=sum_mac_workload+every_mac_workload;
    end
end


