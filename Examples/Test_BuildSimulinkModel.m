clc;clear;close all

S = [2 2 3 3 3 4 4];
T = [1 3 1 4 4 1 1];
Type = [1 5 2 5 2 6 7];
Domain = [1 1 1 1 1 1 1];
syms s1 R1 C1 R2 C2 L1 s2
Var_Name = [s1 R1 C1 R2 C2 L1 s2];
%value = ;

sys_name = 'TestModel';
new_system(sys_name);
open_system(sys_name);

%% Set up Model with Ground and Solver

%Initialize Number of Gnd and Solvers to 0
n_Gnd = 0;
n_Solver = 0;
port = cell(1,max([S,T]));
elements = zeros(1,max([S,T]));

% Create Blocks and Define Ports which represent Nodes
for i = 1:length(S)
    %Find Element Domain
    if Domain(i) == 1 %Electrical
        D_name = 'Electrical';
        D_sub1 = D_name;
        D_sub2 = D_name; %used for domain reference
        %Find Element Type
            if Type(i) == 1
                E_name = 'Controlled Voltage Source';
                E_sub = 'Sources';
                Var_Name(i) = ['V_' char(Var_Name(i))];
            elseif Type(i) == 2
                E_name = 'Capacitor';
                E_sub = 'Elements';
            elseif Type(i) == 3
                %E_Name =
            elseif Type(i) == 4
                %E_Name =
            elseif Type(i) == 5
                E_name = 'Resistor';
                E_sub = 'Elements';
            elseif Type(i) == 6
                E_name = 'Inductor';
                E_sub = 'Elements';
            elseif Type(i) == 7
                E_name = 'Controlled Current Source';
                E_sub = 'Sources';
                Var_Name(i) = ['I_' char(Var_Name(i))];
            else
                error('Element types can only be integer values from 1 to 7');
            end
    elseif Domain(i) == 2 %Mech Translational
        D_name = 'Mechanical';
        D_sub1 = 'Translational';
        D_sub2 = [D_name ' ' D_sub1]; %used for domain reference
           %Find Element Type
            if Type(i) == 1
                E_name = 'Ideal Translational Velocity Source';
                E_sub = 'Sources';
                Var_Name(i) = ['v_' char(Var_Name(i))];
            elseif Type(i) == 2
                E_name = 'Mass';
                E_sub = 'Elements';
            elseif Type(i) == 3
                %E_Name =
            elseif Type(i) == 4
                %E_Name =
            elseif Type(i) == 5
                E_name = 'Translational Damper';
                E_sub = 'Elements';
            elseif Type(i) == 6
                E_name = 'Translational Spring';
                E_sub = 'Elements';
            elseif Type(i) == 7
                E_name = 'Ideal Force Source';
                E_sub = 'Sources';
                Var_Name(i) = ['f_' char(Var_Name(i))];
            else
                error('Element types can only be integer values from 1 to 7');
            end
    elseif Domain(i) == 3 %Mech Rotational
        D_name = 'Mechanical';
        D_sub1 = 'Rotational';
        D_sub2 = [D_name ' ' D_sub1]; %used for domain reference
           %Find Element Type
            if Type(i) == 1
                E_name = 'Ideal Angular Velocity Source';
                E_sub = 'Sources';
                Var_Name(i) = ['Omega_' char(Var_Name(i))];
            elseif Type(i) == 2
                E_name = 'Inertia';
                E_sub = 'Elements';
            elseif Type(i) == 3
                %E_Name =
            elseif Type(i) == 4
                %E_Name =
            elseif Type(i) == 5
                E_name = 'Rotational Damper';
                E_sub = 'Elements';
            elseif Type(i) == 6
                E_name = 'Rotational Spring';
                E_sub = 'Elements';
            elseif Type(i) == 7
                E_name = 'Ideal Torque Source';
                E_sub = 'Sources';
                Var_Name(i) = ['T_' char(Var_Name(i))];
            else
                error('Element types can only be integer values from 1 to 7');
            end
    elseif Domain(i) == 4 %Hydraulic/Fluid
        D_name = 'Hydraulic';
        D_sub1 = D_name;
        D_sub2 = D_name; %used for domain reference
           %Find Element Type
            if Type(i) == 1
                E_name = 'Hydraulic Pressure Source';
                E_sub = 'Sources';
                Var_Name(i) = ['P_' char(Var_Name(i))];
            elseif Type(i) == 2
                E_name = 'Fluid Inertia'; %!!!! or is this the T-Type?? !!!!!!!
                E_sub = 'Elements';
            elseif Type(i) == 3
                %E_Name =
            elseif Type(i) == 4
                %E_Name =
            elseif Type(i) == 5
                E_name = 'Linear Hydraulic Resistance';
                E_sub = 'Elements';
            elseif Type(i) == 6
                E_name = 'Inductor'; %Not sure what is right element Type !!!!!!
                E_sub = 'Elements';
            elseif Type(i) == 7
                E_name = 'Hydraulic Flow Rate Source';
                E_sub = 'Sources';
                Var_Name(i) = ['I_' char(Var_Name(i))];
            else
                error('Element types can only be integer values from 1 to 7');
            end
    elseif Domain(i) == 5 %Thermal
        D_name = 'Thermal';
        D_sub1 = D_name;
        D_sub2 = D_name; %used for domain reference
           %Find Element Type
            if Type(i) == 1
                E_name = 'Controlled Temperature Source';
                E_sub = 'Sources';
                Var_Name(i) = ['V_' char(Var_Name(i))];
            elseif Type(i) == 2
                E_name = 'Thermal Mass';
                E_sub = 'Elements';
            elseif Type(i) == 3
                %E_Name =
            elseif Type(i) == 4
                %E_Name =
            elseif Type(i) == 5
                E_name = 'Thermal Resistance';
                E_sub = 'Elements';
            elseif Type(i) == 6
                error('There is no thermal T-Type Element');
            elseif Type(i) == 7
                E_name = 'Controlled Heat Flow Rate Source';
                E_sub = 'Sources';
                Var_Name(i) = ['I_' char(Var_Name(i))];
            else
                error('Element types can only be integer values from 1 to 7');
            end
    else
        error('Domain indices can only be integers from 1 to 5');
    end
    
    %Add Solver and Reference Blocks
    if i == 1 %If first element, create solver and reference ground blocks for it
        add_block(['fl_lib/' D_name '/' D_sub1 ' Elements/' D_sub2 ' Reference'],[sys_name '/Gnd' num2str(n_Gnd)]);
        add_block('nesl_utility/Solver Configuration',[sys_name '/Solver' num2str(n_Solver)]);
        add_line(sys_name,['Solver' num2str(n_Solver) '/RConn1'],['Gnd' num2str(n_Gnd) '/LConn1'],'autorouting','on')
        
        %Assign Solver Port as Node 1
        port_name = ['Solver' num2str(n_Solver) '/RConn1'];
        port{1} = port_name;
        %keep element(1) = 0, no code needed to do this
        
        %Increment Gnd and Solver
        n_Gnd = n_Gnd + 1;
        n_Solver = n_Solver + 1;
    end
    
    %Add Element Block
    if Type(i) == 1 || Type(i) == 7
        add_block(['fl_lib/' D_name '/' D_name ' ' E_sub '/' E_name],[sys_name '/' char(Var_Name(i))]);
    else
        add_block(['fl_lib/' D_name '/' D_sub1 ' ' E_sub '/' E_name],[sys_name '/' char(Var_Name(i))]);
    end
    
    %Assign Node Representing Port
    if Type(i) == 1 %If an across source element
        if isempty(port{S(i)})
            port_name = [char(Var_Name(i)) '/LConn1'];
            port{S(i)} = port_name;
            elements(S(i)) = i;
        end
        %ifelse do nothing
    elseif Type(i) == 3 || Type(i) == 4
            %Might be needed when adding support for TFs and GYs
    else %if any other type of element
        if isempty(port{T(i)})
            port_name = [char(Var_Name(i)) '/RConn1'];
            port{T(i)} = port_name;
            elements(T(i)) = i;
        end
        %ifelse do nothing
    end
