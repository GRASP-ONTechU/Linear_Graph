% CheckExcess.m
function CheckModel(LG)
%CheckExcess    Checks LG model for direct series A-Type elements and direct
%               parallel T-type elements which would create excess state 
%               variables
%   S       - Source Array of Elements
%   T       - Target Array of Elements
%   Type    - Type Array of Elements
%
%   Eric McCormick, Univeristy of Ontario Institute of Technology, 2019

%Check if Linear Graph model is closed (no loose elements)
for i = unique(LG.T)
    if ~any(LG.S == i) && i ~= 1
        error('Error: Linear Graph model is not closed. Please ensure that model has been constructed correctly.');
    else
        %do nothing
    end
end

%Check for Direct Series A-Type Elements (NEEDED)
for i = find(LG.Type == 2) %cycle through all A-Type elements in system
    source_node = LG.S(i); %find source node of current element
    while true
        nT = find(LG.T == source_node); %find indexes of elements targeting the source node
        nS = find(LG.S == source_node); %find indexes of elements originating from source node
        if length(nT) == 1 && length(nS) == 1 %if there is an element in direct series
            if LG.Type(nT) == 2 %if element type leading into current element is an A-Type
                error('Error: System contains A-Type elements in direct series, causing an excess in state variables.')
            else
                source_node = LG.S(nT); %find source node of current element
            end
        else % if n > 1
            break % do nothing because there are no elements above in direct series
        end
    end
end

%Check for Direct Series D-Type Elements
for i = find(LG.Type == 5) %cycle through all A-Type elements in system
    source_node = LG.S(i); %find source node of current element
    while true
        nT = find(LG.T == source_node); %find indexes of elements targeting the source node
        nS = find(LG.S == source_node); %find indexes of elements originating from source node
        if length(nT) == 1 && length(nS) == 1 %if there is an element in direct series
            if LG.Type(nT) == 5 %if element type leading into current element is an A-Type
                error('Error: System contains D-Type elements in direct series. Model must be simplified')
            else
                source_node = LG.S(nT); %find source node of current element
            end
        else % if n > 1
            break % do nothing because there are no elements above in direct series
        end
    end
end

%Check for Direct Series T-Type Elements
for i = find(LG.Type == 6) %cycle through all A-Type elements in system
    source_node = LG.S(i); %find source node of current element
    while true
        nT = find(LG.T == source_node); %find indexes of elements targeting the source node
        nS = find(LG.S == source_node); %find indexes of elements originating from source node
        if length(nT) == 1 && length(nS) == 1 %if there is an element in direct series
            if LG.Type(nT) == 6 %if element type leading into current element is an A-Type
                error('Error: System contains T-Type elements in direct series. Model must be simplified.')
            else
                source_node = LG.S(nT); %find source node of current element
            end
        else % if n > 1
            break % do nothing because there are no elements above in direct series
        end
    end
end

%Check for Direct Parallel T-Type Elements (NEEDED)
for i = find(LG.Type == 6) %cycle through all T-Type elements in system
    source_node = LG.S(i); %find source node of current element
    target_node = LG.T(i); %find target node of current element
    %Create S_temp and T_temp to ignore the current element
    S_temp = LG.S;
    S_temp(i) = 0;
    T_temp = LG.T;
    T_temp(i) = 0;
    for n = find((S_temp == source_node & T_temp == target_node)|(T_temp == source_node & S_temp == target_node)) %find all elements in direct parallel with current element (either same direction or reversed)
        if LG.Type(n) == 6 %if element type leading into current element is an T-Type
                error('Error: System contains T-Type elements in direct parallel, causing an excess in state variables.')
        end
    end
end

%Check for Direct Parallel A-Type Elements
for i = find(LG.Type == 2) %cycle through all T-Type elements in system
    source_node = LG.S(i); %find source node of current element
    target_node = LG.T(i); %find target node of current element
    %Create S_temp and T_temp to ignore the current element
    S_temp = LG.S;
    S_temp(i) = 0;
    T_temp = LG.T;
    T_temp(i) = 0;
    for n = find((S_temp == source_node & T_temp == target_node)|(T_temp == source_node & S_temp == target_node)) %find all elements in direct parallel with current element (either same direction or reversed)
        if LG.Type(n) == 2 %if element type leading into current element is an T-Type
                error('Error: System contains A-Type elements in direct parallel. Model must be simplified')
        end
    end
end
end