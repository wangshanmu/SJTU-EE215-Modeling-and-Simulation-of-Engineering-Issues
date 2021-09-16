function m = sumcost(t)
m = 1.*(t > 0.5 & t <= 1) + 6.*(t > 1 & t <= 1.5) + 20.*(t > 1.5 & t <= 2) + 10000.*(t > 2 | t < 0);
end