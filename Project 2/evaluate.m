w = 2.5e4;
p_A0 = exp(-w / mu_A);
p_B0 = exp(-w / mu_B);
p_A1 = 0.26 * (1 - p_A0);
p_A2 = 0.26 * (1 - p_A0);
p_A3 = 0.48 * (1 - p_A0);
p_B1 = 0.35 * (1 - p_B0);
p_B2 = 0.65 * (1 - p_B0);
p_PF = p_A0 * p_B0;
p_MO = (p_A0 + p_A2) * p_B1;
p_SO = p_A0 * p_B2 + p_A1 * p_B0 + p_A1 * p_B2;
p_FB = p_A1 * p_B1;
p_DM = p_A2 * p_B0;
p_DN = p_A2 * p_B2 + p_A3;
availability = zeros(1, 20);
for n = 5 : 20 %遍历5~20个点的情况
    nodes = zeros(1, n);
    for PF = 0 : n
        for MO = 0 : (n - PF)
            for SO = 0 : (n - PF - MO)
                for FB = 0 : (n - PF - MO - SO)
                    for DM = 0 : (n - PF - MO - SO - FB) %%遍历所有组合
                        DN = n - PF - MO - SO - FB - DM;
                        if (FB >= 1)||(MO >= 2)||(PF + MO + DM == 0)||(PF + SO + sum(MO + DM > 0) < 5)
                            continue;
                        end
                        if (MO == 1 && PF + SO >= 4)||(MO == 0 && PF >= 1 && PF + SO >= 5)||(MO == 0 && PF == 0 && DM >= 1 && SO >= 4) 
                            availability(n) = availability(n) + nchoosek(n, PF) * nchoosek(n-PF, MO) * nchoosek(n-PF-MO, SO) * ...
                                              nchoosek(n-PF-MO-SO, FB) * nchoosek(n-PF-MO-SO-FB, DM) * ... 
                                              nchoosek(n-PF-MO-SO-FB-DM, DN) * p_PF^(PF) * p_MO^(MO) * ...
                                              p_SO^(SO) * p_FB^(FB) * p_DM^(DM) * p_DN^(DN);
                        else
                            availability(n) = availability(n) + nchoosek(n, PF) * nchoosek(n-PF, MO) * nchoosek(n-PF-MO, SO) * ...
                                              nchoosek(n-PF-MO-SO, FB) * nchoosek(n-PF-MO-SO-FB, DM) * ...
                                              nchoosek(n-PF-MO-SO-FB-DM, DN) * p_PF^(PF) * p_MO^(MO) * ...
                                              p_SO^(SO) * p_FB^(FB) * p_DM^(DM) * p_DN^(DN) * DM / (DM + PF);
                        end
                    end
                end
            end
        end
    end
end