%输入机器开始时间，结束时间，最大完工时间
%画出一个甘特图
function draw_gantt(total_op_num,num_machine,num_job,code)

[sum_mac_workload,max_mac_workload,max_mac_time,mac_serial,mac_start,mac_end]=decode(total_op_num,num_machine,num_job,code);
nb_mac=num_machine;
axis([0,max_mac_time+5,0,nb_mac+0.5]);%x轴 y轴的范围
set(gca,'xtick',0:2:max_mac_time+5); %x轴的增长幅度
set(gca,'ytick',0:1:nb_mac+0.5); %y轴的增长幅度
xlabel('加工时间','FontName','微软雅黑','Color','b','FontSize',10);
ylabel('机器号','FontName','微软雅黑','Color','b','FontSize',10,'Rotation',90);
title('解码甘特图','fontname','微软雅黑','Color','b','FontSize',16);%图形的标题
color=rand(num_job,3);%生成随机的颜色,并使其方差和大于0.3，防止出现多个相似颜色
while sum(var(color))<0.26
    color=rand(num_job,3);
end
for i=1:nb_mac
    for j=1:length(mac_start{i})
        rec=[mac_start{i}(j),i-0.3,mac_end{i}(j)-mac_start{i}(j),0.6];%设置矩形的位置，[矩形左下顶点的x坐标，y坐标，长度，高度]
        %txt=sprintf('p(%d,%d)=%3.1f',mac_serial{i}(j,1),mac_serial{i}(j,2),mac_end{i}(j)-mac_start{i}(j));%将工序号，加工时间连城字符串
        txt=sprintf('%d',mac_serial{i}(j,1));
        rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor',color(mac_serial{i}(j,1),:));%画每个矩形  
        text(mac_start{i}(j)+0.2,i,txt,'FontWeight','Bold','FontSize',10);%在矩形上标注工序号，加工时间
    end
end