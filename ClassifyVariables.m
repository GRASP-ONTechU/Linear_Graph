%%ClassifyVariables

%This function classifies all variables into their respective categories of
%Primary (Prime), and Secondary (Secon) variables; and State- (x), and
%Input-Vectors (u)

function [Model] = ClassifyVariables(LG,Model)
    [~,m] = size(Model.Tree);
    Model.Across_Vars = sym('A_',[m,1]);
    Model.Through_Vars = sym('T_',[m,1]);
    Model.Prime = sym(zeros(1,m));
    Model.Secon = sym(zeros(1,m));
    Model.Params = sym(zeros(1,m));
    
    %If Domain is unspecified
    if isempty(LG.Domain)
        LG.Domain = zeros(1,length(LG.Type));
    end
    
    % Create all Across- and Through-Variables for each element
    for i = 1:m %cycle through each element
        if LG.Domain(i) == 1 %if Electical domain
            Model.Across_Vars(i) = str2sym(strcat('V_',char(LG.Var_Names(i)),'(t)'));
            Model.Through_Vars(i) = str2sym(strcat('i_',char(LG.Var_Names(i)),'(t)'));
        elseif LG.Domain(i) == 2 %if Mechanical Translational domain
            Model.Across_Vars(i) = str2sym(strcat('v_',char(LG.Var_Names(i)),'(t)'));
            Model.Through_Vars(i) = str2sym(strcat('F_',char(LG.Var_Names(i)),'(t)'));
        elseif LG.Domain(i) == 3 %if Mechanical Rotational domain
            Model.Across_Vars(i) = str2sym(strcat('Omega_',char(LG.Var_Names(i)),'(t)'));
            Model.Through_Vars(i) = str2sym(strcat('Tau_',char(LG.Var_Names(i)),'(t)'));
        elseif LG.Domain(i) == 4 %if Hydraulic/Fluid Domain
            Model.Across_Vars(i) = str2sym(strcat('P_',char(LG.Var_Names(i)),'(t)'));
            Model.Through_Vars(i) = str2sym(strcat('Qf_',char(LG.Var_Names(i)),'(t)'));
        elseif LG.Domain(i) == 5 %if Thermal Domain
            Model.Across_Vars(i) = str2sym(strcat('T_',char(LG.Var_Names(i)),'(t)'));
            Model.Through_Vars(i) = str2sym(strcat('Q_',char(LG.Var_Names(i)),'(t)'));
        else
            Model.Across_Vars(i) = str2sym(strcat('v_',char(LG.Var_Names(i)),'(t)'));
            Model.Through_Vars(i) = str2sym(strcat('f_',char(LG.Var_Names(i)),'(t)'));
        end
        
    % Create Primary and Secondary Variable Arrays
    for i = 1:m %cycle through all elements
        if Model.Branches(i) ~= 0 %if element is a branch
            Model.Prime(i) = Model.Across_Vars(i);
            Model.Secon(i) = Model.Through_Vars(i);
        else %if element is a link
            Model.Prime(i) = Model.Through_Vars(i);
            Model.Secon(i) = Model.Across_Vars(i);
        end
    end
    
    % Create State Variables Array
    j = ([find(Model.Branches == 2),find(Model.Links == 6)]); %Add "Sort" back if needed. find indexes of across-variables on branches and through-variables on links
    Model.x = sym([]);
    for i = 1:length(j)
        if Model.Branches(j(i)) == 2
            Model.x(i) = Model.Across_Vars(j(i));
        elseif Model.Links(j(i)) == 6
            Model.x(i) = Model.Through_Vars(j(i));
        end
    end
    Model.x = Model.x.';
    
    %Check for any state variables
    if isempty(Model.x)
        error('Error: System contains no independent energy storage elements, thus there are no state variables for the system.');
    end
    
    
    % Create Input Variable Array
    j = ([find(Model.Branches == 1),find(Model.Links == 7)]); %Add "Sort" function back if needed
    Model.u = sym([]); %required in case there are no inputs from source elements
    for i = 1:length(j)
        if Model.Branches(j(i)) == 1
            Model.u(i) = Model.Across_Vars(j(i));
        elseif Model.Links(j(i)) == 7
            Model.u(i) = Model.Through_Vars(j(i));
        end
    end
    Model.u = Model.u.';
    
    %Create Parameters Array based on Domain Specified
    for i=1:m
        if (LG.Domain(i) == 2 || LG.Domain(i) == 3) && (LG.Type(i) == 5 || LG.Type(i) == 6) %if either translational or rotatational mechanical doamin AND a D- or T-Type element
            Model.Params(i) = str2sym(['1/' char(LG.Var_Names(i))]);
        else
            Model.Params(i) = LG.Var_Names(i);
        end
    end
    
    end
end