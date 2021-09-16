mu_A = 3.70e4;
mu_B = 4.80e5;
n_samples = 1e5;  %%样本数目
n_max = 20; %%最多取点数字
life = zeros(1, n_samples);
max_life = 9e4;
mean_life = zeros(1, 20);
reliability = zeros(1, 20);
%节点状态矩阵，用以记录不同切换器状态下节点的状态
state_matrix = [0, 3, 1; 1, 5, 1; 2, 3, 4; 4, 4, 4]; %在函数get_node_state中使用