/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2

    a 4-bit CLA module
*/
module cla_4b(A, B, C_in, S, C_out);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    input [N-1: 0] A, B;
    input          C_in;
    output [N-1:0] S;
    output         C_out;

    // YOUR CODE HERE

    wire genZero, genOne, genTwo, genThree;
    wire g0_inv, g1_inv, g2_inv, g3_inv;
    wire propZero, propOne, propTwo, propThree;
    wire p0_inv, p1_inv, p2_inv, p3_inv;

    wire carryOne, carryTwo, carryThree;
    wire c1_intm, c2_intm_one, c2_intm_two;
    wire c3_intm_one, c3_intm_two, c3_intm_three, c3_intm_four, c3_intm_five;
    wire c4_intm_zero, c4_intm_one, c4_intm_two, c4_intm_three, c4_intm_four, c4_intm_five, c4_intm_six;

    // compute generates
    nand2 g0_nand(.in1(A[0]), .in2(B[0]), .out(g0_inv));
    nand2 g1_nand(.in1(A[1]), .in2(B[1]), .out(g1_inv));
    nand2 g2_nand(.in1(A[2]), .in2(B[2]), .out(g2_inv));
    nand2 g3_nand(.in1(A[3]), .in2(B[3]), .out(g3_inv));
    not1 g0_not(.in1(g0_inv), .out(genZero));
    not1 g1_not(.in1(g1_inv), .out(genOne));
    not1 g2_not(.in1(g2_inv), .out(genTwo));
    not1 g3_not(.in1(g3_inv), .out(genThree));

    // compute propogates
    nor2 p0_nor(.in1(A[0]), .in2(B[0]), .out(p0_inv));
    nor2 p1_nor(.in1(A[1]), .in2(B[1]), .out(p1_inv));
    nor2 p2_nor(.in1(A[2]), .in2(B[2]), .out(p2_inv));
    nor2 p3_nor(.in1(A[3]), .in2(B[3]), .out(p3_inv));
    not1 p0_not(.in1(p0_inv), .out(propZero));
    not1 p1_not(.in1(p1_inv), .out(propOne));
    not1 p2_not(.in1(p2_inv), .out(propTwo));
    not1 p3_not(.in1(p3_inv), .out(propThree));

    // carry one code
    and2 c1_nand(.in1(propZero), .in2(C_in), .out(c1_intm));
    or2 c1_or(.in1(genZero), .in2(c1_intm), .out(carryOne));

    // carry two code
    and3 c2_and3(.in1(propOne), .in2(propZero), .in3(C_in), .out(c2_intm_one));
    and2 c2_and(.in1(propOne), .in2(genZero), .out(c2_intm_two));
    or3  c2_or(.in1(genOne), .in2(c2_intm_two), .in3(c2_intm_one), .out(carryTwo));

    // carry three code
    and3 c3_and3(.in1(propTwo), .in2(propOne), .in3(propZero), .out(c3_intm_one));
    and2 c3_and2(.in1(c3_intm_one), .in2(C_in), .out(c3_intm_two));
    and3 c3_and3_1(.in1(propTwo), .in2(propOne), .in3(genZero), .out(c3_intm_three));
    and2 c3_and2_1(.in1(propTwo), .in2(genOne), .out(c3_intm_four));
    or3 c3_or3(.in1(genTwo), .in2(c3_intm_four), .in3(c3_intm_three), .out(c3_intm_five));
    or2 c3_or2(.in1(c3_intm_five), .in2(c3_intm_two), .out(carryThree));

    // carry four code
    and3 c4_and3_2(.in1(propThree), .in2(propTwo), .in3(propOne), .out(c4_intm_zero));
    and3 c4_and3_3(.in1(c4_intm_zero), .in2(propZero), .in3(C_in), .out(c4_intm_five));
    and3 c4_and3(.in1(propThree), .in2(propTwo), .in3(propOne), .out(c4_intm_one));
    and2 c4_and2(.in1(c4_intm_one), .in2(genZero), .out(c4_intm_two));
    and3 c4_and3_1(.in1(propThree), .in2(propTwo), .in3(genOne), .out(c4_intm_three));
    and2 c4_and2_1(.in1(propThree), .in2(genTwo), .out(c4_intm_four));
    or3 c4_or3_1(.in1(genThree), .in2(c4_intm_four), .in3(c4_intm_three), .out(c4_intm_six));
    or3 c4_or3_2(.in1(c4_intm_six), .in2(c4_intm_two), .in3(c4_intm_five), .out(C_out));

    fullAdder_1b add_zero(.A(A[0]), .B(B[0]), .C_in(C_in), .S(S[0]), .C_out());
    fullAdder_1b add_one(.A(A[1]), .B(B[1]), .C_in(carryOne), .S(S[1]), .C_out());
    fullAdder_1b add_two(.A(A[2]), .B(B[2]), .C_in(carryTwo), .S(S[2]), .C_out());
    fullAdder_1b add_three(.A(A[3]), .B(B[3]), .C_in(carryThree), .S(S[3]), .C_out());

endmodule
