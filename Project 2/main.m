clear; 
tic;

mu_A = 3.70e4;
mu_B = 4.80e5;
n_samples = 2e5;  %%样本数目
n_max = 30; %%最多取点数字
life = zeros(1, n_samples);
max_life = 9e4;
mean_life = zeros(1, 30);
reliability = zeros(1, 30);
%节点状态矩阵，用以记录不同切换器状态下节点的状态
state_matrix = [0, 3, 1; 1, 5, 1; 2, 3, 4; 4, 4, 4]; %在函数get_node_state中使用


for n = 5 : n_max
    variable_length;
    mean_life(n) = mean(life);
    
    life_n = life;
    life_n(life_n > 2.5e4) = 1;
    life_n(life_n > 1) = 0;
    reliability(n) = sum(life_n) / n_samples; %计算可靠性
    
    disp(['当前系统节点个数：',num2str(n)]);
    disp(['当前系统平均寿命：',num2str(mean_life(n)),'h']);
    disp(['当前系统可靠性：',num2str(reliability(n) * 100),'%']);
    fprintf('\n');
end

[a, b] = max(mean_life);
disp(['系统平均寿命最长为:',num2str(a),'小时，','包含了',num2str(b),'个节点']);
[c, d] = max(reliability);
disp(['系统可靠性最大为:',num2str(c * 100),'%，','包含了',num2str(d),'个节点']);

eval_avail;

plot_life_figure;
%plot_reli_figure;