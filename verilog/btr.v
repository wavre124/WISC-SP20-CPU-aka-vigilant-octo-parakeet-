module btr(InA, Out);

parameter N = 16;

input [N-1:0] InA;
output [N-1:0] Out;

assign Out[0] = InA[15];
assign Out[1] = InA[14];
assign Out[2] = InA[13];
assign Out[3] = InA[12];
assign Out[4] = InA[11];
assign Out[5] = InA[10];
assign Out[6] = InA[9];
assign Out[7] = InA[8];
assign Out[8] = InA[7];
assign Out[9] = InA[6];
assign Out[10] = InA[5];
assign Out[11] = InA[4];
assign Out[12] = InA[3];
assign Out[13] = InA[2];
assign Out[14] = InA[1];
assign Out[15] = InA[0];

endmodule
