function [Model] = BuildNormalTree(LG,Model)
    [n,m] = size(Model.In);
    p = 2^((length(find(LG.Type==3))+length(find(LG.Type==4)))/2); %number of possible combinations
    
    %initialization of arrays and values
    Tree = zeros(n,m,p);
    Branches = zeros(1,m,p);
    CoTree = zeros(n,m,p);
    Links = zeros(1,m,p);
    L = 1; % initialize L to 1
    z = 1; % initialize z to 1
    
    for i = [1,8,2,3,4,5,6,7] %1:7 %go through all element types
        if i == 3 || i == 4
            find_type = find(LG.Type==i);
            for j = find_type(1:2:end)
                if i == 3 % if a Transformer
                    index = 1;
                    for M = 1:z
                        for k= index:index + (p/(2^L)-1) %index:index + (p/(L*2)-1)
                            Tree(:,j,k) = Model.In(:,j);
                            Branches(1,j,k) = i;
                            CoTree(:,j+1,k) = Model.In(:,j+1);
                            Links(1,j+1,k) = i;
                        end
                        for k= index + (p/(2^L)):index + ((2*(p/(2^L)))-1) %index + (p/(L*2)):index + (p/(L*2)+p/(L*2)-1)
                            Tree(:,j+1,k) = Model.In(:,j+1);
                            Branches(1,j+1,k) = i;
                            CoTree(:,j,k) = Model.In(:,j);
                            Links(1,j,k) = i;
                        end
                        index = index + (2*(p/(2^L))); %index + (p/(L*2)+p/(L*2));
                    end
                        L = L+1;
                        z = z*2;

                elseif i == 4 % if a Gyrator
                    index = 1;
                    for M = 1:z
                        for k=index:index + (p/(2^L)-1)
                            Tree(:,j,k) = Model.In(:,j);
                            Branches(1,j,k) = i;
                            Tree(:,j+1,k) = Model.In(:,j+1);
                            Branches(1,j+1,k) = i;
                        end
                        for k=index + (p/(2^L)):index + ((2*(p/(2^L)))-1)
                            CoTree(:,j+1,k) = Model.In(:,j+1);
                            Links(1,j+1,k) = i;
                            CoTree(:,j,k) = Model.In(:,j);
                            Links(1,j,k) = i;
                        end
                        index = index + (2*(p/(2^L)));
                    end
                        L = L+1;
                        z = z*2;
                end
            end
        else
            find_type = find(LG.Type==i);
            for j = find_type
                if i == 1 %if A-Type Source Element
                    for k = 1:p
                        Tree(:,j,k) = Model.In(:,j);
                        Branches(1,j,k) = i;
                    end

                elseif i == 2 || i == 5 || i == 6 || i == 7 % if an A-, D-, T-Type Element, a Through Variable Source
                    for k = 1:p
                        Tree_temp = Tree(:,:,k); %take tree contructed so far
                        Tree_temp(:,j) = Model.In(:,j); %add element to it
                        [~,~,n_cycles] = CountCycles(Tree_temp,1,1,1,0); %check for cycles
                        if n_cycles == 0 %if these was no cycles
                            Tree(:,:,k) = Tree_temp; %make element part of tree
                            Branches(1,j,k) = i;
                        else %if cycle created
                            CoTree(:,j,k) = Tree_temp(:,j); %make element part of cotree
                            Tree_temp = Tree(:,:,k); %#ok<NASGU> %reset temp tree to remove element
                            Links(1,j,k) = i;
                        end
                    end
                end
            end
        end
    end
    
    % Testing each permutation for existance of a cycle
    n_ttype = zeros(1,p); % initialize matrix for counting the number of T-Type elements in each permutation
    n_branches = zeros(1,p);
    noloop = zeros(1,p); % initialize loops matrix
    all_nodes = zeros(1,p); % initialize number of Branches matrix (Tree must have branches = nodes-1 for all nodes to be connected)
    for k = 1:p %cycle through each permutation
        n_ttype(k) = sum(Branches(:,:,k) == 6); %count number of T-Type element in each permutation
        n_branches(k) = nnz(Branches(:,:,k)) == n-1; % check if # of branches = n-1
        [~,~,n_cycles,all_nodes_con] = CountCycles(Tree(:,:,k),1,1,1,0); %test for cycles
        if n_cycles == 0 %if no cycles exist
            noloop(k) = 1; %set corresponding value to 1
        else %if cycle exists
            %keep value as zero
        end
        all_nodes(k) = all_nodes_con;
    end
    cond = n_branches.*noloop.*all_nodes; %find whether both the no loop and required # of branches conditions have been met (both true = 1, one or both false = 0)
    
    %find permutation which has both no loops and minumum number of T-Type elements
    last_min = inf;
    for k = 1:p
        if cond(k) == 1 %if all conditions are met
            if n_ttype(k) < last_min %if the current number of T-Types is less than the last
                last_min = n_ttype(k); %set it as last_min
                U = k;
            else
                %do nothing
            end
        else
            %do nothing
        end
    end
    Model.Tree = Tree(:,:,U);
    Model.Branches = Branches(:,:,U);
    Model.CoTree = CoTree(:,:,U);
    Model.Links = Links(:,:,U);
end