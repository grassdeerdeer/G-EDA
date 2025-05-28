clc;clear
filename="G:\code\Matlab\FJSP-instance\input\Kacem1.fjs";
input_fjsp(filename)
MAXGEN=[20,60,100,100,100,100,100];
sizepop=[100,100,100,20,60,100,100];
child_num=[10,10,10,2,6,3,5];
average1=cell(1,7);
for i=1:7
    for j=1:10
        average1{i}(end+1)=main(MAXGEN(i),sizepop(i),child_num(i));
    end
end

filename="G:\code\Matlab\FJSP-instance\input\Kacem2.fjs";
input_fjsp(filename)
MAXGEN=[70
210
350
350
350
350
350
];
sizepop=[350
350
350
70
210
350
350
];
child_num=[10,10,10,2,6,3,5];
average2=cell(1,7);
for i=1:7
    for j=1:10
        average2{i}(end+1)=main(MAXGEN(i),sizepop(i),child_num(i));
    end
end

filename="G:\code\Matlab\FJSP-instance\input\Kacem3.fjs";
input_fjsp(filename)
MAXGEN=[100
300
500
500
500
500
500
];
sizepop=[500
500
500
100
300
500
500
];
child_num=[10,10,10,2,6,3,5];
average3=cell(1,7);
for i=1:7
    for j=1:10
        average3{i}(end+1)=main(MAXGEN(i),sizepop(i),child_num(i));
    end
end

filename="G:\code\Matlab\FJSP-instance\input\Kacem4.fjs";
input_fjsp(filename)
MAXGEN=[150
450
750
750
750
750
750
];
sizepop=[750
750
750
150
450
750
750
];
child_num=[10,10,10,2,6,3,5];
average4=cell(1,7);
for i=1:7
    for j=1:10
        average4{i}(end+1)=main(MAXGEN(i),sizepop(i),child_num(i));
    end
end