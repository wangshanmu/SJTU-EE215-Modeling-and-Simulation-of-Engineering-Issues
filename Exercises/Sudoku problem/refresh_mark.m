function next_mark = refresh_mark( groups,cur_mark,x,y,ptr )
%MARKING 输入参数含义：组的定义，cur_mark，行坐标，列坐标，数项
% 当行、列坐标指定的格子内填写数项ptr 后，对mark 表格进行更新
Order=size(cur_mark,1);
next_mark =cur_mark;

next_mark(x,y,:)=0; %同一格各项mark 清零
next_mark(x,:,ptr)=0; %同一列同项mark 清零
next_mark(:,y,ptr)=0; %同一行同项mark 清零

%同一组的同项mark 清零
for g=1:size(groups,3)
    found=0;
    for i=1:Order
        if groups(i,:,g)==[x,y]
            found=1;
        end
    end
    if found==1
        for i=1:Order
            next_mark(groups(i,1,g),groups(i,2,g),ptr)=0;
        end
    end
end

next_mark(x,y,ptr)=1;
end
