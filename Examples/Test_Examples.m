clc;clear

%Example from 3.05 of Picone's Video Series
%WORKS
% LG.S = [2,2,2,3,3,3,4];
% LG.T = [1,3,3,1,4,4,1];
% LG.Type = [1 6 5 2 6 5 2];
% LG.Domain = [2 2 2 2 2 2 2];
% syms Vs k1 B1 m1 k2 B2 m2
% LG.Var_Names = [Vs k1 B1 m1 k2 B2 m2];
% syms F_k1(t) F_k2(t) v_m1(t) v_m2(t)
% LG.y = [F_k1(t) F_k2(t) v_m1(t) v_m2(t)];


%Example from 3.06 of Picone's Video Series
%WORKS
% LG.S = [2,2,3,3,3];
% LG.T = [1,3,1,1,1];
% LG.Type = [1 5 6 2 5];
% LG.Domain = [3 3 3 3 3];
% syms s B1 K J B2
% LG.Var_Names = [s B1 K J B2];
% syms Tau_K(t)
% LG.y = [Tau_K(t)];

%Example from 4.04 of Picone's Video Series
%WORKS
% LG.S = [2,2,3,4,5,5,5];
% LG.T = [1,3,4,1,1,1,1];
% LG.Type = [1 5 6 3 3 5 2];
% LG.Domain = [1 1 1 1 3 3 3];
% syms s R L TF1 TF2 B J
% LG.Var_Names = [s R L TF1 TF2 B J];
% syms Omega_J(t) Tau_J(t) V_L(t) i_L(t) Omega_B(t) Tau_B(t) V_R(t) i_R(t) V_TF1(t) i_TF1(t) Omega_TF2(t) Tau_TF2(t) V_s(t)
% LG.y = [Omega_J(t) Tau_J(t) V_L(t) i_L(t) Omega_B(t) Tau_B(t) V_R(t) i_R(t) V_TF1(t) i_TF1(t) Omega_TF2(t) Tau_TF2(t) V_s(t)];

%Example from MIT Document (Two-Port Energy Transducing Elements, pg.24) for figure 21
%WORKS, Just know that TF = 1/Ka in the example solution
% LG.S = [2,2,3,4,5,5,5];
% LG.T = [1,3,4,1,1,1,1];
% LG.Type = [1 5 6 3 3 5 2];
% LG.Domain = [1 1 1 1 3 3 3];
% syms s R L Ka Ka B J
% LG.Var_Names = [s R L 1/Ka 1/Ka B J];
% syms Tau_J(t) i_L(t) Tau_B(t)
% LG.y = [Tau_J(t) i_L(t) Tau_B(t)];

%Example from MIT Document (Two-Port Energy Transducing Elements, pg.26) for figure 22
%WORKS, Just know that GY = 1/A in the example solution
% LG.S = [2,2,3,4,4,4,4];
% LG.T = [1,3,1,1,1,1,1];
% LG.Type = [1 5 4 4 5 6 2];
% LG.Domain = [4 4 4 2 2 2 2];
% syms s R A B K m
% LG.Var_Names = [s R 1/A 1/A B K m];
% LG.y = [];

%Example 3.4 from "Mechatronics A Foundation Course" by De Silva
%WORKS, A and B are arranged a bit differently but equal to the same result
% S = [1,2,2,2,3,3,4,4,4,5,5,1];
% T = [2,1,3,3,1,1,3,1,1,1,1,5];
% Type = [7 2 6 5 5 2 6 5 3 3 2 7];
% Domain = [2 2 2 2 2 2 2 2 2 3 3 3];
% syms s1 Mc Kc Bc Bh Mh Kr Br r Jr s2
% Var_Names = [s1 Mc Kc Bc Bh Mh Kr Br r r Jr s2];
% y = [];

%Example from "Interactive Software for Dynamic System Modeling using Linear Graphs", Car suspension
%WORKS
% S = [2,2,2,2,3];
% T = [1,1,3,3,1];
% Type = [2 6 6 5 2];
% Domain = [2 2 2 2 2];
% syms m1 k1 k2 b1 m2
% Var_Names = [m1 k1 k2 b1 m2];
% y = [];

%Example from MIT Document (State equation formulation, pg.17) for figure 14
%WORKS
% LG.S = [2,2,3,4,4];
% LG.T = [1,3,4,1,1];
% LG.Type = [1 5 6 5 2];
% LG.Domain = [4 4 4 4 4];
% syms s Rp Ip Rf Cf
% LG.Var_Names = [s Rp Ip Rf Cf];
% LG.y = [];

