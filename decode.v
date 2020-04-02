/*
   CS/ECE 552 Spring '20

   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
module decode (clk, rst, Data_one, Data_two, err, inst, ALU_op, RD, RS, RT, branch_jump_op, PC_src, Dst_reg, Ext_op,
               Ext_sign, Reg_write, Mem_read, Mem_write, JAL, Mem_reg,
               Mem_en, Excp, ALU_src, PC, wb_data, br_ju_addr, immediate, stall_decode, flush_fetch,
               rd_ID_EX, rt_ID_EX, rs_ID_EX, rd_EX_MEM, rd_MEM_WB, EX_MEM_reg_write, MEM_wb_reg_write, write_sel, write_sel_WB,
               rs_EX_MEM, EX_MEM_ins, rs_MEM_WB, MEM_wb_ins, halt);

   // TODO: Your code here

   parameter N = 16;

   input clk, rst;
   input [N-1:0] inst;
   input [N-1:0] PC;
   input [N-1:0] wb_data;
   wire [15:0] inst_help;
   // pipe wires for hazard blk
   input [2:0] rd_ID_EX;
   input [2:0] rt_ID_EX;
   input [2:0] rs_ID_EX;
   input [2:0] rd_EX_MEM;
   input [2:0] rd_MEM_WB;

   input EX_MEM_reg_write;
   input MEM_wb_reg_write;

   input [2:0] rs_EX_MEM;
   input [15:0] EX_MEM_ins;
   input [2:0] rs_MEM_WB;
   input [15:0] MEM_wb_ins;

   input [2:0] write_sel_WB;

   output [N-1:0] Data_one; // Rs
   output [N-1:0] Data_two; // Rt
   output err;
   output [2:0] RD;
   output [2:0] RS;
   output [2:0] RT;
   output [3:0] ALU_op;
   output [2:0] branch_jump_op;
   output [1:0] PC_src, Dst_reg;
   output [1:0] Ext_op;
   output Ext_sign, Reg_write, Mem_read, Mem_write, JAL, Mem_reg, Mem_en;
   output Excp, ALU_src, stall_decode, flush_fetch;
   output halt;
   output [N-1:0] br_ju_addr;
   
   wire [N-1:0] write_data;
   wire [N-1:0] bj_write_data;
   output [2:0] write_sel;
   wire [2:0] write_sel_pipe;
   wire reg_write_pipe;
   output [N-1:0] immediate;
    localparam pc_help = 1'b0;
   localparam R7 = 3'b111;

   // this is the WB data from the WB stage, the JAL signal needs to be piped
   // FIXME: potential edge case. Imagine an instruction which needs to write
   // back data in the 5th stage of the pipeline and we have a JAL in the 2nd
   // stage in decode at the same time, this will result in incorrect data
   // being written..
   // FIXME: potential fix is to stall... I think in hazard detect
   assign write_data = (JAL) ? bj_write_data : wb_data;
   assign RS = inst[10:8]; //added code here
   assign RT = inst[7:5];
   assign RD = write_sel;
   assign inst_help = (PC == pc_help) ? 16'b0000_1000_0000_0000 : inst;
   mux4_1 write_sel_mux[2:0](.InA(inst[4:2]), .InB(inst[7:5]), .InC(inst[10:8]), .InD(R7), .S(Dst_reg), .Out(write_sel));

   assign write_sel_pipe = (JAL) ? write_sel : write_sel_WB;
   assign reg_write_pipe = (JAL) ? Reg_write : MEM_wb_reg_write;

   control ctrl_blk(.inst(inst_help), .ALU_op(ALU_op), .branch_jump_op(branch_jump_op), .PC_src(PC_src), .Dst_reg(Dst_reg), .Ext_op(Ext_op),
                  .Ext_sign(Ext_sign), .Reg_write(Reg_write), .Mem_read(Mem_read), .Mem_write(Mem_write), .JAL(JAL), .Mem_reg(Mem_reg),
                  .Mem_en(Mem_en), .Excp(Excp), .ALU_src(ALU_src), .halt(halt));

   
   regFile_bypass regfile (.read1Data(Data_one), .read2Data(Data_two), .err(err), .clk(clk), .rst(rst),
                           .read1RegSel(inst[10:8]), .read2RegSel(inst[7:5]), .writeRegSel(write_sel_pipe), .writeData(write_data), .writeEn(reg_write_pipe));
    
   /* 
   regFile regfile (.read1Data(Data_one), .read2Data(Data_two), .err(err), .clk(clk), .rst(rst),
                    .read1RegSel(inst[10:8]), .read2RegSel(inst[7:5]), .writeRegSel(write_sel_pipe), .writeData(wb_data), .writeEn(reg_write_pipe));
   */
   extend ext_blk(.inst(inst), .ext_sign(Ext_sign), .ext_op(Ext_op), .ext_imm(immediate));

   branch_jump bj_blk(.rs(Data_one), .PC(PC), .imm(immediate), .displacement(immediate),
                      .branch_jump_op(branch_jump_op), .b_j_PC(br_ju_addr), .reg_data(bj_write_data));

   hazard_det hazard_blk(.rd_ID_EX(rd_ID_EX), .rt_ID_EX(rt_ID_EX), .rs_ID_EX(rs_ID_EX),
                         .rd_EX_MEM(rd_EX_MEM), .rs_EX_MEM(rs_EX_MEM), .EX_MEM_reg_write(EX_MEM_reg_write), .EX_MEM_ins(EX_MEM_ins), .rd_MEM_WB(rd_MEM_WB), .rs_MEM_WB(rs_MEM_WB),
                         .MEM_wb_reg_write(MEM_wb_reg_write), .MEM_wb_ins(MEM_wb_ins), .PC_source(PC_src), .stall_decode(stall_decode), .flush_fetch(flush_fetch));

endmodule
