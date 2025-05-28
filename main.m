function average=main(MAXGEN,sizepop,child_num,savepath,savecount,loadpath)
    

%% 下载数据
% 加工数据包括加工时间，加工机器，机器数，各机器权重，工件数，各工件对应的工序数
load test_fjsp operation_time operation_machine num_machine machine_weight num_job num_op

%% 基本参数
%MAXGEN = 100;               % 最大迭代次数
Pc = 0.77;                   % 交叉率
Pm = 0.1;                   % 变异率
%sizepop =100;              % 个体数目
EA=0.7;                     %选择EA个最佳个体来构建概率模型
weight=0.3;                 %选择全局最优的概率
trace = zeros(2,MAXGEN);

%% ===========================种群初始化============================
total_op_num=sum(num_op);

chroms=initialization(num_op,num_job,total_op_num,sizepop,operation_machine,operation_time);
M=3;  %目标函数数量
V=length(chroms(1,:));

%child_num=3; %划分子种群的数量
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
    
%% ===========计算各个子种群每个目标的适应值，并进行帕累托排序==========


POF_laten=cell(1,child_num+1);
chromosome=cell(1,child_num+1);
new_chromosome=cell(1,child_num+1);
 for i=1:child_num+1
        POF_laten{i} = zeros(size(child_pop{i},1), 3);
        [POF_laten{i}(:,1),POF_laten{i}(:,2),POF_laten{i}(:,3)]=fitness(child_pop{i},num_machine,num_job,num_op);
        chromosome{i} = [child_pop{i} POF_laten{i}];
        chromosome{i} = non_domination_sort_mod(chromosome{i},M,V); %目标函数M，染色体长度V       
end

%% ============================迭代过程=============================
for gen=1:MAXGEN
    fprintf('当前迭代次数：'),disp(gen)
    probMatrix=cell(1,child_num+1);
    probMatrix{child_num+1}=zeros(total_op_num,num_machine);
     for i=1:child_num
        % 构建概率模型
        probMatrix{i}=EDA(total_op_num,num_machine,num_op,num_job,chromosome{i}(1:ceil(size(chromosome{i},1)*EA),:));
        probMatrix{child_num+1}=probMatrix{child_num+1}+probMatrix{i};
     end
     probMatrix{child_num+1}=probMatrix{child_num+1}./sum(probMatrix{child_num+1},2);
     for i=1:child_num

         %应用更新机制，用新的个体替换最差的个体
        %new_chromosome{i}=genNewpop(num_op,num_job,total_op_num,size(child_pop{i},1),operation_machine,operation_time,probMatrix{i},probMatrix{child_num},weight);
        chromosome{i}(ceil(size(child_pop{i},1)*EA)+1:size(child_pop{i},1),1:total_op_num*3)=genNewpop(num_op,num_job,total_op_num,size(child_pop{i},1)-ceil(size(child_pop{i},1)*EA),operation_machine,operation_time,probMatrix{i},probMatrix{child_num+1},weight);
         % 交叉操作
       new_chromosome{i}=crossover(chromosome{i}(:,1:total_op_num*3),Pc,total_op_num,num_job,num_op);
         
        % 变异操作
       new_chromosome{i}=mutation(new_chromosome{i}(:,1:total_op_num*3),total_op_num,Pm,num_machine,num_job,num_op,operation_machine,operation_time);
     end
       
    for i=1:child_num
        temp=[chromosome{i}(:,1:total_op_num*3);new_chromosome{i}(:,1:total_op_num*3)];
        POF_laten_temp = zeros(size(temp,1), 3);
        [POF_laten_temp(:,1),POF_laten_temp(:,2),POF_laten_temp(:,3)]=fitness(temp,num_machine,num_job,num_op);
        temp = [temp POF_laten_temp];
        %去重
        temp=fill_pop(temp,size(temp,1),num_op,num_job,total_op_num,operation_machine,operation_time,num_machine);
        temp = non_domination_sort_mod(temp,M,V); %目标函数M，染色体长度V    
        chromosome{i} = temp(1:size(chromosome{i},1),:); %目标函数M，染色体长度V       
    end
    child_pop{child_num+1}=[];
    for i=1:child_num
        child_pop{child_num+1}=[child_pop{child_num+1};chromosome{i}(:,1:total_op_num*3)];
    end
    POF_laten{child_num+1}=zeros(size(child_pop{child_num+1},1), 3);
    [POF_laten{child_num+1}(:,1),POF_laten{child_num+1}(:,2),POF_laten{child_num+1}(:,3)]=fitness(child_pop{child_num+1},num_machine,num_job,num_op);
    chromosome{child_num+1}= [child_pop{child_num+1} POF_laten{child_num+1}];
    chromosome{child_num+1} = non_domination_sort_mod(chromosome{child_num+1},M,V); %目标函数M，染色体长度V 
    chromosome{child_num+1} = chromosome{child_num+1}(1:sizepop,:);
    child_pop{child_num+1} = chromosome{child_num+1}(:,1:total_op_num*3);
  
    % 记录每代的最优适应度与平均适应度
    trace(1, gen)=min(POF_laten{child_num+1}(:,1));       
    trace(2, gen)=mean(POF_laten{child_num+1}(:,1));  
    % 更新全局最优适应度
    if gen==1 || MinVal>trace(1,gen)
        MinVal=trace(1,gen);
    end
end

%% ============================输出结果=============================
%% 输出最优适应度
%MinVal= min(chromosome{child_num+1}(:,total_op_num*3+1));
fprintf('最优适应度：'),disp(MinVal)
fprintf('平均适应度：'),disp(trace(2, MAXGEN))
average=MinVal;
%% 描绘解的变化
figure(1)
plot(trace(1,:),'r');
hold on;
plot(trace(2,:),'b');grid;
legend('解的变化','种群均值的变化');
fnsave= sprintf("%s%d%s",savepath,savecount,'.png');
saveas(gcf,fnsave);

%% 显示最优解 
figure(2)
chrom_best=chromosome{child_num+1}(1,1:total_op_num*3);
draw_gantt(total_op_num,num_machine,num_job,chrom_best);
fnsave= sprintf("%s%d%s",savepath,savecount,'.mat');
save(fnsave,'chromosome');
close all;
end
