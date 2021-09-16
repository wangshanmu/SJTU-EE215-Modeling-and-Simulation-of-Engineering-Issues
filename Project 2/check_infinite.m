function state = check_infinite(state_nodes, n)
    %统计系统中处于各状态的节点个数
    SO = sum(state_nodes == 1);
    MO = sum(state_nodes == 3);
    if ((MO == 1)&&(SO == n - 1))
        state = 1;
    else
        state = 0;
    end
end
