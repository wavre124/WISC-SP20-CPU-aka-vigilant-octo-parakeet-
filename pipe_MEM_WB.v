module pipe_MEM_WB(clk, rst, data_read, address, RD, RS, opcode, Dst_reg, PC_src, Reg_write, Mem_reg, Excp, data_read_o, address_o, RD_o, RS_o, opcode_o);

  
  input clk;
  input rst;
  
  
  //inputs that are not control unit signals//////////////////////////////////
  input [15:0] data_read;
  input [15:0] address;
  input [2:0] RD;
  input [2:0] RS;
  input [4:0] opcode;
  ////////////////////////////////////////////////////////////////////////////
  
  
  
  //inputs that are control unit signals////////////////////////////////////////
  input [1:0] Dst_reg, PC_src;
  input Reg_write, Mem_reg, Excp;
  //////////////////////////////////////////////////////////////////////////////
  

  //outputs that are not control unit signals/////////////////////////////////
  output [15:0] data_read_o;
  output [15:0] address_o;
  output [2:0] RD_o;
  output [2:0] RS_o;
  output [4:0] opcode_o;
  ////////////////////////////////////////////////////////////////////////////
  
  //outputs that are conrol unit signals//////////////////////////////////////
  output [1:0] Dst_reg_o, PC_src_o;
  output Reg_write_o, Mem_reg_o, Excp_o;
 /////////////////////////////////////////////////////////////////////////////
 
 //flops that are not for control unit signals///////////////////////////////////
  dff data_read_flop[15:0](.q(data_read_o), .d(data_read), .clk(clk), .rst(rst));
  dff address_flop[15:0](.q(address_o), .d(address), .clk(clk), .rst(rst));
  dff RD_flop[15:0](.q(RD_o), .d(RD), .clk(clk), .rst(rst));
  dff RS_flop[15:0](.q(RS_o), .d(RS_two), .clk(clk), .rst(rst));
  dff opcode_flop[15:0](.q(opcode_o), .d(opcode), .clk(clk), .rst(rst));
 ////////////////////////////////////////////////////////////////////////////////
 
 //flops that are for control unit signals//////////////////////////////////////
    dff dst_flop[1:0](.q(Dst_reg_o), .d(Dst_reg), .clk(clk), .rst(rst));
    dff pc_src_flop[1:0](.q(PC_src_o), .d(PC_src), .clk(clk), .rst(rst));
    dff Reg_write_flop(.q(Reg_write_o), .d(Reg_write), .clk(clk), .rst(rst));
    dff Mem_reg_flop(.q(Mem_reg_o), .d(Mem_reg), .clk(clk), .rst(rst));
    dff Excp_flop(.q(Excp_o), .d(Excp), .clk(clk), .rst(rst));
 ////////////////////////////////////////////////////////////////////////////////


endmodule

