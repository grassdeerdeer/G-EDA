clc;clear
for j=1:4
    filename=sprintf("%s%d%s","G:\code\Matlab\FJSP-instance\input\kacem",j,".fjs");
    input_fjsp(filename);
    load test_fjsp operation_time operation_machine num_machine machine_weight num_job num_op
    MAXGEN=num_machine*num_job;
    sizepop=5*num_machine*num_job;
    child_num=10;
    for i=1:1
        loadpath=sprintf("%s%d%s","G:\code\Matlab\FJSP-instance\input\output\kacem",j,"\");
        savepath=sprintf("%s%d%s","G:\code\Matlab\FJSP-instance\input\output2\kacem",j,"\");
        main(MAXGEN,sizepop,child_num,savepath,i,loadpath);
    end
end
for j=1:10
    if j<=9
        filename=sprintf("%s%d%s","G:\code\Matlab\FJSP-instance\input\Mk0",j,".txt");
    else
        filename=sprintf("%s%d%s","G:\code\Matlab\FJSP-instance\input\Mk",j,".txt");
    end
    input_fjsp(filename);
    load test_fjsp operation_time operation_machine num_machine machine_weight num_job num_op
    MAXGEN=num_machine*num_job;
    sizepop=5*num_machine*num_job;
    child_num=10;
    for i=1:1
        loadpath=sprintf("%s%d%s","G:\code\Matlab\FJSP-instance\input\output\Mk",j,"\");
        savepath=sprintf("%s%d%s","G:\code\Matlab\FJSP-instance\input\output2\Mk",j,"\");
        main(MAXGEN,sizepop,child_num,savepath,i,loadpath);
    end
end









