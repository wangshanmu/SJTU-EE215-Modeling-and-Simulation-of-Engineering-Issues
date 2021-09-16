%%变步长随机生成切换器由好变坏的时间
t_A = exprnd(mu_A, n_samples, n);
t_B = exprnd(mu_B, n_samples, n);

%%按概率随机生成切换器发生故障后会转换到哪个状态
state_A = rand(n_samples, n); 
state_B = rand(n_samples, n);

state_A(state_A > 0.52) = 3;
state_A(state_A <= 0.26) = 1;
state_A(state_A < 1) = 2;

state_B(state_B <= 0.35) = 1;
state_B(state_B < 1) = 2;


A = zeros(n_samples, n);  %记录当前每个节点内部A切换器的状态
B = zeros(n_samples, n);  %记录当前每个节点内部B切换器的状态
state_nodes = zeros(n_samples, n);    %记录系统内节点的状态

%遍历所有生成的系统，并求得其寿命
for s = 1 : n_samples
    %随机生成转换事件的节点序号、发生时间、转换后状态
    change_A = [1 : n; zeros(1, n); t_A(s, :); state_A(s, :)]; %第二行数据用0表示是A发生了变换
    %记某一列数据依次为x,y,z,w：第x个节点的A(y = 0时）转换器在z时刻变为了状态w
    change_B = [1 : n; ones(1, n); t_B(s, :); state_B(s, :)]; %第二行数据用1表示是B发生了变换
    change_AB = [change_A, change_B]';
    
    change_sort = sortrows(change_AB, 3); %按照时间先后排序
    %记某一行数据依次为x,y,z,w：第x个节点的A(y = 0时）转换器在z时刻变为了状态w
    
    for i = 1 : 2 * n
        change = change_sort(i, :);
        
%PDF中处理方式：如果超过最大限度生命，则设为封顶
        if change(3) >= max_life 
            life(s) = max_life;
            break;
        end


%改进处理方式：只有系统达到“寿命无限”时才设为封顶
%         if (check_infinite(state_nodes(s, :), n))&&(sum(A(s,:)~=0) + sum(B(s,:)~=0) == 2 * n) %判断节点中切换器是否都损坏，且1个MO、n-1个SO
%             life(s) = max_life;
%             break;
%         end
        
        if (change(2) == 0)
            A(s, change(1)) = change(4);
        else
            B(s, change(1)) = change(4);
        end
        
        %由切换器的状态推断节点的状态
        %节点状态：0-Perfect Fuctioning | 1-Slave Only   | 2-Disable/Master
        %节点状态：3-Master Only        | 4-Disable Only | 5-Fail Bus
        state_nodes(s, change(1)) = state_matrix( A(s,change(1))+1 , B(s,change(1))+1 );
        
        state_sys = get_system_state(state_nodes(s, :)); %判断系统状态
        
        if (state_sys == 0)
            life(s) = change(3);
            break;
        end
    end
end