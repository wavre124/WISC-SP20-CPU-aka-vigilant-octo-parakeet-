/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2

    a 1-bit full adder
*/
module fullAdder_1b(A, B, C_in, S, C_out);
    input  A, B;
    input  C_in;
    output S;
    output C_out;

    // YOUR CODE HERE

    wire n_one;
    wire n_two;
    wire n_three;

    wire not_one;
    wire not_two;
    wire not_three;

    wire nor_out;

    xor3 sum_out(.in1(A), .in2(B), .in3(C_in), .out(S));

    nand2 nand_one(.in1(C_in), .in2(A), .out(n_one));
    nand2 nand_two(.in1(C_in), .in2(B), .out(n_two));
    nand2 nand_three(.in1(A), .in2(B), .out(n_three));

    not1 inv_one(.in1(n_one), .out(not_one));
    not1 inv_two(.in1(n_two), .out(not_two));
    not1 inv_three(.in1(n_three), .out(not_three));

    nor3 cout_nor(.in1(not_one), .in2(not_two), .in3(not_three), .out(nor_out));

    not1 inv_four(.in1(nor_out), .out(C_out));

endmodule
