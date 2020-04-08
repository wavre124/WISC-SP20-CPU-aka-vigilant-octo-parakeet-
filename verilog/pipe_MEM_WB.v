module pipe_MEM_WB(clk, rst, instruction, data_read, address, RD, RS, Dst_reg, PC_src,
                   Reg_write, Mem_reg, Mem_read, Mem_write, write_sel, Mem_en, instruction_o,
                   data_read_o, address_o, RD_o, RS_o, Dst_reg_o, PC_src_o,
                   Reg_write_o, Mem_reg_o, Mem_read_o, Mem_write_o, write_sel_o, Mem_en_o, halt, halt_o, valid_rd, valid_rd_o, JAL, JAL_o,
                   bj_write_data, bj_write_data_o, inst_misalign, mem_misalign);

  input clk;
  input rst;

  //inputs that are not control unit signals//////////////////////////////////
  input [15:0] instruction;
  input [15:0] data_read;
  input [15:0] address;
  input [15:0] bj_write_data;
  input [2:0] RD;
  input [2:0] RS;
  input [2:0] write_sel;
  ////////////////////////////////////////////////////////////////////////////

  input inst_misalign, mem_misalign;

  //inputs that are control unit signals////////////////////////////////////////
  input [1:0] Dst_reg, PC_src;
  input Reg_write, Mem_reg, Mem_read, Mem_write, Mem_en, halt, valid_rd, JAL;
  //////////////////////////////////////////////////////////////////////////////

  //outputs that are not control unit signals/////////////////////////////////
  output [15:0] instruction_o;
  output [15:0] data_read_o;
  output [15:0] address_o;
  output [15:0] bj_write_data_o;
  output [2:0] RD_o;
  output [2:0] RS_o;
  output [2:0] write_sel_o;
  ////////////////////////////////////////////////////////////////////////////

  //outputs that are conrol unit signals//////////////////////////////////////
  output [1:0] Dst_reg_o, PC_src_o;
  output Reg_write_o, Mem_reg_o, Mem_read_o, Mem_write_o, Mem_en_o, halt_o, valid_rd_o, JAL_o;
 /////////////////////////////////////////////////////////////////////////////

 wire halt_in;

 assign halt_in = (inst_misalign | mem_misalign) ? 1'b1 : halt;

 //flops that are not for control unit signals///////////////////////////////////
  dff instruction_flop[15:0](.q(instruction_o), .d(instruction), .clk(clk), .rst(rst));
  dff data_read_flop[15:0](.q(data_read_o), .d(data_read), .clk(clk), .rst(rst));
  dff address_flop[15:0](.q(address_o), .d(address), .clk(clk), .rst(rst));
  dff bj_flop[15:0](.q(bj_write_data_o), .d(bj_write_data), .clk(clk), .rst(rst));
  dff RD_flop[2:0](.q(RD_o), .d(RD), .clk(clk), .rst(rst));
  dff RS_flop[2:0](.q(RS_o), .d(RS), .clk(clk), .rst(rst));
  dff ws_flop[2:0](.q(write_sel_o), .d(write_sel), .clk(clk), .rst(rst));
 ////////////////////////////////////////////////////////////////////////////////

 //flops that are for control unit signals//////////////////////////////////////
    dff dst_flop[1:0](.q(Dst_reg_o), .d(Dst_reg), .clk(clk), .rst(rst));
    dff pc_src_flop[1:0](.q(PC_src_o), .d(PC_src), .clk(clk), .rst(rst));
    dff Reg_write_flop(.q(Reg_write_o), .d(Reg_write), .clk(clk), .rst(rst));
    dff Mem_reg_flop(.q(Mem_reg_o), .d(Mem_reg), .clk(clk), .rst(rst));
    dff Mem_read_flop(.q(Mem_read_o), .d(Mem_read), .clk(clk), .rst(rst));
    dff Mem_write_flop(.q(Mem_write_o), .d(Mem_write), .clk(clk), .rst(rst));
    dff Mem_en_flop(.q(Mem_en_o), .d(Mem_en), .clk(clk), .rst(rst));
    dff halt_flop(.q(halt_o), .d(halt_in), .clk(clk), .rst(rst));
    dff valid_rd_flop(.q(valid_rd_o), .d(valid_rd), .clk(clk), .rst(rst));
    dff JAL_flop(.q(JAL_o), .d(JAL), .clk(clk), .rst(rst));
 ////////////////////////////////////////////////////////////////////////////////

endmodule
