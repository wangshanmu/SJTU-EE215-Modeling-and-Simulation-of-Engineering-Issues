
fprintf('cell=%d\n',cell);
cell_record(cell_record_ptr) = cell;
cell_record_ptr=cell_record_ptr+1;

%%此处将原始代码的，按照cell单纯递增而变化的x,y坐标
%%变换为sorting后可取值范围从小到大变化的格子的x,y坐标
xcell = xx(cell) ; ycell = yy(cell);


goto_nextcell=0;
while((goto_nextcell==0) && (ptrs(I(cell))<=Order))  %%此处需要将ptrs的参数变为I（cell),
                                                     %%为当前xcell,ycell对应的在原矩阵中的位置   
    if cur_mark(xcell,ycell,ptrs(I(cell)))==0
        ptrs(I(cell))=ptrs(I(cell))+1;
    else
        next_mark=refresh_mark(groups,cur_mark,xcell,ycell,ptrs(I(cell)));
        
        %%每填入一个数据后检测是否有某一个格子只剩一种可能，如果有，refresh current mark
        %%具体思路与处理init_data时类似，但此处要注意cur_mark已经变为next_mark
        
        for i=1:Order  %%一开始要排除的1~9
            sum = 0;
            for j=1:Order  %%1~9宫
                for w=1:Order  %%每个宫的1~9个格子
                    b = groups(w, :,j);
                    sum = sum + next_mark(b(1),b(2),i);
                end

                if sum==1
                    for a=1:Order
                        b = groups(a, :,j);
                        if  next_mark(b(1),b(2),i)==1
                            next_mark = refresh_mark(groups,next_mark,b(1),b(2),i);
                        end
                    end
                end
                sum = 0;
            end
        end
        
        
        
        if check_mark(next_mark)==1
            diff_mark(:,:,:,cell)=next_mark-cur_mark;
            cur_mark=next_mark;
            cell=cell+1;
            goto_nextcell=1;

        else
            ptrs(I(cell))=ptrs(I(cell))+1;
        end
    end
end

if goto_nextcell==0
    ptrs(I(cell))=1;
    cell=cell-1;
    if cell~=0
        cur_mark=cur_mark-diff_mark(:,:,:,cell);
        ptrs(I(cell))=ptrs(I(cell))+1;
    end
end