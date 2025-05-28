%���룺����
%�������ά��������i��Ӧԭ�����е�i��Ԫ�أ���һ�ж�Ӧ�������ڶ��ж�Ӧ�ù����Ĺ���
function [sum_mac_workload,max_mac_workload,max_mac_time,mac_serial,mac_start,mac_end]=decode(total_op_num,num_machine,num_job,code)


%�������ɹ������У���ά���󣬵�i��Ϊ����ĵ�i�����򣬵�һ��Ϊ�������ţ��ڶ���Ϊ�������
job_serial=[];
for i=1:total_op_num
    job_serial(end+1,:)=[code(i),sum(code(1:i)==code(i))];
end
%�������ɻ������У�Ԫ���飬���ڵ�i��Ԫ����Ϊ�������ţ��ڲ��ǰ����Ⱥ�˳��Ĺ��������������ʽΪjob_serial��ʽ
%�������ɻ���������ʼ������ʱ�䣬������ʼ������ʱ��
mac_serial=cell(1,num_machine);
job_start=cell(1,num_job);
job_end=cell(1,num_job);
mac_start=cell(1,num_machine);
mac_end=cell(1,num_machine);
for i=1:total_op_num
    %�˲��������i�Ź���ӹ�����:the_mac
    the_mac=code(total_op_num+i);
    the_time=code(total_op_num*2+i);
    
    %�������������Կ�ʼʱ�䣨���������Ŀ�ʼʱ�䣩
    if job_serial(i,2)==1
        job_start{job_serial(i,1)}(1)=[0];
    else
        job_start{job_serial(i,1)}(end+1)=job_end{job_serial(i,1)}(job_serial(i,2)-1);
    end
    
    %����i��������뵽�����мӹ����������������ʣ��������У��粻���ʣ����뵽���һλ
    
    [mac_start{the_mac},mac_end{the_mac},job_end_time,insert_pot]=insert_mac(mac_start{the_mac},mac_end{the_mac},job_start{job_serial(i,1)}(job_serial(i,2)),job_end{job_serial(i,1)},the_time);
    mac_serial{the_mac}=[mac_serial{the_mac}(1:insert_pot-1,:);job_serial(i,:);mac_serial{the_mac}(insert_pot:end,:)];

    job_end{job_serial(i,1)}(end+1)=job_end_time;

end
%�����������깤ʱ��
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


