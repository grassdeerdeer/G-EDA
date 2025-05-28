function input_fjsp(filename)
text = fileread(filename);
newstr=splitlines(text);
newstr(cellfun(@isempty,newstr))=[];
proDesArr=strsplit(newstr{1});
num_job=str2num(proDesArr{1});
num_machine=str2num(proDesArr{2});


num_op=[];
prodesStrArr=cell(1,num_job);
operation_machine=cell(1,num_job);  % 工件j工序m可以选择的机器集
operation_time=cell(1,num_job);
for i=1:num_job
    prodesStrArr{i}=strsplit(newstr{i+1});
    prodesStrArr{i}(cellfun(@isempty,prodesStrArr{i}))=[];
    num_op(i)=str2num(prodesStrArr{i}{1});
    k=2;
    operation_machine{i}=cell(1,num_op(i));
    operation_time{i}=cell(1,num_op(i));
    for j=1:num_op(i) %每个工件的工序数
        selectedMachineCount=str2num(prodesStrArr{i}{k});
        k=k+1;
        for m=1:selectedMachineCount
            operation_machine{i}{j}(m)=str2num(prodesStrArr{i}{k});
            k=k+1;
            operation_time{i}{j}(m)=str2num(prodesStrArr{i}{k});
            k=k+1;
        end
        machines=operation_machine{i}{j};  % 工件j工序k可以选择的机器集
        times=operation_time{i}{j};  % 相应的工时集
        [operation_machine{i}{j} index]=sort(machines);
        operation_time{i}{j}=times(index);
    end       
end
machine_weight=ones(1,num_machine)/num_machine;
save('test_fjsp.mat','num_job','num_op','num_machine','operation_machine','operation_time','machine_weight');
end


    
