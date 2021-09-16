function result = suitability(f,size,weight,value,max_size,max_weight)
%该函数用于计算某一个个体的适应度，输入参数依次为
%f:个体的基因（即选择方式） 
%size:每件物品对应的体积    weight:每件物品对应的重量   value:每件物品对应的价值
%max_size:背包最大承载体积  max_weight:背包最大承受重量
%返回一个结果，结果代表着当前个体对应的适应度（即装入物品总value值）

fit = sum(f.*value);
totalsize = sum(f.*size);
totalweight = f * weight';

if ((totalweight <= max_weight)&&(totalsize <= max_size)) %如果满足容量条件，则适应度就是总价值
    fit = fit;
else
    if (totalsize > max_size) %如果不满足体积条件，则令其适应度变小，方式为减去超出体积部分的20倍
        %操作的目的是使得超出体积限度的个体的适应度大大减小，从而能被更好的筛掉
        %因此此处系数20应根据实际数据进行调整，实测过低时，无法体现出超过容量限制对其的影响之大
        fit = fit - 20 * (totalsize - max_size);
    else %同理
        fit = fit - 20 * (totalweight - max_weight);
    end
end

result = fit;