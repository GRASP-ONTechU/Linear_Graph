function [Model] = LGtheory(LG)
%LGtheory   constructs state-space matrices of Linear Graph models
%   Type is an array defining the element type corresponding to the 
%   respective column of the LG matrix:
%     1 - A-Type Source
%     2 - A-Type Element
%     3 - Tranformer
%     4 - Gyrator
%     5 - D-Type Element
%     6 - T-Type Element
%     7 - T-Type Source
%
%   Domain is an array defining the energy domain of elements corresponding 
%   to the respective column of the LG matrix:
%     1 - Electrical
%     2 - Mechanical Translational
%     3 - Mechanical Rotational
%     4 - Hydraulic/Fluid
%     5 - Thermal
%
%   Var_Names is a symbolic array defining the variable names for the
%   elements corresponding to the respective column of the LG Matrix
%
%   y is a symbolic array defining the desired output variables to be
%   solved for by the program
%
%   Eric McCormick, Univeristy of Ontario Institute of Technology, 2019

% Check model for excess state variables and proper construction
CheckModel(LG);

% Convert S and T arrays to Incidence Matrix form
[Model] = IncidenceMatrix(LG);

% Build the Normal Tree using standard method
[Model] = BuildNormalTree(LG,Model);

% Classification of system variables
[Model] = ClassifyVariables(LG,Model);

% Form Elemental/Constitutive Equations
[Model] = ElementalEquations(LG,Model);

%Find the Network (Continuity & Compatibility) Equations using F-cutset method
[Model] = NetworkEquations(Model);

% Use Linear Algebra method to obtain state and ouput matricies 
[Model] = StateSpaceMatrices(LG,Model);

% % Convert from general form (Containing E and F matricies) to standard form
% if ~isempty(Model.E) || ~isempty(Model.F)
%     [Model] = StandardForm(Model); %fixes B, D, and x
% end

end