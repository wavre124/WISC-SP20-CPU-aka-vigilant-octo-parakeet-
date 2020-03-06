module mux2_1_N(InA, InB, S, Out);

  parameter N = 16;

  input [N-1:0] InA, InB;
  input S;

  output [N-1:0] Out;

  mux2_1 muxes[N-1:0](.InA(InA), .InB(InB), .S(S), .Out(Out));

endmodule
