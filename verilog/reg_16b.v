module reg_16b(clk, rst, writeEn, inputData, outputData);

  input clk, rst, writeEn;
  input [15:0] inputData;
  output [15:0] outputData;

  parameter N = 16;

  wire [N-1:0] reg_in, reg_out;

  mux2_1_N mux_zero(.InA(reg_out), .InB(inputData), .S(writeEn), .Out(reg_in));

  dff bits[N-1:0](.q(reg_out), .d(reg_in), .clk(clk), .rst(rst));

  assign outputData = reg_out;

endmodule
