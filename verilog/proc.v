/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
module proc (/*AUTOARG*/
   // Outputs
   err,
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output

   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines


   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */

   parameter N = 16;

   wire [N-1:0] instruction;
   wire [N-1:0] EPC_reg;
   wire [N-1:0] PC;
   wire [N-1:0] inc_PC;
   wire [N-1:0] br_ju_addr;
   wire [N-1:0] data_one, data_two;
   wire [N-1:0] immediate;

   wire [3:0] ALU_op;
   wire [2:0] branch_jump_op;
   wire [1:0] PC_src, Dst_reg;
   wire [1:0] Ext_op;
   wire Ext_sign, Reg_write, Mem_read, Mem_write, JAL, Mem_reg, Mem_en, valid_rd;
   wire Excp, ALU_src;
   wire dec_err;
   wire halt;
   wire [N-1:0] alu_out, wb_data, mem_read_data;
   wire [2:0] write_sel;
   wire [N-1:0] bj_write_data;

   // IF-ID pipeline wires
   wire flush_fetch;
   wire stall_decode;
   wire [N-1:0] ID_instruction;
   wire [N-1:0] ID_incremented_pc;

   // ID-EX pipeline wires
   wire [2:0] ID_RD;
   wire [2:0] ID_RS;
   wire [2:0] ID_RT;

   wire [3:0] EX_ALU_op;
   wire [1:0] EX_Dst_reg, EX_PC_src;
   wire EX_ALU_src, EX_Reg_write, EX_Mem_read, EX_Mem_write, EX_Mem_reg, EX_Mem_en, EX_valid_rd;
   wire [15:0] EX_instruction;
   wire [15:0] EX_immediate;
   wire [15:0] EX_Data_one; // Rs data
   wire [15:0] EX_Data_two; // Rt data
   wire [2:0] EX_rd;
   wire [2:0] EX_rs;
   wire [2:0] EX_rt;
   wire [2:0] EX_write_sel;
   wire EX_Mem_halt;
   wire EX_JAL;
   wire [N-1:0] EX_bj_write_data;

   // EX-MEM pipeline wires
   wire [15:0] MEM_instruction;
   wire [15:0] MEM_data_out;
   wire [15:0] MEM_data_two;
   wire [N-1:0] MEM_bj_write_data;
   wire [2:0] MEM_RD;
   wire [2:0] MEM_RS;
   wire [2:0] MEM_write_sel;
   wire [15:0] data_rd;

   wire [1:0] MEM_Dst_reg, MEM_PC_src;
   wire MEM_Reg_write, MEM_Mem_read, MEM_Mem_write, MEM_Mem_reg, MEM_Mem_en, MEM_valid_rd;
   wire MEM_halt;
   wire MEM_JAL;

   // MEM-WB pipeline wires
   wire [15:0] WB_instruction;
   wire [15:0] WB_data_read;
   wire [15:0] WB_address;
   wire [N-1:0] WB_bj_write_data;
   wire [2:0] WB_RD;
   wire [2:0] WB_RS;
   wire [2:0] WB_write_sel;

   wire [1:0] WB_Dst_reg, WB_PC_src;
   wire WB_Reg_write, WB_Mem_reg, WB_Mem_read, WB_Mem_write, WB_Mem_en, WB_halt, WB_valid_rd;
   wire WB_JAL;

   // memory misalignment wires
   // this wire is if a misalignment occurs in the instruction (fetch) blk
   wire inst_mis_align;
   wire ID_inst_mis_align;
   wire EX_inst_mis_align;
   wire MEM_inst_mis_align;
   // this wire is if a misalignment occurs in the memory blk
   wire mem_mis_align;
   wire valid_rt;
   wire valid_rt_ex;

   // wires for stalling data memory
   wire data_done;
   wire data_stall;
   wire real_stall;

   // wires for stalling ins memory
   wire inst_stall;
   wire bj_stall;

   fetch fetch_blk(.clk(clk), .rst(rst), .b_j_pc(br_ju_addr),
                   .PC_src(PC_src), .Mem_en(Mem_en), .excp(Excp), .stall_decode(stall_decode), .instruction(instruction), .incremented_pc(inc_PC), .EX_instruction(EX_instruction),
                   .misalign_mem(inst_mis_align), .d_Stall(data_stall), .ins_stall(inst_stall), .bj_stall(bj_stall));

   pipe_IF_ID pipe_one(.clk(clk), .rst(rst), .instruction(instruction), .incremented_pc(inc_PC), .flush_fetch(flush_fetch),
                             .stall_decode(stall_decode), .ID_instruction(ID_instruction), .ID_incremented_pc(ID_incremented_pc), .halt(halt), .EX_instruction(EX_instruction),
                             .inst_mis_align(inst_mis_align), .ID_inst_mis_align(ID_inst_mis_align), .d_Stall(data_stall), .inst_stall(inst_stall), .bj_stall(bj_stall));

   decode decode_blk(.clk(clk), .rst(rst), .data_rs_o(data_one), .Data_two(data_two), .err(dec_err), .inst(ID_instruction), //6
                     .ALU_op(ALU_op), .RD(ID_RD), .RS(ID_RS), .RT(ID_RT), .branch_jump_op(branch_jump_op), .PC_src(PC_src), .Dst_reg(Dst_reg), .Ext_op(Ext_op), //8
                     .Ext_sign(Ext_sign), .Reg_write(Reg_write), .Mem_read(Mem_read), .Mem_write(Mem_write), .JAL(JAL), .Mem_reg(Mem_reg), //6
                     .Mem_en(Mem_en), .Excp(Excp), .ALU_src(ALU_src), .PC(ID_incremented_pc), .wb_data(wb_data), .br_ju_addr(br_ju_addr), //6
                     .immediate(immediate), .stall_decode(stall_decode), .flush_fetch(flush_fetch), //3
                      .rd_ID_EX(EX_rd), .rt_ID_EX(EX_rt), .rs_ID_EX(EX_rs), .rd_EX_MEM(MEM_RD), //4
                      .EX_MEM_reg_write(EX_Reg_write), .MEM_wb_reg_write(MEM_Reg_write), .wb_reg_write(WB_Reg_write) ,.write_sel(write_sel), .write_sel_WB(WB_write_sel), //5
                      .rs_EX_MEM(MEM_RS), .EX_MEM_ins(EX_instruction), .rs_MEM_WB(WB_RS), .MEM_wb_ins(MEM_instruction), .halt(halt), .valid_rd(valid_rd), //6
                      .EX_MEM_valid_rd(EX_valid_rd), .MEM_wb_valid_rd(MEM_valid_rd), .WB_JAL(WB_JAL), .bj_write_data(bj_write_data),
                       .WB_bj_write_data(WB_bj_write_data), .valid_rt(valid_rt), .execute_data(alu_out), .memory_read_data(mem_read_data), .mem_address(MEM_data_out)); //2
                       // .execute_data(MEM_data_out), .memory_read_data(WB_data_read), .mem_address(WB_address));



   pipe_ID_EX pipe_two(.clk(clk), .rst(rst), .ALU_op(ALU_op), .Dst_reg(Dst_reg), .PC_src(PC_src), .ALU_src(ALU_src), .Reg_write(Reg_write),
                                       .Mem_read(Mem_read), .Mem_write(Mem_write), .Mem_reg(Mem_reg), .Mem_en(Mem_en),
                                       .instruction(ID_instruction), .immediate(immediate), .Data_one(data_one), .Data_two(data_two),
                                       .rd(ID_RD), .rs(ID_RS), .rt(ID_RT), .write_sel(write_sel), .ALU_op_o(EX_ALU_op),
                                       .Dst_reg_o(EX_Dst_reg), .PC_src_o(EX_PC_src), .ALU_src_o(EX_ALU_src), .Reg_write_o(EX_Reg_write),
                                       .Mem_read_o(EX_Mem_read), .Mem_write_o(EX_Mem_write), .Mem_reg_o(EX_Mem_reg),
                                       .Mem_en_o(EX_Mem_en), .instruction_o(EX_instruction), .immediate_o(EX_immediate),
                                       .Data_one_o(EX_Data_one), .Data_two_o(EX_Data_two), .rd_o(EX_rd), .rs_o(EX_rs), .rt_o(EX_rt), .write_sel_o(EX_write_sel), .halt(halt),
                                       .halt_o(EX_Mem_halt), .valid_rd(valid_rd), .valid_rd_o(EX_valid_rd), .stall_decode(stall_decode), .JAL(JAL), .JAL_o(EX_JAL),
                                       .bj_write_data(bj_write_data), .bj_write_data_o(EX_bj_write_data),
                                       .instruction_ex(EX_instruction), .valid_rt(valid_rt), .valid_rt_o(valid_rt_ex), .inst_mis_align(ID_inst_mis_align), .inst_mis_align_o(EX_inst_mis_align),
                                       .d_Stall(data_stall), .inst_stall(bj_stall));

   execute execute_blk(.data_1(EX_Data_one), .data_2(EX_Data_two), .signed_immediate(EX_immediate),
                       .ALU_src(EX_ALU_src), .ALU_op(EX_ALU_op), .data_out(alu_out), .rd_d(EX_rd), .rs_d(EX_rs), .rt_d(EX_rt), .rd_e(MEM_RD),
                       .rs_e(MEM_RS), .rd_m(WB_RD), .rs_m(WB_RS), .execute_data(MEM_data_out),
                       .memory_read_data(WB_data_read), .mem_address(WB_address), .reg_write_ex(MEM_Reg_write),
                       .reg_write_mem(WB_Reg_write), .mem_read_ex(MEM_Mem_read), .mem_read_mem(WB_Mem_read),
                       .valid_rt(valid_rt_ex), .instruction_d(EX_instruction), .instruction_e(MEM_instruction), .instruction_m(WB_instruction), .valid_rd_e(MEM_valid_rd),
                       .valid_rd_m(WB_valid_rd), .data_rd(data_rd), .bj_write_data(WB_bj_write_data), .d_Stall(data_stall), .real_stall(real_stall));

   pipe_EX_MEM pipe_three(.clk(clk), .rst(rst), .instruction(EX_instruction), .data_out(alu_out), .data_two(data_rd), .RD(EX_rd), .RS(EX_rs),
                                          .Dst_reg(EX_Dst_reg), .PC_src(EX_PC_src), .Reg_write(EX_Reg_write), .Mem_read(EX_Mem_read), .Mem_write(EX_Mem_write), .Mem_reg(EX_Mem_reg),
                                          .Mem_en(EX_Mem_en), .write_sel(EX_write_sel), .instruction_o(MEM_instruction), .data_out_o(MEM_data_out), .data_two_o(MEM_data_two),
                                          .RD_o(MEM_RD), .RS_o(MEM_RS),
                                          .Dst_reg_o(MEM_Dst_reg), .PC_src_o(MEM_PC_src), .Reg_write_o(MEM_Reg_write), .Mem_read_o(MEM_Mem_read),
                                          .Mem_write_o(MEM_Mem_write), .Mem_reg_o(MEM_Mem_reg), .Mem_en_o(MEM_Mem_en), .write_sel_o(MEM_write_sel), .halt(EX_Mem_halt),
                                          .halt_o(MEM_halt), .valid_rd(EX_valid_rd), .valid_rd_o(MEM_valid_rd), .JAL(EX_JAL), .JAL_o(MEM_JAL),
                                          .bj_write_data(EX_bj_write_data), .bj_write_data_o(MEM_bj_write_data), .inst_mis_align(EX_inst_mis_align), .inst_mis_align_o(MEM_inst_mis_align),
                                          .d_Stall(data_stall), .d_done(data_done), .inst_stall(bj_stall));

   memory memory_blk(.address(MEM_data_out), .write_data(MEM_data_two), .Mem_en(MEM_Mem_en), .Mem_write(MEM_Mem_write), .Mem_read(MEM_Mem_read),
                     .clk(clk), .rst(rst), .PC_src(MEM_PC_src), .data_read(mem_read_data), .halt(MEM_halt), .misalign_mem(mem_mis_align), .MEM_instruction(MEM_instruction),
                     .d_Stall(data_stall), .d_done(data_done), .real_stall(real_stall));

   pipe_MEM_WB pipe_four(.clk(clk), .rst(rst), .instruction(MEM_instruction), .data_read(mem_read_data), .address(MEM_data_out), .RD(MEM_RD), .RS(MEM_RS)
                                        , .Dst_reg(MEM_Dst_reg), .PC_src(MEM_PC_src), .Reg_write(MEM_Reg_write), .Mem_reg(MEM_Mem_reg), .Mem_read(MEM_Mem_read)
                                        , .Mem_write(MEM_Mem_write), .write_sel(MEM_write_sel), .Mem_en(MEM_Mem_en), .instruction_o(WB_instruction), .data_read_o(WB_data_read),
                                        .address_o(WB_address), .RD_o(WB_RD), .RS_o(WB_RS), .Dst_reg_o(WB_Dst_reg), .PC_src_o(WB_PC_src),
                                        .Reg_write_o(WB_Reg_write), .Mem_reg_o(WB_Mem_reg), .Mem_read_o(WB_Mem_read), .Mem_write_o(WB_Mem_write), .write_sel_o(WB_write_sel),
                                        .Mem_en_o(WB_Mem_en), .halt(MEM_halt), .halt_o(WB_halt), .valid_rd(MEM_valid_rd), .valid_rd_o(WB_valid_rd), .JAL(MEM_JAL), .JAL_o(WB_JAL),
                                        .bj_write_data(MEM_bj_write_data), .bj_write_data_o(WB_bj_write_data), .inst_misalign(MEM_inst_mis_align), .mem_misalign(mem_mis_align), .err(err),
                                        .d_done(data_done), .d_Stall(data_stall), .inst_stall(bj_stall));

   wb wb_blk(.data_read(WB_data_read), .address(WB_address), .Mem_reg(WB_Mem_reg), .data_out(wb_data));

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
