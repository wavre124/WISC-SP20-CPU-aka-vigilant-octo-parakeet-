module pipe_EX_MEM(clk, rst, instruction, data_out, data_two, RD, RS, Dst_reg, PC_src, Reg_write, Mem_read, Mem_write, Mem_reg,
                   Mem_en, instruction_o, data_out_o, data_two_o, RD_o, RS_o, Dst_reg_o, PC_src_o, Reg_write_o, Mem_read_o,
                   Mem_write_o, Mem_reg_o, Mem_en_o);
  input clk;
  input rst;

//inputs that are not control unit signals//////////////////////////////////////////////////////////////////////
  input [15:0] instruction;
  input [15:0] data_out;
  input [15:0] data_two;
  input [2:0] RD;
  input [2:0] RS;
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

//inputs that are control unit signals//////////////////////////////////////////////////////////////////////////
  input [1:0] Dst_reg, PC_src;
  input Reg_write, Mem_read, Mem_write, Mem_reg, Mem_en;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//outputs that are not control unit signals//////////////////////////////////////////////////////////////////////
  output [15:0] instruction_o;
  output [15:0] data_out_o;
  output [15:0] data_two_o;
  output [2:0] RD_o;
  output [2:0] RS_o;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//outputs that are control unit signals/////////////////////////////////////////////////////////////////////////
  output [1:0] Dst_reg_o, PC_src_o;
  output Reg_write_o, Mem_read_o, Mem_write_o, Mem_reg_o, Mem_en_o;
///////////////////////////////////////////////////////////////////////////////////////////////////

//flops that are not control unit signals/////////////////////////////////////////////////////////////////////////
  dff ins_flops[15:0](.q(instruction_o), .d(instruction), .clk(clk), .rst(rst));
  dff data_out_flop[15:0](.q(data_out_o), .d(data_out), .clk(clk), .rst(rst));
  dff data_two_flop[15:0](.q(data_two_o), .d(data_two), .clk(clk), .rst(rst));
  dff RD_flop[15:0](.q(RD_o), .d(RD), .clk(clk), .rst(rst));
  dff RS_flop[15:0](.q(RS_o), .d(RS_two), .clk(clk), .rst(rst));
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//flops for CONTROL UNIT SIGNALS//////////////////////////////////////////////////
    dff dst_flop[1:0](.q(Dst_reg_o), .d(Dst_reg), .clk(clk), .rst(rst));
    dff pc_src_flop[1:0](.q(PC_src_o), .d(PC_src), .clk(clk), .rst(rst));
    dff Reg_write_flop(.q(Reg_write_o), .d(Reg_write), .clk(clk), .rst(rst));
    dff Mem_read_flop(.q(Mem_read_o), .d(Mem_read), .clk(clk), .rst(rst));
    dff Mem_write_flop(.q(Mem_write_o), .d(Mem_write), .clk(clk), .rst(rst));
    dff Mem_reg_flop(.q(Mem_reg_o), .d(Mem_reg), .clk(clk), .rst(rst));
    dff Mem_en_flop(.q(Mem_en_o), .d(Mem_en), .clk(clk), .rst(rst));
////////////////////////////////////////////////////////////////////////////////////////

endmodule
