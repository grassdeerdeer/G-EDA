function average=main(MAXGEN,sizepop,child_num,savepath,savecount,loadpath)
    

%% ��������
% �ӹ����ݰ����ӹ�ʱ�䣬�ӹ���������������������Ȩ�أ�����������������Ӧ�Ĺ�����
load test_fjsp operation_time operation_machine num_machine machine_weight num_job num_op

%% ��������
%MAXGEN = 100;               % ����������
Pc = 0.77;                   % ������
Pm = 0.1;                   % ������
%sizepop =100;              % ������Ŀ
EA=0.7;                     %ѡ��EA����Ѹ�������������ģ��
weight=0.3;                 %ѡ��ȫ�����ŵĸ���
trace = zeros(2,MAXGEN);

%% ===========================��Ⱥ��ʼ��============================
total_op_num=sum(num_op);

chroms=initialization(num_op,num_job,total_op_num,sizepop,operation_machine,operation_time);
M=3;  %Ŀ�꺯������
V=length(chroms(1,:));

%child_num=3; %��������Ⱥ������
child_pop=cell(1,child_num+1);
count=1;
for i=1:child_num
    if(count+floor(sizepop/child_num)>sizepop)
        child_pop{i}=chroms(count:sizepop,:);
    else
        child_pop{i}=chroms(count:count+floor(sizepop/child_num),:);
    end
    count=count+floor(sizepop/child_num);
end
child_pop{child_num+1}=chroms;

fnsave= sprintf("%s%d%s",loadpath,savecount,'.mat');
chroms=load(fnsave,'chromosome');
for i=1:child_num+1
   child_pop{i}=chroms.chromosome{i}(:,1:total_op_num*3);
end
    
%% ===========�����������Ⱥÿ��Ŀ�����Ӧֵ������������������==========


POF_laten=cell(1,child_num+1);
chromosome=cell(1,child_num+1);
new_chromosome=cell(1,child_num+1);
 for i=1:child_num+1
        POF_laten{i} = zeros(size(child_pop{i},1), 3);
        [POF_laten{i}(:,1),POF_laten{i}(:,2),POF_laten{i}(:,3)]=fitness(child_pop{i},num_machine,num_job,num_op);
        chromosome{i} = [child_pop{i} POF_laten{i}];
        chromosome{i} = non_domination_sort_mod(chromosome{i},M,V); %Ŀ�꺯��M��Ⱦɫ�峤��V       
end

%% ============================��������=============================
for gen=1:MAXGEN
    fprintf('��ǰ����������'),disp(gen)
    probMatrix=cell(1,child_num+1);
    probMatrix{child_num+1}=zeros(total_op_num,num_machine);
     for i=1:child_num
        % ��������ģ��
        probMatrix{i}=EDA(total_op_num,num_machine,num_op,num_job,chromosome{i}(1:ceil(size(chromosome{i},1)*EA),:));
        probMatrix{child_num+1}=probMatrix{child_num+1}+probMatrix{i};
     end
     probMatrix{child_num+1}=probMatrix{child_num+1}./sum(probMatrix{child_num+1},2);
     for i=1:child_num

         %Ӧ�ø��»��ƣ����µĸ����滻���ĸ���
        %new_chromosome{i}=genNewpop(num_op,num_job,total_op_num,size(child_pop{i},1),operation_machine,operation_time,probMatrix{i},probMatrix{child_num},weight);
        chromosome{i}(ceil(size(child_pop{i},1)*EA)+1:size(child_pop{i},1),1:total_op_num*3)=genNewpop(num_op,num_job,total_op_num,size(child_pop{i},1)-ceil(size(child_pop{i},1)*EA),operation_machine,operation_time,probMatrix{i},probMatrix{child_num+1},weight);
         % �������
       new_chromosome{i}=crossover(chromosome{i}(:,1:total_op_num*3),Pc,total_op_num,num_job,num_op);
         
        % �������
       new_chromosome{i}=mutation(new_chromosome{i}(:,1:total_op_num*3),total_op_num,Pm,num_machine,num_job,num_op,operation_machine,operation_time);
     end
       
    for i=1:child_num
        temp=[chromosome{i}(:,1:total_op_num*3);new_chromosome{i}(:,1:total_op_num*3)];
        POF_laten_temp = zeros(size(temp,1), 3);
        [POF_laten_temp(:,1),POF_laten_temp(:,2),POF_laten_temp(:,3)]=fitness(temp,num_machine,num_job,num_op);
        temp = [temp POF_laten_temp];
        %ȥ��
        temp=fill_pop(temp,size(temp,1),num_op,num_job,total_op_num,operation_machine,operation_time,num_machine);
        temp = non_domination_sort_mod(temp,M,V); %Ŀ�꺯��M��Ⱦɫ�峤��V    
        chromosome{i} = temp(1:size(chromosome{i},1),:); %Ŀ�꺯��M��Ⱦɫ�峤��V       
    end
    child_pop{child_num+1}=[];
    for i=1:child_num
        child_pop{child_num+1}=[child_pop{child_num+1};chromosome{i}(:,1:total_op_num*3)];
    end
    POF_laten{child_num+1}=zeros(size(child_pop{child_num+1},1), 3);
    [POF_laten{child_num+1}(:,1),POF_laten{child_num+1}(:,2),POF_laten{child_num+1}(:,3)]=fitness(child_pop{child_num+1},num_machine,num_job,num_op);
    chromosome{child_num+1}= [child_pop{child_num+1} POF_laten{child_num+1}];
    chromosome{child_num+1} = non_domination_sort_mod(chromosome{child_num+1},M,V); %Ŀ�꺯��M��Ⱦɫ�峤��V 
    chromosome{child_num+1} = chromosome{child_num+1}(1:sizepop,:);
    child_pop{child_num+1} = chromosome{child_num+1}(:,1:total_op_num*3);
  
    % ��¼ÿ����������Ӧ����ƽ����Ӧ��
    trace(1, gen)=min(POF_laten{child_num+1}(:,1));       
    trace(2, gen)=mean(POF_laten{child_num+1}(:,1));  
    % ����ȫ��������Ӧ��
    if gen==1 || MinVal>trace(1,gen)
        MinVal=trace(1,gen);
    end
end

%% ============================������=============================
%% ���������Ӧ��
%MinVal= min(chromosome{child_num+1}(:,total_op_num*3+1));
fprintf('������Ӧ�ȣ�'),disp(MinVal)
fprintf('ƽ����Ӧ�ȣ�'),disp(trace(2, MAXGEN))
average=MinVal;
%% ����ı仯
figure(1)
plot(trace(1,:),'r');
hold on;
plot(trace(2,:),'b');grid;
legend('��ı仯','��Ⱥ��ֵ�ı仯');
fnsave= sprintf("%s%d%s",savepath,savecount,'.png');
saveas(gcf,fnsave);

%% ��ʾ���Ž� 
figure(2)
chrom_best=chromosome{child_num+1}(1,1:total_op_num*3);
draw_gantt(total_op_num,num_machine,num_job,chrom_best);
fnsave= sprintf("%s%d%s",savepath,savecount,'.mat');
save(fnsave,'chromosome');
close all;
end
