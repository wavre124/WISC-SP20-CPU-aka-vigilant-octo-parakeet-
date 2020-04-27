module pipe_IF_ID(clk, rst, instruction, incremented_pc, flush_fetch, stall_decode, ID_instruction, ID_incremented_pc, halt, EX_instruction,
                  inst_mis_align, ID_inst_mis_align, d_Stall, inst_stall, bj_stall);

input clk, rst;
input [15:0] instruction, EX_instruction; //instruction received from instruction memory
input [15:0] incremented_pc;
input flush_fetch;
input stall_decode;
input halt;
input inst_mis_align;
input d_Stall;
input inst_stall, bj_stall;

output [15:0] ID_instruction;
output [15:0] ID_incremented_pc;
output ID_inst_mis_align;

wire [15:0] mux_instruction, mux2_instruction;
wire [15:0] mux_pc;
wire [4:0] opcode;
wire nop_stall;
assign opcode = EX_instruction[15:11];
assign nop_stall = flush_fetch | halt | (inst_stall & ~bj_stall);
localparam rti = 5'b00011;
wire nop_stall_help;
assign nop_stall_help = (opcode == rti) ? 1'b0 : nop_stall;
localparam nop  = 16'b0000_1000_0000_0000;

wire stall_decode_wire;
wire inst_mis_align_wr;

assign stall_decode_wire = stall_decode | d_Stall | bj_stall;

mux2_1_N ins_mux(.InA(instruction), .InB(nop), .S(nop_stall_help), .Out(mux_instruction));

mux2_1_N ins2_mux(.InA(mux_instruction), .InB(ID_instruction), .S(stall_decode_wire), .Out(mux2_instruction));

dff ins_flops[15:0](.q(ID_instruction), .d(mux2_instruction), .clk(clk), .rst(rst));

mux2_1_N pc_mux2(.InA(incremented_pc), .InB(ID_incremented_pc), .S(stall_decode_wire), .Out(mux_pc));

dff pc_flops[15:0](.q(ID_incremented_pc), .d(mux_pc), .clk(clk), .rst(rst));

assign inst_mis_align_wr = (d_Stall) ? ID_inst_mis_align : inst_mis_align;

dff inst_err(.q(ID_inst_mis_align), .d(inst_mis_align_wr), .clk(clk), .rst(rst));

endmodule
