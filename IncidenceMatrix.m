%% Convert to Incidence Matrix
% Converts arrays representing the sources and targets of edges
% representing a linear graph model to incidence matrix form.
%       S - source array, where the directed edges of the linear graph 
%           model originate from
%       T - Target array, where the directed edges of  the linear graph
%           model end
%
% (C) Eric McCormick, University of Ontario Institute of Technology, 2019

function [Model] = IncidenceMatrix(LG)
    %ensure source and target are same size
    if length(LG.S) ~= length(LG.T)
        error('Error: Invalid input for source and target of linear graph model.');
    end
    
    Model.In = zeros(max(max(LG.S),max(LG.T)),length(LG.S)); %Initialize incidence matrix
    
    for i = 1:length(LG.S) %cycle through each source and target set
        Model.In(LG.S(i),i) = -1;
        Model.In(LG.T(i),i) = 1; 
    end
end