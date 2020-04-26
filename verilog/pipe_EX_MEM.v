module pipe_EX_MEM(clk, rst, instruction, data_out, data_two, RD, RS, Dst_reg, PC_src, Reg_write, Mem_read, Mem_write, Mem_reg,
                   Mem_en, write_sel, instruction_o, data_out_o, data_two_o, RD_o, RS_o, Dst_reg_o, PC_src_o, Reg_write_o, Mem_read_o,
                   Mem_write_o, Mem_reg_o, Mem_en_o, write_sel_o, halt, halt_o, valid_rd, valid_rd_o, JAL, JAL_o, bj_write_data, bj_write_data_o,
                   inst_mis_align, inst_mis_align_o, d_Stall, d_done);
  input clk;
  input rst;

//inputs that are not control unit signals//////////////////////////////////////////////////////////////////////
  input [15:0] instruction;
  input [15:0] data_out;
  input [15:0] data_two;
  input [15:0] bj_write_data;
  input [2:0] RD;
  input [2:0] RS;
  input [2:0] write_sel;
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

//inputs that are control unit signals//////////////////////////////////////////////////////////////////////////
  input [1:0] Dst_reg, PC_src;
  input Reg_write, Mem_read, Mem_write, Mem_reg, Mem_en, halt, valid_rd, JAL, inst_mis_align, d_Stall, d_done;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//outputs that are not control unit signals//////////////////////////////////////////////////////////////////////
  output [15:0] instruction_o;
  output [15:0] data_out_o;
  output [15:0] data_two_o;
  output [15:0] bj_write_data_o;
  output [2:0] RD_o;
  output [2:0] RS_o;
  output [2:0] write_sel_o;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//outputs that are control unit signals/////////////////////////////////////////////////////////////////////////
  output [1:0] Dst_reg_o, PC_src_o;
  output Reg_write_o, Mem_read_o, Mem_write_o, Mem_reg_o, Mem_en_o, halt_o, valid_rd_o, JAL_o, inst_mis_align_o;
///////////////////////////////////////////////////////////////////////////////////////////////////

wire [15:0] instruction_wire;
wire [15:0] data_out_wire;
wire [15:0] data_two_wire;
wire [15:0] bj_flop_wire;
wire [2:0] rd_flop_wire;
wire [2:0] rs_flop_wire;
wire [2:0] ws_flop_wire;
wire inst_err_wire;

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

wire d_stall_cond = (~d_done & (Mem_read_o | Mem_write_o));

assign instruction_wire = (d_Stall) ? instruction_o : instruction;
assign data_out_wire = (d_Stall) ? data_out_o : data_out;
assign data_two_wire = (d_Stall) ? data_two_o : data_two;
assign bj_flop_wire = (d_Stall) ? bj_write_data_o : bj_write_data;
assign rd_flop_wire = (d_Stall) ? RD_o : RD;
assign rs_flop_wire = (d_Stall) ? RS_o : RS;
assign ws_flop_wire = (d_Stall) ? write_sel_o : write_sel;
assign inst_err_wire = (d_Stall) ?  inst_mis_align_o : inst_mis_align;

assign Dst_reg_wire = (d_Stall) ? Dst_reg_o : Dst_reg;
assign PC_src_wire = (d_Stall) ?  PC_src_o : PC_src;
assign Reg_write_wire = (d_Stall) ?  Reg_write_o : Reg_write;
assign Mem_read_wire = (d_Stall) ?  Mem_read_o : Mem_read;
assign Mem_write_wire = (d_Stall) ?  Mem_write_o : Mem_write;
assign Mem_reg_wire = (d_Stall) ?  Mem_reg_o : Mem_reg;
assign Mem_en_wire = (d_Stall) ?  Mem_en_o : Mem_en;
assign halt_wire = (d_Stall) ?  halt_o : halt;
assign valid_rd_wire = (d_Stall) ?  valid_rd_o : valid_rd;
assign JAL_wire = (d_Stall) ?  JAL_o : JAL;

//flops that are not control unit signals/////////////////////////////////////////////////////////////////////////
  dff ins_flops[15:0](.q(instruction_o), .d(instruction_wire), .clk(clk), .rst(rst));
  dff data_out_flop[15:0](.q(data_out_o), .d(data_out_wire), .clk(clk), .rst(rst));
  dff data_two_flop[15:0](.q(data_two_o), .d(data_two_wire), .clk(clk), .rst(rst));
  dff bj_flop[15:0](.q(bj_write_data_o), .d(bj_flop_wire), .clk(clk), .rst(rst));
  dff RD_flop[2:0](.q(RD_o), .d(rd_flop_wire), .clk(clk), .rst(rst));
  dff RS_flop[2:0](.q(RS_o), .d(rs_flop_wire), .clk(clk), .rst(rst));
  dff ws_flop[2:0](.q(write_sel_o), .d(ws_flop_wire), .clk(clk), .rst(rst));
  dff inst_err_flop(.q(inst_mis_align_o), .d(inst_err_wire), .clk(clk), .rst(rst));
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//flops for CONTROL UNIT SIGNALS//////////////////////////////////////////////////
    dff dst_flop[1:0](.q(Dst_reg_o), .d(Dst_reg_wire), .clk(clk), .rst(rst));
    dff pc_src_flop[1:0](.q(PC_src_o), .d(PC_src_wire), .clk(clk), .rst(rst));
    dff Reg_write_flop(.q(Reg_write_o), .d(Reg_write_wire), .clk(clk), .rst(rst));
    dff Mem_read_flop(.q(Mem_read_o), .d(Mem_read_wire), .clk(clk), .rst(rst));
    dff Mem_write_flop(.q(Mem_write_o), .d(Mem_write_wire), .clk(clk), .rst(rst));
    dff Mem_reg_flop(.q(Mem_reg_o), .d(Mem_reg_wire), .clk(clk), .rst(rst));
    dff Mem_en_flop(.q(Mem_en_o), .d(Mem_en_wire), .clk(clk), .rst(rst));
    dff halt_flop(.q(halt_o), .d(halt_wire), .clk(clk), .rst(rst));
    dff valid_rd_flop(.q(valid_rd_o), .d(valid_rd_wire), .clk(clk), .rst(rst));
    dff JAL_flop(.q(JAL_o), .d(JAL_wire), .clk(clk), .rst(rst));
////////////////////////////////////////////////////////////////////////////////////////

endmodule
