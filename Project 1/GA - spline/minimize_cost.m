%%代码功能：运用遗传算法(GA)解决标定问题
%%学号：519021910418
%%姓名：王山木

clear;
clc;

NP = 250;           %种群规模
p1 = 0.30;          %交叉概率（查阅资料：取0.25~1为宜）
p2 = 0.001;         %变异概率（查阅资料：取0.001~0.1为宜）

N = 200;           %最大迭代次数
train = load('dataform_train-2021.csv'); %读取训练集数据
test = load('dataform_testA-2021.csv'); %读取测试集数据

[m,L] = size(train); %分别获得训练集的行数和列数

f = ceil(rand(NP,L)-0.9); %随机获得NP个初始种群
%0表示不选取点，1表述选取；90％概率为0，10％概率为1

%对生成的初始种群做初步处理
for i = 1:NP    
    while ((sum(f(i,:)) <= 2 )||(sum(f(i,:)) >=10))
        f(i,:) = ceil(rand(1,L)-0.9);
    end
end

%%遗传算法的N轮循环
for k = 1:N
    tic
    cost = zeros(1,NP); %提前生成成本矩阵
    fit = zeros(1,NP); %提前适应度矩阵
    %计算每一个个体的适应度，函数为suitability
    disp(k);
    
    if (k == 100)
        p2 = 0.005;
    end
    
    if (k == 150)
        p2 = 0.01;
    end
        
    for i = 1:NP
        cost(i) = calculate_cost(f(i,:),train,L,m);
    end
    fit = 1./(cost.^2);
 
    maxfit = max(fit);                  %获得最大适应度
    minfit = min(fit);                  %获得最小适应度
    
    location = find(fit == maxfit);     %最优个体的位置
    fbest = f(location(1,1),:);         %历代最优个体
    
    %%轮盘赌决定去留
    sum_fit = sum(fit);
    fitvalue = fit./sum_fit;
    fitvalue = cumsum(fitvalue);    %这里面的第n个元素是初始fitvalue中前n个元素的累加
    change_p = sort(rand(NP,1));    %生成NP*1的矩阵，数值为0~1随机并从小到大排好序，用作概率
    
    fiti = 1;
    newi = 1;
    while newi <= NP
        if(change_p(newi) < fitvalue(fiti)) %说明落在该区域，留下fiti对应的个体
            new_f(newi,:) = f(fiti,:);
            newi = newi + 1; %newi + 1,直至筛选出NP个新的个体
        else  %概率不在fiti指示的个体内，该个体被筛掉
            fiti = fiti + 1;
        end
    end

    %%基因交叉操作
    for i = 1:2:NP                  %隔一个是保证有一条基因能与之交叉
        p = rand;
        if p < p1                   %说明满足了交叉的概率
            q = randi([0,1],1,L);   %随机生成哪一个基因要被换
            for j = 1:L
                if q(j) == 1        %为1则交换该位置i和i+1对应的基因
                    temp = new_f(i+1,j);
                    new_f(i+1,j) = new_f(i,j);
                    new_f(i,j) = temp;
                end
            end
        end
    end
 
    %%基因变异操作
    for m = 1:NP
        for n = 1:L
            r = rand;
            if r < p2                       %说明满足变异概率
                new_f(m,n) = ~new_f(m,n);   %直接取反，设为变异
            end
        end
    end
    
    f = new_f;
    f(1,:) = fbest; %人为保留上一轮最佳个体，防止因意外导致该个体被淘汰/往差的方向变异
    mincost(k) = calculate_cost(fbest,train,L,m);
    disp(mincost(k));
    toc
end

disp('选择方式：')
x = [];
y = [];
for i = 1:L
    if (fbest(i)==1)
        x = [x,train(1,i)];
        y = [y,train(location(1,1)+1,i)];
    end
end
disp(x);
disp('最小成本：')
disp(calculate_cost(fbest,train,L,m))

pp = csape(y,x,'second'); 
% pp = pchip(y,x);  %pchip插值
% pp = makima(y,x); %makima插值

yi = train(location(1,1)+1,:);
xi = ppval(pp,yi); %插值后的估计函数值（温度值）
plot(x,y,'o',xi,yi);
xlabel('温度')
ylabel('电压')
title('三次样条插值拟合曲线')
figure
plot(mincost)
hold on
hold off
xlabel('迭代次数')
ylabel('最小成本')
title('成本进化曲线')

