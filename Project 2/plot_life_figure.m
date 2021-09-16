x = 5 : n_max;
R = mean_life(5 : n_max);
[~, R_mpos] = max(R);
R_mpos = R_mpos + 4;
figure(1),plot(x, R, '.-','markersize', 20);
xlabel('系统节点个数','fontsize', 20)
ylabel('系统平均运行寿命/小时','fontsize', 20)
title('系统平均寿命与节点个数的关系','fontsize', 20)
grid on
hold on
plot(R_mpos,R(R_mpos-4),'r.','markersize',30);
hold off