/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 1

    a 16-bit (quad) 4-1 Mux template
*/
module mux4_1_16b(InA, InB, InC, InD, S, Out);

    // parameter N for length of inputs and outputs (to use with larger inputs/outputs)
    parameter N = 16;

    input [N-1:0]   InA, InB, InC, InD;
    input [1:0]     S;
    output [N-1:0]  Out;

    // YOUR CODE HERE
    mux4_1 bit_one(.InA(InA[0]), .InB(InB[0]), .InC(InC[0]), .InD(InD[0]), .S(S), .Out(Out[0]));
    mux4_1 bit_two(.InA(InA[1]), .InB(InB[1]), .InC(InC[1]), .InD(InD[1]), .S(S), .Out(Out[1]));
    mux4_1 bit_three(.InA(InA[2]), .InB(InB[2]), .InC(InC[2]), .InD(InD[2]), .S(S), .Out(Out[2]));
    mux4_1 bit_four(.InA(InA[3]), .InB(InB[3]), .InC(InC[3]), .InD(InD[3]), .S(S), .Out(Out[3]));

    mux4_1 bit_five(.InA(InA[4]), .InB(InB[4]), .InC(InC[4]), .InD(InD[4]), .S(S), .Out(Out[4]));
    mux4_1 bit_six(.InA(InA[5]), .InB(InB[5]), .InC(InC[5]), .InD(InD[5]), .S(S), .Out(Out[5]));
    mux4_1 bit_seven(.InA(InA[6]), .InB(InB[6]), .InC(InC[6]), .InD(InD[6]), .S(S), .Out(Out[6]));
    mux4_1 bit_eight(.InA(InA[7]), .InB(InB[7]), .InC(InC[7]), .InD(InD[7]), .S(S), .Out(Out[7]));

    mux4_1 bit_nine(.InA(InA[8]), .InB(InB[8]), .InC(InC[8]), .InD(InD[8]), .S(S), .Out(Out[8]));
    mux4_1 bit_ten(.InA(InA[9]), .InB(InB[9]), .InC(InC[9]), .InD(InD[9]), .S(S), .Out(Out[9]));
    mux4_1 bit_elev(.InA(InA[10]), .InB(InB[10]), .InC(InC[10]), .InD(InD[10]), .S(S), .Out(Out[10]));
    mux4_1 bit_twelv(.InA(InA[11]), .InB(InB[11]), .InC(InC[11]), .InD(InD[11]), .S(S), .Out(Out[11]));

    mux4_1 bit_third(.InA(InA[12]), .InB(InB[12]), .InC(InC[12]), .InD(InD[12]), .S(S), .Out(Out[12]));
    mux4_1 bit_fourteen(.InA(InA[13]), .InB(InB[13]), .InC(InC[13]), .InD(InD[13]), .S(S), .Out(Out[13]));
    mux4_1 bit_fift(.InA(InA[14]), .InB(InB[14]), .InC(InC[14]), .InD(InD[14]), .S(S), .Out(Out[14]));
    mux4_1 bit_sixteen(.InA(InA[15]), .InB(InB[15]), .InC(InC[15]), .InD(InD[15]), .S(S), .Out(Out[15]));

endmodule
