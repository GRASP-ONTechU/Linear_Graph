function [Model] = ElementalEquations(LG,Model)
    pass_elems = find(LG.Type ~= 1 & LG.Type ~= 7); %find indexes of passive elements only
    
    for i = [2,6,5,3,4] %cycle through passive element types in specific order
        find_type = find(LG.Type(pass_elems) == i);
        
        if i == 2 %if an A-Type element
            A_Type = sym(zeros(length(find_type),1));
            k = 1;
            for j = find_type
                A = Model.Across_Vars(pass_elems(j));
                T = Model.Through_Vars(pass_elems(j));
                Var = Model.Params(pass_elems(j));
                if Model.Prime(pass_elems(j)) == A
                    A_Type(k) = diff(A) == 1/ Var*T;
                else
                    A_Type(k) = T == Var*diff(A);
                end
                k = k + 1;
            end
        elseif i == 3 %if a Transformer element
            TF_Type = sym(zeros(length(find_type),1));
            k = 1;
            for j = find_type(1:2:end)
                A = Model.Across_Vars(pass_elems(j));
                A2 = Model.Across_Vars(pass_elems(j+1));
                T = Model.Through_Vars(pass_elems(j));
                T2 = Model.Through_Vars(pass_elems(j+1));
                Var = Model.Params(pass_elems(j));
                eqn1 = A2 == A/Var;
                eqn2 = T2 == -Var*T;
                %Rearrange eqn1 and eqn2 for primary variables as required
                if Model.Branches(pass_elems(j)) == 3 %if TFj is branch
                    TF_Type(k) = isolate(eqn1,Model.Prime(pass_elems(j)));
                    TF_Type(k+1) = isolate(eqn2,Model.Prime(pass_elems(j+1)));
                else %if TFj+1 is branch
                    TF_Type(k) = isolate(eqn1,Model.Prime(pass_elems(j+1)));
                    TF_Type(k+1) = isolate(eqn2,Model.Prime(pass_elems(j)));
                end
                k = k + 2;
            end
        elseif i == 4 %if a Gyrator element
            GY_Type = sym(zeros(length(find_type),1));
            k = 1;
            for j = find_type(1:2:end)
                A = Model.Across_Vars(pass_elems(j));
                A2 = Model.Across_Vars(pass_elems(j+1));
                T = Model.Through_Vars(pass_elems(j));
                T2 = Model.Through_Vars(pass_elems(j+1));
                Var = Model.Params(pass_elems(j));
                eqn1 = A2 == -Var*T;
                eqn2 = T2 == A/Var;
                %Rearrange eqn1 and eqn2 for primary variables as required
                if Model.Branches(pass_elems(j)) == 4 %if both branches
                    GY_Type(k) = isolate(eqn1,Model.Prime(pass_elems(j+1)));
                    GY_Type(k+1) = isolate(eqn2,Model.Prime(pass_elems(j)));
                else %if both links
                    GY_Type(k) = isolate(eqn1,Model.Prime(pass_elems(j)));
                    GY_Type(k+1) = isolate(eqn2,Model.Prime(pass_elems(j+1)));
                end
                k = k + 2;
            end
        elseif i == 5 %if a D-Type element
            D_Type = sym(zeros(length(find_type),1));
            k = 1;
            for j = find_type
                A = Model.Across_Vars(pass_elems(j));
                T = Model.Through_Vars(pass_elems(j));
                Var = Model.Params(pass_elems(j));
                eqn = A == Var*T;
                D_Type(k) = isolate(eqn,Model.Prime(pass_elems(j))); % Rearrange Elemental Equations to solve for primary variables
                k = k + 1;
            end
        elseif i == 6 %if a T-Type element
            T_Type = sym(zeros(length(find_type),1));
            k = 1;
            for j = find_type
                A = Model.Across_Vars(pass_elems(j));
                T = Model.Through_Vars(pass_elems(j));
                Var = Model.Params(pass_elems(j));
                if Model.Prime(pass_elems(j)) == T
                    T_Type(k) = diff(T) == 1/Var*A;
                else
                    T_Type(k) = A == Var*diff(T);
                end
                k = k + 1;
            end
        end
    end
    Model.elem_eqns = [A_Type; T_Type; D_Type; TF_Type; GY_Type];% R_Type];
end