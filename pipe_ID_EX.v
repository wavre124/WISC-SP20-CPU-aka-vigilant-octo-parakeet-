module pipe_ID_EX(clk, rst, halt, ALU_op, Dst_reg, PC_src, ALU_src, Reg_write, Mem_read, Mem_write, Mem_reg, Mem_en, valid_rd,
                  instruction, immediate, Data_one, Data_two, rd, rs, rt, write_sel, halt_o, ALU_op_o,
                  Dst_reg_o, PC_src_o, ALU_src_o, Reg_write_o, Mem_read_o, Mem_write_o, Mem_reg_o,
                  Mem_en_o, instruction_o, immediate_o, Data_one_o, Data_two_o, rd_o, rs_o, rt_o, write_sel_o, valid_rd_o);

  input clk, rst;

  //inputs that are CONTROL UNIT SIGNALS//////////////////////////////////////////////////
  input [3:0] ALU_op;
  input [1:0] Dst_reg, PC_src;
  input ALU_src, Reg_write, Mem_read, Mem_write, Mem_reg, Mem_en, halt, valid_rd;
  /////////////////////////////////////////////////////////////////////////////////////////

  //inputs that are NOT CONTROL UNIT SIGNALS/////////////////////////////////////////////////
   input [15:0] instruction;
   input [15:0] immediate;
   input [15:0] Data_one; // Rs data
   input [15:0] Data_two; // Rt data
   input [2:0] rd;//register number
   input [2:0] rs;//register number
   input [2:0] rt;//register number
   input [2:0] write_sel;//register number
  ///////////////////////////////////////////////////////////////////////////////////////////

  //outputs that are CONTROL UNIT SIGNALS///////////////////////////////////////////////////
  output [3:0] ALU_op_o;
  output [1:0] Dst_reg_o, PC_src_o;
  output ALU_src_o, Reg_write_o, Mem_read_o, Mem_write_o, Mem_reg_o, Mem_en_o, halt_o, valid_rd_o;
  ///////////////////////////////////////////////////////////////////////////////////

  //outputs that are NOT CONTROL UNIT SIGNALS///////////////////////////////////////////////
   output [15:0] instruction_o;
   output [15:0] immediate_o;
   output [15:0] Data_one_o; // Rs data
   output [15:0] Data_two_o; // Rt data
   output [2:0] rd_o;
   output [2:0] rs_o;
   output [2:0] rt_o;
   output [2:0] write_sel_o;//register number
   /////////////////////////////////////////////////////////////////////////////////////////

   //flops for CONTROL UNIT SIGNALS//////////////////////////////////////////////////
    dff alu_op_flop[3:0](.q(ALU_op_o), .d(ALU_op), .clk(clk), .rst(rst));
    dff dst_flop[1:0](.q(Dst_reg_o), .d(Dst_reg), .clk(clk), .rst(rst));
    dff pc_src_flop[1:0](.q(PC_src_o), .d(PC_src), .clk(clk), .rst(rst));
    dff ALU_src_flop(.q(ALU_src_o), .d(ALU_src), .clk(clk), .rst(rst));
    dff Reg_write_flop(.q(Reg_write_o), .d(Reg_write), .clk(clk), .rst(rst));
    dff Mem_read_flop(.q(Mem_read_o), .d(Mem_read), .clk(clk), .rst(rst));
    dff Mem_write_flop(.q(Mem_write_o), .d(Mem_write), .clk(clk), .rst(rst));
    dff Mem_reg_flop(.q(Mem_reg_o), .d(Mem_reg), .clk(clk), .rst(rst));
    dff Mem_en_flop(.q(Mem_en_o), .d(Mem_en), .clk(clk), .rst(rst));
    dff halt_flop(.q(halt_o), .d(halt), .clk(clk), .rst(rst));
    dff valid_rd_flop(.q(valid_rd_o), .d(valid_rd), .clk(clk), .rst(rst));
    ////////////////////////////////////////////////////////////////////////////////////////

    //flops for NOT CONTROL UNIT SIGNALS//////////////////////////////////////////////////////
    dff ins_flop[15:0](.q(instruction_o), .d(instruction), .clk(clk), .rst(rst));
    dff imm_flop[15:0](.q(immediate_o), .d(immediate), .clk(clk), .rst(rst));
    dff Data_one_flop[15:0](.q(Data_one_o), .d(Data_one), .clk(clk), .rst(rst));
    dff Data_two_flop[15:0](.q(Data_two_o), .d(Data_two), .clk(clk), .rst(rst));
    dff rd_flop [2:0] (.q(rd_o), .d(rd), .clk(clk), .rst(rst));
    dff rs_flop [2:0] (.q(rs_o), .d(rs), .clk(clk), .rst(rst));
    dff rt_flop [2:0] (.q(rt_o), .d(rt), .clk(clk), .rst(rst));
    dff ws_flop [2:0] (.q(write_sel_o), .d(write_sel), .clk(clk), .rst(rst));
    /////////////////////////////////////////////////////////////////////////////////////////

endmodule
