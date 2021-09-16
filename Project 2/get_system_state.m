%�������ܣ����ݽڵ�״̬�ƶ�ϵͳ��ǰ����״̬
%����0˵��ϵͳʧЧ��1��������
function state = get_system_state(state_nodes)
    %ͳ��ϵͳ�д��ڸ�״̬�Ľڵ����
    PF = sum(state_nodes == 0);
    SO = sum(state_nodes == 1);
    DM = sum(state_nodes == 2);
    MO = sum(state_nodes == 3);
    DN = sum(state_nodes == 4);
    FB = sum(state_nodes == 5);
    
    C1 = (FB >= 1);
    C2 = (MO >= 2);
    C3 = (PF + MO + DM == 0);
    C4 = ((PF + SO + ((MO + DM) > 0)) < 5);
    C5 = (FB == 0);
    C6 = (MO == 1 && PF + SO >= 4);
    C7 = ((MO == 0 && PF >= 1 && PF + SO >= 5)||(MO == 0 && PF == 0 && DM >= 1 && SO >= 4));
    C8_C9 = ((FB + MO == 0)&&((PF >= 1)&&(PF + SO == 4)&&(DM >= 1)));
    
    if (C1||C2||C3||C4)
        state = 0;
    elseif (C5&&(C6||C7)) 
        state = 1;
    elseif (C8_C9)
        state = (rand() <= (DM / (DM + PF)));
    end
end