end

%Add lines between blocks at appropriate nodes
for i = 1:length(S)
    if ismember(i,elements) %if current element does contain a node port
        if Type(i) == 1 %if an accross source element
            add_line(sys_name,[char(Var_Name(i)) '/RConn2'],char(port{T(i)}),'autorouting','on');
        else %if any other element
            add_line(sys_name,[char(Var_Name(i)) '/LConn1'],char(port{S(i)}),'autorouting','on');
        end
    else
        if Type(i) == 1
            add_line(sys_name,[char(Var_Name(i)) '/RConn2'],char(port{T(i)}),'autorouting','on');
            add_line(sys_name,[char(Var_Name(i)) '/LConn1'],char(port{S(i)}),'autorouting','on');
        elseif Type(i) == 7
            add_line(sys_name,[char(Var_Name(i)) '/RConn2'],char(port{T(i)}),'autorouting','on');
            add_line(sys_name,[char(Var_Name(i)) '/LConn1'],char(port{S(i)}),'autorouting','on');
        elseif Type(i) == 2 && (Domain(i) == 2 || Domain(i) == 3 || Domain(i) == 5)
            add_line(sys_name,[char(Var_Name(i)) '/LConn1'],char(port{S(i)}),'autorouting','on');
        else
            add_line(sys_name,[char(Var_Name(i)) '/LConn1'],char(port{S(i)}),'autorouting','on');
            add_line(sys_name,[char(Var_Name(i)) '/RConn1'],char(port{T(i)}),'autorouting','on');
        end
    end
end

%Simulink.BlockDiagram.routeLine(sys_name)
%Simulink.BlockDiagram.arrangeSystem(sys_name)
