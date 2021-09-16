%%代码功能：运用遗传算法(GA)解决背包问题
%%学号：519021910418
%%姓名：王山木

clear;
clc;

NP = 100;           %种群规模
p1 = 0.8;          %交叉概率（查阅资料：取0.25~1为宜）
p2 = 0.05;         %变异概率（查阅资料：取0.001~0.1为宜）

N = 500;           %最大迭代次数
max_size = 95;     %背包最大承受体积
max_weight = 86;   %背包最大承受重量

weight = [11 7 9 6 7 8 5 6 18 2 3 6 2 9 5 4];       %重量（要求取得小于86）
size = [7 4 8 11 20 5 3 9 16 7 8 5 4 4 3 12];       %体积（要求取得小于95）
value = [9 8 7 8 18 7 3 10 19 4 4 11 3 5 4 6];      %价值（要求最大化）

L = length(weight); %表明要选取的总物品的个数，用1代表选取之，0代表不选取

f = randi([0,1],NP,L); %随机获得NP个初始种群
%randi函数：生成NP*L矩阵，元素为0，1中随机一个

%将初始种群中不符合要求的个体去掉
for i = 1:NP    
    while ((f(i,:) * weight' > max_weight)||(f(i,:) * size' > max_size))
        f(i,:) = randi([0,1],1,L);
    end
end

tic

%%遗传算法的N轮循环
for k = 1:N
    %计算每一个个体的适应度，函数为suitability
    for i = 1:NP
        fit(i) = suitability(f(i,:),size,weight,value,max_size,max_weight);
    end
    
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
    maxvalue(k) = maxfit;
    
end

toc
disp('选择方式：')
disp(fbest)
disp('最大价值：')
disp(fbest*value')
disp('占用重量：')
disp(fbest*weight')
disp('占用体积：')
disp(fbest*size')
figure
plot(maxvalue)
xlabel('迭代次数')
ylabel('最大价值')
title('价值进化曲线')

