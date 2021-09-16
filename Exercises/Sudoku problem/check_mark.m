function output = check_mark( mark )
% 输入参数含义：待检查的mark 表格
% 当发现某一格子的所有数项的mark 均为零，说明此路行不通，输出返回值零

if min(min(sum(mark,3)))==0
    output=0; %某一格mark 全零，已无可选项，提示此路不通
else
    output=1; %提示未发现有行不通的迹象
end

end