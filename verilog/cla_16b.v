/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2

    a 16-bit CLA module
*/
module cla_16b(A, B, C_in, S, C_out, Overflow);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    input [N-1: 0] A, B;
    input          C_in;
    output [N-1:0] S;
    output         C_out;

    // YOUR CODE HERE
    output Overflow;

    wire carry_1b, carry_2b, carry_3b;

    cla_4b cla_one(.A(A[3:0]), .B(B[3:0]), .C_in(C_in), .S(S[3:0]), .C_out(carry_1b), .overflow());
    cla_4b cla_two(.A(A[7:4]), .B(B[7:4]), .C_in(carry_1b), .S(S[7:4]), .C_out(carry_2b), .overflow());
    cla_4b cla_three(.A(A[11:8]), .B(B[11:8]), .C_in(carry_2b), .S(S[11:8]), .C_out(carry_3b), .overflow());
    cla_4b cla_four(.A(A[15:12]), .B(B[15:12]), .C_in(carry_3b), .S(S[15:12]), .C_out(C_out), .overflow(Overflow));

endmodule
