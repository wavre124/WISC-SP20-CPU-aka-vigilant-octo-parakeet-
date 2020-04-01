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
   wire Ext_sign, Reg_write, Mem_read, Mem_write, JAL, Mem_reg, Mem_en;
   wire Excp, ALU_src;
   wire dec_err;

   wire [N-1:0] alu_out, wb_data, mem_read_data;
   wire [2:0] write_sel;

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
   wire EX_ALU_src, EX_Reg_write, EX_Mem_read, EX_Mem_write, EX_Mem_reg, EX_Mem_en;
   wire [15:0] EX_instruction;
   wire [15:0] EX_immediate;
   wire [15:0] EX_Data_one; // Rs data
   wire [15:0] EX_Data_two; // Rt data
   wire [2:0] EX_rd;
   wire [2:0] EX_rs;
   wire [2:0] EX_rt;
   wire [2:0] EX_write_sel;

   // EX-MEM pipeline wires
   wire [15:0] MEM_instruction;
   wire [15:0] MEM_data_out;
   wire [15:0] MEM_data_two;
   wire [2:0] MEM_RD;
   wire [2:0] MEM_RS;
   wire [2:0] MEM_write_sel;

   wire [1:0] MEM_Dst_reg, MEM_PC_src;
   wire MEM_Reg_write, MEM_Mem_read, MEM_Mem_write, MEM_Mem_reg, MEM_Mem_en;

   // MEM-WB pipeline wires
   wire [15:0] WB_instruction;
   wire [15:0] WB_data_read;
   wire [15:0] WB_address;
   wire [2:0] WB_RD;
   wire [2:0] WB_RS;
   wire [2:0] WB_write_sel;

   wire [1:0] WB_Dst_reg, WB_PC_src;
   wire WB_Reg_write, WB_Mem_reg, WB_Mem_read, WB_Mem_write, WB_Mem_en;

   fetch fetch_blk(.clk(clk), .rst(rst), .b_j_pc(br_ju_addr),
                   .PC_src(PC_src), .Mem_en(Mem_en), .excp(Excp), .stall_decode(stall_decode), .instruction(instruction), .incremented_pc(inc_PC));

   pipe_IF_ID pipe_one(.clk(clk), .rst(rst), .instruction(instruction), .incremented_pc(inc_PC), .flush_fetch(flush_fetch),
                             .stall_decode(stall_decode), .ID_instruction(ID_instruction), .ID_incremented_pc(ID_incremented_pc));

   decode decode_blk(.clk(clk), .rst(rst), .Data_one(data_one), .Data_two(data_two), .err(dec_err), .inst(ID_instruction),
                     .ALU_op(ALU_op), .RD(ID_RD), .RS(ID_RS), .RT(ID_RT), .branch_jump_op(branch_jump_op), .PC_src(PC_src), .Dst_reg(Dst_reg), .Ext_op(Ext_op),
                     .Ext_sign(Ext_sign), .Reg_write(Reg_write), .Mem_read(Mem_read), .Mem_write(Mem_write), .JAL(JAL), .Mem_reg(Mem_reg),
                     .Mem_en(Mem_en), .Excp(Excp), .ALU_src(ALU_src), .PC(ID_incremented_pc), .wb_data(wb_data), .br_ju_addr(br_ju_addr),
                     .immediate(immediate), .stall_decode(stall_decode), .flush_fetch(flush_fetch),
                      .rd_ID_EX(EX_rd), .rt_ID_EX(EX_rt), .rs_ID_EX(EX_rs), .rd_EX_MEM(MEM_RD), .rd_MEM_WB(WB_RD),
                      .EX_MEM_reg_write(MEM_Reg_write), .MEM_wb_reg_write(WB_Reg_write), .write_sel(write_sel), .write_sel_WB(WB_write_sel),
                      .rs_EX_MEM(MEM_RS), .EX_MEM_ins(MEM_instruction), .rs_MEM_WB(WB_RS), .MEM_wb_ins(WB_instruction));

   pipe_ID_EX pipe_two(.clk(clk), .rst(rst), .ALU_op(ALU_op), .Dst_reg(Dst_reg), .PC_src(PC_src), .ALU_src(ALU_src), .Reg_write(Reg_write),
                                       .Mem_read(Mem_read), .Mem_write(Mem_write), .Mem_reg(Mem_reg), .Mem_en(Mem_en),
                                       .instruction(ID_instruction), .immediate(immediate), .Data_one(data_one), .Data_two(data_two),
                                       .rd(ID_RD), .rs(ID_RS), .rt(ID_RT), .write_sel(write_sel), .ALU_op_o(EX_ALU_op),
                                       .Dst_reg_o(EX_Dst_reg), .PC_src_o(EX_PC_src), .ALU_src_o(EX_ALU_src), .Reg_write_o(EX_Reg_write),
                                       .Mem_read_o(EX_Mem_read), .Mem_write_o(EX_Mem_write), .Mem_reg_o(EX_Mem_reg),
                                       .Mem_en_o(EX_Mem_en), .instruction_o(EX_instruction), .immediate_o(EX_immediate),
                                       .Data_one_o(EX_Data_one), .Data_two_o(EX_Data_two), .rd_o(EX_rd), .rs_o(EX_rs), .rt_o(EX_rt), .write_sel_o(EX_write_sel));

   execute execute_blk(.data_1(EX_Data_one), .data_2(EX_Data_two), .signed_immediate(EX_immediate),
                       .ALU_src(EX_ALU_src), .ALU_op(EX_ALU_op), .data_out(alu_out));

   pipe_EX_MEM pipe_three(.clk(clk), .rst(rst), .instruction(instruction), .data_out(alu_out), .data_two(EX_Data_two), .RD(EX_rd), .RS(EX_rs),
                                          .Dst_reg(EX_Dst_reg), .PC_src(EX_PC_src), .Reg_write(EX_Reg_write), .Mem_read(EX_Mem_read), .Mem_write(EX_Mem_write), .Mem_reg(EX_Mem_reg),
                                          .Mem_en(EX_Mem_en), .write_sel(EX_write_sel), .instruction_o(MEM_instruction), .data_out_o(MEM_data_out), .data_two_o(MEM_data_two), .RD_o(MEM_RD), .RS_o(MEM_RS),
                                          .Dst_reg_o(MEM_Dst_reg), .PC_src_o(MEM_PC_src), .Reg_write_o(MEM_Reg_write), .Mem_read_o(MEM_Mem_read),
                                          .Mem_write_o(MEM_Mem_write), .Mem_reg_o(MEM_Mem_reg), .Mem_en_o(MEM_Mem_en), .write_sel_o(MEM_write_sel));

   memory memory_blk(.address(MEM_data_out), .write_data(MEM_data_two), .Mem_en(MEM_Mem_en), .Mem_write(MEM_Mem_write), .Mem_read(MEM_Mem_read),
                     .clk(clk), .rst(rst), .PC_src(MEM_PC_src), .data_read(mem_read_data));

   pipe_MEM_WB pipe_four(.clk(clk), .rst(rst), .instruction(MEM_instruction), .data_read(mem_read_data), .address(MEM_data_out), .RD(MEM_RD), .RS(MEM_RS)
                                        , .Dst_reg(MEM_Dst_reg), .PC_src(MEM_PC_src), .Reg_write(MEM_Reg_write), .Mem_reg(MEM_Mem_reg), .Mem_read(MEM_Mem_read)
                                        , .Mem_write(MEM_Mem_write), .write_sel(MEM_write_sel), .Mem_en(MEM_Mem_en), .instruction_o(WB_instruction), .data_read_o(WB_data_read),
                                        .address_o(WB_address), .RD_o(WB_RD), .RS_o(WB_RS), .Dst_reg_o(WB_Dst_reg), .PC_src_o(WB_PC_src),
                                        .Reg_write_o(WB_Reg_write), .Mem_reg_o(WB_Mem_reg), .Mem_read_o(WB_Mem_read), .Mem_write_o(WB_Mem_write), .write_sel_o(WB_write_sel),
                                        .Mem_en_o(WB_Mem_en));

   wb wb_blk(.data_read(WB_data_read), .address(WB_address), .Mem_reg(WB_Mem_reg), .data_out(wb_data));

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
