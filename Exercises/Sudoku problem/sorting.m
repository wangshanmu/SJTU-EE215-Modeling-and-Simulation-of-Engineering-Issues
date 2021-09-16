init_data;

cur_mark_2 = zeros(Order,Order); %%生成n*n的矩阵，存放格子坐标

sum=0; %%用来计数每一个格子中还可能填入的数字的个数

for i=1:Order  %%计算每个格子可能取值的数字的个数
    for j=1:Order
        for k=1:Order
            sum = sum + cur_mark(i,j,k);
        end
        cur_mark_2(i,j) = sum;
        sum = 0;
    end
end

[S,I]=sort(cur_mark_2(:)); %%将个数按从小到大排序，S为排序后的矩阵，I为对应原矩阵中的位置

yy = ceil(I/Order);  %%获得y坐标,ceil为舍去小数部分后加1
xx = I - (yy-1)*Order; %%获得x坐标

