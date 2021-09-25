function [Model] = StateSpaceMatrices(LG,Model)
    % Substitute Continuity and Compatibility Eqns into Elemental Eqns
    U = subs(Model.elem_eqns,lhs(Model.cont_eqns),rhs(Model.cont_eqns));
    UU = subs(U,lhs(Model.comp_eqns),rhs(Model.comp_eqns));

    %Create Output Equations
    if ~isempty(LG.y)
        [Y] = OutputEquations(LG.y,Model.x,Model.u,UU,Model.cont_eqns,Model.comp_eqns);
        %Moved this sub to later
        %Y = subs(output_eqns,lhs(UU),rhs(UU));
    else
        Y = [];
    end

    %Create d vector (primary variables of dependent energy storage elements)
    idx = Model.Links == 2 | Model.Branches == 6; %find index of A-types in CoTree and T-Types in Tree
    d = Model.Prime(idx).'; %primary variables of dependent storage elements
    d_idx = find(ismember(lhs(Model.elem_eqns),d)); %find index of dependent energy storage elemental equation

    %Create p vector (primary variables of nonenergy storage elements)
    idx = [(Model.Links == 5 | Model.Branches == 5);(Model.Links == 3 | Model.Branches == 3); (Model.Links == 4 | Model.Branches == 4)];
    p = [];
    for i = 1:3
        p = [p,Model.Prime(idx(i,:))]; %#ok<AGROW> %primary variables of nonenergy storage elements
    end
    p = p.';
    p_idx = find(ismember(lhs(Model.elem_eqns),p)); %find index of nonenergy storage elemental equation


    %Create d_x vector
    d_x = diff(Model.x);
    d_x_idx = find(ismember(lhs(Model.elem_eqns),d_x)); %find index of independent energy storage elemental equation

    %Create d_u vector
    d_u = diff(Model.u);

    % State Space Equation Generation Using Linear Algebra
    P = ExtractMatrix(rhs(UU(d_x_idx)),Model.x);
    Q = ExtractMatrix(rhs(UU(d_x_idx)),p);
    S = ExtractMatrix(rhs(UU(d_x_idx)),Model.u);
    H = ExtractMatrix(rhs(UU(p_idx)),Model.x); %for some reason, H comes out already transposed. Not sure why.
    J = ExtractMatrix(rhs(UU(p_idx)),p);
    L = ExtractMatrix(rhs(UU(p_idx)),Model.u); %for some reason, L comes out already transposed. Not sure why.

    %Check for each case
    if isempty(d) == true %Case 1: No Dependent Storage Elements
        M = 0;
        R = 0;
        K = 0;
        Case = 1;
    else %Case 2: Dependent Storage Elements
        R = ExtractMatrix(rhs(UU(d_x_idx)),d);
        M = ExtractMatrix(rhs(UU(d_idx)),d_x);
        K = ExtractMatrix(rhs(UU(p_idx)),d);
        Case = 2;
    end

    %Case 3: Input Derivatives
    N = ExtractMatrix(rhs(UU(d_idx)),d_u);
    if isempty(N) %if N is empty, then there were no input derivatives founnd
        N = 0;
    else
        Case = 3;
    end

    %Construct State Space Matricies A, B and E
    switch Case
        case 1
            Model.A = simplify((P+Q*((eye(size(J))-J)\H)));
            Model.B = simplify((S+Q*((eye(size(J))-J)\L)));
            Model.E = [];
        case 2
            Z = eye(size((Q*((eye(size(J))-J)\K)+R)*M))-(Q*((eye(size(J))-J)\K)+R)*M; %eye(size(M))-(Q*((eye(size(J))-J)\K)+R)*M;
            Model.A = simplify(Z\(P+Q*((eye(size(J))-J)\H)));
            Model.B = simplify(Z\(S+Q*((eye(size(J))-J)\L)));
            Model.E = [];
        case 3
            Z = eye(size((Q*((eye(size(J))-J)\K)+R)*M))-(Q*((eye(size(J))-J)\K)+R)*M; %eye(size(M))-(Q*((eye(size(J))-J)\K)+R)*M;
            Model.A = simplify(Z\(P+Q*((eye(size(J))-J)\H)));
            Model.B = simplify(Z\(S+Q*((eye(size(J))-J)\L)));
            Model.E = simplify(Z\(R+Q*((eye(size(J))-J)\K))*N);
    end
    
    %Construct State Space Matricies C and D
    if ~isempty(Y)
        if has(Y,d_u)
            Y = subs(Y,d_x,Model.A*Model.x+Model.B*Model.u+Model.E*d_u);
            Y = isolate(Y,LG.y);
            Model.F = simplify(ExtractMatrix(rhs(Y),d_u));
        else
            Model.F = [];
        end
        Y = subs(Y,lhs(UU),rhs(UU));
        Model.C = simplify(ExtractMatrix(rhs(Y),Model.x));
        Model.D = simplify(ExtractMatrix(rhs(Y),Model.u));
        
    else
        Model.C = [];
        Model.D = [];
        Model.F = [];
    end
end

function [Matrix]  = ExtractMatrix(eqn,vars)
    %Allows use of equationsToMatrix for equations that are non-linear
    y = sym('y',[1,length(vars)]); %Create y symbolic variables
    eqn = subs(eqn,vars,y.'); %Replace vars in eqn with y variables
    Matrix = equationsToMatrix(eqn,y.');
end

function [output_eqns] = OutputEquations(y,x,u,UU,cont_eqns,comp_eqns)
    output_eqns = sym(zeros(length(y),1));
    eqns = [UU;cont_eqns;comp_eqns];
    for i = 1:length(y)
        if sum(has(x,y(i))) %if output variable is a state variable sum(isAlways(y(i) == x))
            n = find(x == y(i));
            output_eqns(i) = y(i) == x(n); %#ok<*FNDSB> %Do not fix this warning, required to be this way
        elseif sum(has(u,y(i))) %if output variable is an input variable sum(isAlways(y(i) == u))
            n = find(u == y(i));
            output_eqns(i) = y(i) == u(n);
        else %if output variable is not a state variable
            n = find(lhs(eqns) == y(i));
            output_eqns(i) = eqns(n); %Do not fix this warning, required to be this way
        end
    end
end