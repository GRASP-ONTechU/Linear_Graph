%% FindCycles Function

%This recursive function finds and returns the number of cycles found in a
%linear graph (inputted in incidence matrix form) using a variation of the
%depth first search algorithm.

%Initialize as: FindCycles(A,1,1,[0],0)
%Where A is the incedence matrix form of the linear graph

%Currently still a work in progress. The program can find sub-cycles but
%not larger ones (i.e. will find 2 loops when there are 3 or 3 loops when
%there are 5, etc.)

function [LG,V,n_cycles,all_nodes_con] = CountCycles(LG,i,j,V,n_cycles)
    c_elems = find(LG(i,:)); % find which elements(colums) are connected to the starting node
    if isempty(c_elems) %if there are no other elements attached to node (i.e.dead end)
        %do nothing
    else % if there are other elements attached to node (i.e. not dead end)
        for j = c_elems %cycle through the elements
            LG(i,j) = 0; %set searched element to '0' in A matrix to prevent it being searched again
            i_temp = find(LG(:,j)); %find next node the element is connected to and store it as temp
            if ismember(i_temp,V) == 1 %if node has already been visited
                    n_cycles = n_cycles + 1; %increment number of cycles
            else %if node has not already been visited
                    %do not increment number of cycles
            end
                V = [V,i_temp]; %add node to visited list
                [LG,V,n_cycles,~] = CountCycles(LG,i_temp,j,V,n_cycles); %recursive function
        end
    end
    
    %test to see if all nodes were connected (any remaining values in A matrix would mean disconnections)
    if sum(abs(LG(1:end))) == 0 %if all nodes are connected
        all_nodes_con = 1;
    else %if not all nodes are connected
        all_nodes_con = 0;
    end
end

