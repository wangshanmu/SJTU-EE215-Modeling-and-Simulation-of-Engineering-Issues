function result = calculate_cost(f,train,L,m)

    ox = -20:1:69;
    x = [];
    y = [];
    for i = 1:L
        if (f(i)==1)
            x = [x,train(1,i)];  %用来标定的点的温度 , 1*sum(f(:))矩阵
            y = [y,train(2:2:m,i)]; %用来标定的点的电压 , m/2*sum(f(:))矩阵
        end
    end
    
    yi = train(2:2:m,:);    %每次插值时对应的自变量（电压值）,数据集中所有电压的值，500*90矩阵
    for z = 1:m/2
        pp = csape(y(z,:),x,'second'); %spline插值
        % pp = pchip(y(z,:),x);  %pchip插值
        % pp = makima(y(z,:),x); %makima插值
        xi(z,:) = ppval(pp,yi(z,:)); %插值后的估计函数值（温度值）
        delta(z,:) = abs(xi(z,:) - ox);
    end
   
    tmp = sumcost(delta);
    cost = sum(tmp,2) + 50 * sum(f(:));
    result = mean(cost);
