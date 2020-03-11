module fetch();

reg [1:0] PC_src;
reg Mem_en, clk, rst, excp;
reg [15:0] b_j_pc;

wire [15:0] instruction;
wire [15:0] incr_pc;

fetch f_DUT(.clk(clk), .rst(rst), .b_j_pc(b_j_pc), .PC_src(PC_src), .Mem_en(Mem_en), .excp(excp), .instruction(instruction), .incremented_pc(incr_pc));

initial begin





end





endmodule
