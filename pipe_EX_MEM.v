module pipe_EX_MEM(clk, rst, data_out, data_out_o);
  input clk;
  input rst;
  input [15:0] data_out;
  output [15:0] data_out_o;
  dff data_out_flop[15:0](.q(data_out_o), .d(data_out), .clk(clk), .rst(rst));





















endmodule 