module pipe_IF_ID(clk, rst, instruction, incremented_pc, flush_fetch, stall_decode, ID_instruction, ID_incremented_pc);

input clk, rst;
input [15:0] instruction; //instruction received from instruction memory
input [15:0] incremented_pc;
input flush_fetch;
input stall_decode;

output [15:0] ID_instruction;
output [15:0] ID_incremented_pc;

wire [15:0] mux_instruction;
wire [15:0] mux_pc;

mux2_1_N pc_mux1(.InA(instruction), .InB(ID_instruction), .S(stall_decode), .Out(mux_instruction));

dff ins_flops[15:0](.q(ID_instruction), .d(mux_instruction), .clk(clk), .rst(rst));

mux2_1_N pc_mux1(.InA(incremented_pc), .InB(ID_incremented_pc), .S(stall_decode), .Out(mux_pc));

dff pc_flops[15:0](.q(ID_incremented_pc), .d(mux_pc), .clk(clk), .rst(rst));

// ignoring flush for now, ask TA

endmodule
