%Standard Form
function [Model] = StandardForm(Model)
%perform transformation to convert non-standard state equation to standard form
Model.x = Model.x-Model.E*Model.u;
Model.B = Model.A*Model.E+Model.B;
Model.D = Model.C*Model.E+Model.D;
end