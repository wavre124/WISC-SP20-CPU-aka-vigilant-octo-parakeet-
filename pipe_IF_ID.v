module pipe_IF_ID(clk, rst, instruction, incremented_pc, flush_fetch, stall_decode, ID_instruction, ID_incremented_pc);

input clk, rst;
input [15:0] instruction; //instruction received from instruction memory
input [15:0] incremented_pc;
input flush_fetch;
input stall_decode;

output [15:0] ID_instruction;
output [15:0] ID_incremented_pc;

wire [15:0] mux_instruction, mux2_instruction;
wire [15:0] mux_pc;

wire nop_stall;

assign nop_stall = flush_fetch;

localparam nop  = 16'b0000_1000_0000_0000;

mux2_1_N ins_mux(.InA(instruction), .InB(nop), .S(nop_stall), .Out(mux_instruction));

mux2_1_N ins2_mux(.InA(mux_instruction), .InB(ID_instruction), .S(stall_decode), .Out(mux2_instruction));

dff ins_flops[15:0](.q(ID_instruction), .d(mux2_instruction), .clk(clk), .rst(rst));

mux2_1_N pc_mux2(.InA(incremented_pc), .InB(ID_incremented_pc), .S(stall_decode), .Out(mux_pc));

dff pc_flops[15:0](.q(ID_incremented_pc), .d(mux_pc), .clk(clk), .rst(rst));

endmodule
