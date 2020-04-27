module pipe_MEM_WB(clk, rst, instruction, data_read, address, RD, RS, Dst_reg, PC_src,
                   Reg_write, Mem_reg, Mem_read, Mem_write, write_sel, Mem_en, instruction_o,
                   data_read_o, address_o, RD_o, RS_o, Dst_reg_o, PC_src_o,
                   Reg_write_o, Mem_reg_o, Mem_read_o, Mem_write_o, write_sel_o, Mem_en_o, halt, halt_o, valid_rd, valid_rd_o, JAL, JAL_o,
                   bj_write_data, bj_write_data_o, inst_misalign, mem_misalign, err, d_done, d_Stall, inst_stall);

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

  input inst_misalign, mem_misalign, d_done, d_Stall, inst_stall;

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
  output Reg_write_o, Mem_reg_o, Mem_read_o, Mem_write_o, Mem_en_o, halt_o, valid_rd_o, JAL_o, err;
 /////////////////////////////////////////////////////////////////////////////

 wire err_wire;

 assign err_wire = inst_misalign | mem_misalign;

 // this ensures that the data read out of the memory blk that goes into the WB stage
 // only uses data when the DONE signal goes high in the cache controller

 localparam nop  = 16'b0000_1000_0000_0000;

 wire [15:0] instruction_wire;
 wire [15:0] address_wire;
 wire [15:0] data_read_wire;
 wire [15:0] bj_flop_wire;
 wire [2:0] rd_flop_wire;
 wire [2:0] rs_flop_wire;
 wire [2:0] ws_flop_wire;

 wire [1:0] Dst_reg_wire;
 wire [1:0] PC_src_wire;
 wire Reg_write_wire;
 wire Mem_read_wire;
 wire Mem_write_wire;
 wire Mem_reg_wire;
 wire Mem_en_wire;
 wire halt_wire;
 wire valid_rd_wire;
 wire JAL_wire;
 wire err_wire_two;

 assign instruction_wire = (d_Stall) ? nop : instruction;
 assign data_read_wire = (d_Stall) ? data_read_o : data_read;
 assign address_wire = (d_Stall) ? 16'b0 : address;
 assign bj_flop_wire = (d_Stall) ? 16'b0 : bj_write_data;
 assign rd_flop_wire = (d_Stall) ? 3'b0 : RD;
 assign rs_flop_wire = (d_Stall) ? 3'b0 : RS;
 assign ws_flop_wire = (d_Stall) ? 3'b0 : write_sel;

 assign Dst_reg_wire = (d_Stall) ? 2'b0 : Dst_reg;
 assign PC_src_wire = (d_Stall) ?  2'b0 : PC_src;
 assign Reg_write_wire = (d_Stall) ?  1'b0 : Reg_write;
 assign Mem_read_wire = (d_Stall) ?  1'b0 : Mem_read;
 assign Mem_write_wire = (d_Stall) ?  1'b0 : Mem_write;
 assign Mem_reg_wire = (d_Stall) ?  1'b0 : Mem_reg;
 assign Mem_en_wire = (d_Stall) ?  1'b0 : Mem_en;
 assign halt_wire = (d_Stall) ?  1'b0 : halt;
 assign valid_rd_wire = (d_Stall) ?  1'b0 : valid_rd;
 assign JAL_wire = (d_Stall) ?  1'b0 : JAL;
 assign err_wire_two = (d_Stall) ? 1'b0 : err_wire;

 //flops that are not for control unit signals///////////////////////////////////
  dff instruction_flop[15:0](.q(instruction_o), .d(instruction_wire), .clk(clk), .rst(rst));
  dff data_read_flop[15:0](.q(data_read_o), .d(data_read_wire), .clk(clk), .rst(rst));
  dff address_flop[15:0](.q(address_o), .d(address_wire), .clk(clk), .rst(rst));
  dff bj_flop[15:0](.q(bj_write_data_o), .d(bj_flop_wire), .clk(clk), .rst(rst));
  dff RD_flop[2:0](.q(RD_o), .d(rd_flop_wire), .clk(clk), .rst(rst));
  dff RS_flop[2:0](.q(RS_o), .d(rs_flop_wire), .clk(clk), .rst(rst));
  dff ws_flop[2:0](.q(write_sel_o), .d(ws_flop_wire), .clk(clk), .rst(rst));
 ////////////////////////////////////////////////////////////////////////////////

 //flops that are for control unit signals//////////////////////////////////////
    dff dst_flop[1:0](.q(Dst_reg_o), .d(Dst_reg_wire), .clk(clk), .rst(rst));
    dff pc_src_flop[1:0](.q(PC_src_o), .d(PC_src_wire), .clk(clk), .rst(rst));
    dff Reg_write_flop(.q(Reg_write_o), .d(Reg_write_wire), .clk(clk), .rst(rst));
    dff Mem_reg_flop(.q(Mem_reg_o), .d(Mem_reg_wire), .clk(clk), .rst(rst));
    dff Mem_read_flop(.q(Mem_read_o), .d(Mem_read_wire), .clk(clk), .rst(rst));
    dff Mem_write_flop(.q(Mem_write_o), .d(Mem_write_wire), .clk(clk), .rst(rst));
    dff Mem_en_flop(.q(Mem_en_o), .d(Mem_en_wire), .clk(clk), .rst(rst));
    dff halt_flop(.q(halt_o), .d(halt_wire), .clk(clk), .rst(rst));
    dff valid_rd_flop(.q(valid_rd_o), .d(valid_rd_wire), .clk(clk), .rst(rst));
    dff JAL_flop(.q(JAL_o), .d(JAL_wire), .clk(clk), .rst(rst));
    dff err_flop(.q(err), .d(err_wire_two), .clk(clk), .rst(rst));
 ////////////////////////////////////////////////////////////////////////////////

endmodule
