/*
   CS/ECE 552 Spring '20

   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
module fetch (clk, rst, b_j_pc, PC_src, Mem_en, excp, stall_decode, instruction, incremented_pc, EX_instruction, misalign_mem, d_Stall, ins_stall, bj_stall, bj_taken);
  // TODO: Your code here

  input [1:0] PC_src;
  input Mem_en, clk, rst, excp, d_Stall;
  input [15:0] b_j_pc; //pcs being fed in from the branch address, jump address, and current pc for holds and normal instructions
  input stall_decode;
  input [15:0] EX_instruction;
  input bj_taken;
  wire [15:0] EPC;
  wire [15:0] pc, mux_pc, flop_pc; //will be fed into our instruction memory
  wire [15:0] exception_pc;
  wire [15:0] middle_pc;

  output [15:0] instruction; //instruction received from instruction memory
  output [15:0] incremented_pc;
  output misalign_mem;

  localparam start_PC_addr = 16'b0000_0000_0000_0000;
  localparam EPC_addr = 16'b0000_0000_0000_0010;

  wire Done, CacheHit;
  output ins_stall;
  output bj_stall;

  cla_16b adder (.A(pc), .B(EPC_addr), .C_in(1'b0), .S(incremented_pc), .C_out(), .Overflow());

  //16 bit 2-1 mux for choosing 2 for exception handler or EPC after we return from the instruction
  mux2_1_N pc_mux1(.InA(EPC), .InB(EPC_addr), .S(excp), .Out(exception_pc));

  //00 is for current pc i.e. HALT
  //01 is for incremented PC for a normal non jumping non branching instruction
  //10 is for branch_address
  //11 is for exception or EPC
  localparam rti = 5'b00011;
  wire [4:0] opcode;
  assign opcode = EX_instruction[15:11];
  wire [1:0] pc_src_help;
  assign pc_src_help = (opcode == rti) ? (2'b01) : PC_src;

  wire stall;
  wire read_req;

  wire [1:0] pc_bj_taken;

  assign pc_bj_taken = (bj_taken) ? PC_src : 2'b01;

  mux4_1_16b pc_mux2(.InA(pc), .InB(incremented_pc), .InC(b_j_pc), .InD(exception_pc), .S(pc_bj_taken), .Out(mux_pc));

  wire stall_decode_wire;

  assign stall_decode_wire = stall_decode | d_Stall | ins_stall;

  // this mux stalls the PC
  mux2_1_N pc_mux4(.InA(mux_pc), .InB(pc), .S(stall_decode_wire), .Out(flop_pc));

  dff pc_flops[15:0](.q(pc), .d(flop_pc), .clk(clk), .rst(rst));
 //changed incremented pc to pc
  mux2_1_N pc_mux3(.InA(EPC), .InB(pc), .S(excp), .Out(middle_pc));

  dff epc_flops[15:0](.q(EPC), .d(middle_pc), .clk(clk), .rst(rst));

  //memory2c instruction_memory(.data_out(instruction), .data_in(16'b0000_0000_0000_0000), .addr(pc), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));

  //memory2c_align instruction_memory(.data_out(instruction), .data_in(start_PC_addr), .addr(pc), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst), .err(misalign_mem));

  mem_system_ins ins_mem( .DataOut(instruction), .Done(Done), .Stall(stall), .CacheHit(CacheHit), .err(misalign_mem), .Addr(pc), .DataIn(start_PC_addr), .Rd(1'b1), .Wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));

  assign ins_stall = ~(stall & Done);
  assign bj_stall = ((PC_src == 2) & ~(stall & Done) & bj_taken);
  assign read_req = ~stall;

endmodule
