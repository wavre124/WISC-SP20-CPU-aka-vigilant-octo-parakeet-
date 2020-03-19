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

   // TO DO:
   // We need to somehow handle err, I say we just set err to 1 in default case statements.. ezpz

   fetch fetch_blk(.clk(clk), .rst(rst), .b_j_pc(br_ju_addr),
                   .PC_src(PC_src), .Mem_en(Mem_en), .excp(Excp), .instruction(instruction), .incremented_pc(inc_PC));

   decode decode_blk(.clk(clk), .rst(rst), .Data_one(data_one), .Data_two(data_two), .err(dec_err), .inst(instruction),
                     .ALU_op(ALU_op), .branch_jump_op(branch_jump_op), .PC_src(PC_src), .Dst_reg(Dst_reg), .Ext_op(Ext_op),
                     .Ext_sign(Ext_sign), .Reg_write(Reg_write), .Mem_read(Mem_read), .Mem_write(Mem_write), .JAL(JAL), .Mem_reg(Mem_reg),
                     .Mem_en(Mem_en), .Excp(Excp), .ALU_src(ALU_src), .PC(inc_PC), .wb_data(wb_data), .br_ju_addr(br_ju_addr),
                     .immediate(immediate));

   execute execute_blk(.data_1(data_one), .data_2(data_two), .signed_immediate(immediate),
                       .ALU_src(ALU_src), .ALU_op(ALU_op), .data_out(alu_out));

   memory memory_blk(.address(alu_out), .write_data(data_two), .Mem_en(Mem_en), .Mem_write(Mem_write), .Mem_read(Mem_read), .clk(clk), .rst(rst), .PC_src(PC_src), .data_read(mem_read_data));

   wb wb_blk(.data_read(mem_read_data), .address(alu_out), .Mem_reg(Mem_reg), .data_out(wb_data));

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
