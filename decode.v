/*
   CS/ECE 552 Spring '20

   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
module decode (clk, rst, Data_one, Data_two, err, inst, ALU_op, branch_jump_op, PC_src, Dst_reg, Ext_op,
               Ext_sign, Reg_write, Jump, Branch, Mem_read, Mem_write, JAL, Mem_reg,
               Mem_en, Excp, ALU_src, InvR1, InvR2, Sign, Cin, PC, wb_data, br_ju_addr);

   // TODO: Your code here

   parameter N = 16;

   input clk, rst;
   input [N-1:0] inst;
   input [N-1:0] PC;
   input [N-1:0] wb_data;

   output [N-1:0] Data_one; // Rs
   output [N-1:0] Data_two; // Rt
   output err;

   output [3:0] ALU_op;
   output [2:0] branch_jump_op;
   output [1:0] PC_src, Dst_reg;
   output [1:0] Ext_op;
   output Ext_sign, Reg_write, Jump, Branch, Mem_read, Mem_write, JAL, Mem_reg, Mem_en;
   output Excp, ALU_src;
   output InvR1, InvR2, Sign, Cin;

   output [N-1:0] br_ju_addr;

   wire [N-1:0] write_data;
   wire [N-1:0] bj_write_data;
   wire [2:0] write_sel;
   wire [N-1:0] immediate;

   localparam R7 = 3'b111;

   assign write_data = (JAL) ? bj_write_data : wb_data;

   mux4_1 write_sel_mux[3:0](.InA(inst[4:2]), .InB(inst[7:5]), .InC(inst[10:8]), .InD(R7), .S(Dst_reg), .Out(write_sel));

   control ctrl_blk(.inst(inst), .ALU_op(ALU_op), .branch_jump_op(branch_jump_op), .PC_src(PC_src), .Dst_reg(Dst_reg), .Ext_op(Ext_op),
                  .Ext_sign(Ext_sign), .Reg_write(Reg_write), .Jump(Jump), .Branch(Branch), .Mem_read(Mem_read), .Mem_write(Mem_write), .JAL(JAL), .Mem_reg(Mem_reg),
                  .Mem_en(Mem_en), .Excp(Excp), .ALU_src(ALU_src), .InvR1(InvR1), .InvR2(InvR2), .Sign(Sign), .Cin(Cin));

   regFile_bypass regfile(.read1Data(Data_one), .read2Data(Data_two), .err(err), .clk(clk), .rst(rst),
                          .read1RegSel(inst[10:8]), .read2RegSel(inst[7:5]), .writeRegSel(write_sel), .writeData(write_data), .writeEn(Reg_write));

   extend ext_blk(.inst(inst), .ext_sign(Ext_sign), .ext_op(Ext_op), .ext_imm(immediate));

   branch_jump bj_blk(.rs(Data_one), .PC(PC), .imm(immediate), .displacement(immediate), .branch(Branch), .jump(Jump),
                      .branch_jump_op(branch_jump_op), .b_j_PC(br_ju_addr), .reg_data(bj_write_data));

endmodule
