/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 1

    2-1 mux template
*/
module mux2_1(InA, InB, S, Out);
    input   InA, InB;
    input   S;
    output  Out;

    // YOUR CODE HERE
    // this contains the signal S inverted
    wire s_not;

    // this contains the nand of a, b with s/~s
    wire a_nand;
    wire b_nand;

    // this contains the inverted nand outputs
    wire a_log;
    wire b_log;

    // this contains the nor'd logic statements
    wire a_b_log_nor;

    // create the 4 not gates needed by this circuit
    not1 s_inv(.in1(S), .out(s_not));

    // create the nand gates required for the circuit
    nand2 a_nand_gate(.in1(InA), .in2(s_not), .out(a_nand));
    nand2 b_nand_gate(.in1(InB), .in2(S), .out(b_nand));

    // invert the nand gates
    not1 a_inv_nand(.in1(a_nand), .out(a_log));
    not1 b_inv_nand(.in1(b_nand), .out(b_log));

    // create the nor gate
    nor2 log_nor(.in1(a_log), .in2(b_log), .out(a_b_log_nor));

    not1 output_inv(.in1(a_b_log_nor), .out(Out));

endmodule
