%function next_mark = finding
for i=1:Order  %%一开始要排除的1~9
    sum = 0;
    for j=1:Order  %%1~9宫
        for w=1:Order  %%每个宫的1~9个格子
            b = groups(w, :,j);
            sum = sum + cur_mark(b(1),b(2),i);
        end

        if sum==1
            for a=1:Order
                b = groups(a, :,j);
                if cur_mark(b(1),b(2),i)==1
                    data = [b(1),b(2),i];
                    next_mark=refresh_mark(groups,cur_mark,b(1),b(2),i);
                end
            end
        end
        sum = 0;
    end
end
%%print_result;