%Example from MIT Document (State equation formulation, pg.20) for figure 16
%*************************************************************
%WORKS and properly finds "F" Matrix
% LG.S = [2 3 2 2 3];
% LG.T = [1 1 3 3 1];
% LG.Type = [1 2 2 5 5];
% LG.Domain = [1 1 1 1 1];
% syms s C2 C1 R1 R2
% LG.Var_Names = [s C2 C1 R1 R2];
% syms i_C1(t)
% LG.y = [i_C1(t)];

%Example from MIT Document (State equation formulation, pg.22) for figure 17
%Case 3 Example: WORKS!!!! (Fixed after changes from GP paper)
% LG.S = [1,2,2,3,4,4];
% LG.T = [2,4,3,4,1,1];
% LG.Type = [7 6 6 5 5 2];
% LG.Domain = [2 2 2 2 2 2];
% syms s K2 K1 B1 B2 m
% LG.Var_Names = [s K2 K1 B1 B2 m];
% syms v_B1(t) % v_m(t) F_K1(t)
% LG.y = [v_B1(t)];

%Example from System Dynamics An Introduction (ex.5.8 pg.146)
%Case 3 Example
%WORKS!
% S = [2,3,2,2,3];
% T = [1,1,3,3,1];
% Type = [1 2 2 5 5];
% Domain = [1 1 1 1 1];
% syms s C2 C1 R1 R2
% Var_Names = [s C2 C1 R1 R2];
% y = [];

%Example from MIT Document (State equation formulation, pg.24) for figure 18
%WORKS!! Mistake in Paper's Math, program is correct.
% LG.S = [1,2,3,2,3];
% LG.T = [2,1,1,3,1];
% LG.Type = [7 2 5 5 6];
% LG.Domain = [1 1 1 1 1];
% syms s C R1 R2 L
% LG.Var_Names = [s C R2 R1 L];
% LG.y = [];

%Example 2 from lecture 4 of advanced control
%WORKS, And  contour issue fixed
% S = [2,2,2,3,3,3,4];
% T = [1,3,3,1,4,4,1];
% Type = [1 6 5 2 6 5 2];
% Domain = [2 2 2 2 2 2 2];
% syms u K2 B2 m2 K1 B1 m1
% Var_Names = [u K2 B2 m2 K1 B1 m1];
% y = [];

%Figure 8 of MIT Paper (State Equation Formulation)
%Testing Parallel T-Type Elements Check
%TEST WORKS, CAUGHT EXCESS STATE VARIABLES
% LG.S = [1 2 2 2 2];
% LG.T = [2 1 1 1 1];
% LG.Type = [7 5 2 6 6];
% LG.Domain = [2 2 2 2 2];
% syms s B m K1 K2
% LG.Var_Names = [s B m K1 K2];
% LG.y = [];

%Figure 8 of MIT Paper (State Equation Formulation)
%Testing Series A-Type Elements Check
%TEST WORKS, CAUGHT EXCESS STATE VARIABLES
% LG.S = [2 2 3 4 5 3];
% LG.T = [1 3 4 5 1 1];
% LG.Type = [1 5 2 6 2 5];
% LG.Domain = [1 1 1 1 1 1];
% syms s R1 C1 L1 C2 R2
% LG.Var_Names = [s R1 C1 L1 C2 R2];
% LG.y = [];

%Test for closed LG Model
%Works: Detects loose elements
% LG.S = [2 2 2 3 3 5];
% LG.T = [1 1 3 4 5 1];
% LG.Type = [1 2 5 6 5 2];
% LG.Domain = [1 1 1 1 1 1];
% syms s C1 R1 L1 R2 C2
% LG.Var_Names = [s C1 R1 L1 R2 C2];
% LG.y = [];

%Test for detecting no state variables
%Works! Lack of state variables detected
% LG.S = [2 2 2];
% LG.T = [1 1 1];
% LG.Type = [1 5 2];
% LG.Domain = [1 1 1];
% syms s R1 C1
% LG.Var_Names = [s R1 C1];
% syms V_C1(t)
% LG.y = [V_C1(t)];


%DC Motor with Compliant Shaft and Inertial Load
% LG.S = [2 2 3 4 5 5 5 5 6 6];
% LG.T = [1 3 4 1 1 1 1 6 1 1];
% LG.Type = [1 5 6 3 3 2 5 6 2 5];
% LG.Domain = [1 1 1 1 3 3 3 3 3 3];
% syms s R L TFa TFb J1 B1 K J2 B2
% LG.Var_Names = [s R L TFa TFb J1 B1 K J2 B2];
% syms i_s(t)
% LG.y = [i_s(t)];


[Model] = LGtheory(LG);