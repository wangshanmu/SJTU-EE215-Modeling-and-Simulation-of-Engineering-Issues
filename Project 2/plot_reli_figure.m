x = 5 : n_max;
R = reliability(5 : n_max);
[~, R_mpos] = max(R);
R_mpos = R_mpos + 4;
figure(1),plot(x, R, '.-','markersize', 20);
xlabel('系统节点个数','fontsize', 20)
ylabel('t=25000h时系统的可靠性','fontsize', 20)
title('t=25000h时系统的可靠性与节点个数的关系','fontsize', 20)
grid on
hold on
plot(R_mpos,R(R_mpos-4),'r.','markersize',30);
hold off