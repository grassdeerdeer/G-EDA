%% ��Ⱥ��ʼ��
function chroms=initialization(num_op,num_job,total_op_num,sizepop,operation_machine,operation_time)
% ��������빤������Ӧ�Ĺ���
a=1;
for j=1:num_job
    b=num_op(j);
    temp(1,a:(a+b-1))=j;
    a=a+b;
end   
% Ⱦɫ���һ��Ϊ����ţ��ڶ���Ϊ��Ӧ�ӹ�������������Ϊ��Ӧ�ӹ�ʱ��
chroms=zeros(sizepop,total_op_num*3);
for i=1:sizepop
    % ������ɹ�����
    rt=randperm(total_op_num);
    chroms(i,1:total_op_num)=temp(rt);
    % ������ɻ����룬����¼��Ӧ�Ĺ�ʱ
    for j=1:num_job
        job=find(chroms(i,1:total_op_num)==j);
        for k=1:length(job)
            machines=operation_machine{j}{k};  % ����j����k����ѡ��Ļ�����
            times=operation_time{j}{k};  % ��Ӧ�Ĺ�ʱ��
            ind=randperm(length(machines),1);  % ���ѡ��һ������
            chroms(i,total_op_num+job(k))=machines(ind);
            chroms(i,total_op_num*2+job(k))=times(ind);
        end
    end
end