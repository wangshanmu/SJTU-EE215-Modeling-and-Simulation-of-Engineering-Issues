%数独游戏阶数
Order=9;

%mark 表格，下标含义：行坐标，列坐标，数项
cur_mark = ones(Order,Order,Order);

%记录每一步的mark 表格变化
%%第4 维下标代表第几格（从1 到Order*Order 对应从左到右，逐行向下）
diff_mark=zeros(Order,Order,Order,Order*Order);

%数项选择指针
%%下标表示第几格，数值代表下一轮将对应的数项
ptrs=ones(1,Order*Order);

%数格成组（哪几个组成一宫）定义
%%第3 维下标表示第几组（宫）
%%数值含义：行坐标，列坐标
groups=zeros(Order,2,9);
groups(:,:,1)=[1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 3 1; 3 2; 3 3];
groups(:,:,2)=[1 4; 1 5; 1 6; 2 4; 2 5; 2 6; 3 4; 3 5; 3 6];
groups(:,:,3)=[1 7; 1 8; 1 9; 2 7; 2 8; 2 9; 3 7; 3 8; 3 9];
groups(:,:,4)=[6 1; 6 2; 6 3; 4 1; 4 2; 4 3; 5 1; 5 2; 5 3];
groups(:,:,5)=[6 4; 6 5; 6 6; 4 4; 4 5; 4 6; 5 4; 5 5; 5 6];
groups(:,:,6)=[6 7; 6 8; 6 9; 4 7; 4 8; 4 9; 5 7; 5 8; 5 9];
groups(:,:,7)=[7 1; 7 2; 7 3; 8 1; 8 2; 8 3; 9 1; 9 2; 9 3];
groups(:,:,8)=[4 7; 4 8; 4 9; 5 7; 5 8; 5 9; 6 7; 6 8; 6 9];
groups(:,:,9)=[7 7; 7 8; 7 9; 8 7; 8 8; 8 9; 9 7; 9 8; 9 9];


%预先已填的数字
%%数值含义：行坐标，列坐标，数项
  %%init_digit=[1 1 4; 1 6 1; 2 3 2; 2 4 3; 3 2 5; 3 5 3;
  %          4 2 6; 4 5 4; 5 3 5; 5 4 4; 6 1 1; 6 6 5];
init_digit = [1 3 7; 1 7 2; 2 5 3; 3 1 2; 3 4 6; 3 5 9; 3 6 5; 3 9 7; 4 3 5; 
           4 7 7; 5 2 9; 5 3 4; 5 5 8; 5 7 5; 5 8 2; 6 3 8; 6 7 3; 7 1 4;
            7 4 9; 7 5 1; 7 6 7; 7 9 6; 8 5 5; 9 3 3; 9 7 1];
%init_digit = [1 3 7; 1 5 2; 2 4 3; 2 7 4; 3 1 9; 3 5 1; 3 8 2; 4 2 1; 4 6 2;
 %             5 1 7; 5 3 8; 5 7 3; 5 9 9; 6 4 4; 6 8 7; 7 2 5; 7 5 7; 7 9 8;
  %            8 3 3; 8 6 6; 9 5 3; 9 7 1];
  
  
for i=1:size(init_digit,1)
    cur_mark=refresh_mark(groups,cur_mark,init_digit(i,1),init_digit(i,2),init_digit(i,3));
end

%%优化部分二：寻找初始数据填入后已经可以确定的格子的值
for i=1:Order  %%依次排除数字1~9  
    sum = 0;
    for j=1:Order  %%依次排除第1~9宫
        for w=1:Order  %%依次计算第j个宫的1~9个格子
            b = groups(w, :,j);
            sum = sum + cur_mark(b(1),b(2),i);
        end

        if sum==1 %%说明第j个宫只有一个地方可能填入数字i
            for a=1:Order
                b = groups(a, :,j);
                if cur_mark(b(1),b(2),i)==1 %%找到这个位置
                    cur_mark = refresh_mark(groups,cur_mark,b(1),b(2),i); %5刷新cur_mark
                end
            end
        end
        sum = 0;
    end
end
%%print_result;

%记录搜索过程,预开足够多个记录单元
cell_record=zeros(1,1000);
cell_record_ptr=1;
