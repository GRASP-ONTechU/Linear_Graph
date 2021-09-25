%% NetworkEquations

function [Model] = NetworkEquations(Model)
    %Create Tree Incidence Matrix
    A_tr = Model.In(2:end,logical(Model.Branches));
    %Create Co-Tree Incidence Matrix
    A_co = Model.In(2:end,logical(Model.Links));
    
    H = A_tr\A_co;
    
    %Slip across- and through-variables for tree and co-tree
    v_tr = Model.Across_Vars(logical(Model.Branches)); %across-variables of tree branches
    v_co = Model.Across_Vars(logical(Model.Links));%across-variables of co-tree links
    f_tr = Model.Through_Vars(logical(Model.Branches)); %through-variables of tree branches
    f_co = Model.Through_Vars(logical(Model.Links)); %through-variables of tree links
    
    Model.cont_eqns = f_tr == -H*f_co; %eye(length(th_tr))*
    Model.comp_eqns = v_co == H'*v_tr; %eye(length(ac_co))*
end
