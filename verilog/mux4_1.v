/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 1

    4-1 mux template
*/
module mux4_1(InA, InB, InC, InD, S, Out);
    input        InA, InB, InC, InD;
    input [1:0]  S;
    output       Out;

    // YOUR CODE HERE

    // both 2-1 muxes output wires for ab and cd
    wire ab_out;
    wire cd_out;

    // all 3 muxes needed, final one computing the out between the 2 2-1 muxes
    mux2_1 ab_mux(.InA(InA), .InB(InB), .S(S[0]), .Out(ab_out));
    mux2_1 cd_mux(.InA(InC), .InB(InD), .S(S[0]), .Out(cd_out));
    mux2_1 final_mux(.InA(ab_out), .InB(cd_out), .S(S[1]), .Out(Out));

endmodule
