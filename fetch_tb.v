module fetch_tb();

reg [1:0] PC_src;
reg Mem_en, excp;
reg [15:0] b_j_pc;

wire clk, rst;
wire [15:0] instruction;
wire [15:0] incr_pc;
// ignore err
wire err;

fetch f_DUT(.clk(clk), .rst(rst), .b_j_pc(b_j_pc), .PC_src(PC_src), .Mem_en(Mem_en), .excp(excp), .instruction(instruction), .incremented_pc(incr_pc));
clkrst clk_generator(.clk(clk), .rst(rst), .err(err));

initial begin
  PC_src = 2'b01;
  Mem_en = 1'b0;
  b_j_pc = 16'h0;
end

always@(posedge clk) begin
  Mem_en = 1'b1;
end

endmodule
