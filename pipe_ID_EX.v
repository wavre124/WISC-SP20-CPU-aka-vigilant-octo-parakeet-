module pipe_IF_ID(clk, rst, ALU_op, branch_jump_op, EXT_op, Dst_reg, PC_src, ALU_src, EXT_sign, Reg_write, Mem_read, Mem_write, JAL, Mem_reg, Mem_en, Excp, Data_one, Data_two, br_ju_addr, inc_pc, opcode, rd, rs, err, ALU_op_o, branch_jump_op_o, Ext_op_o, Dst_reg_o, PC_src_o, ALU_src_o, Ext_sign_o, Reg_write_o, Mem_read_o, Mem_write_o, JAL_o, Mem_reg_o, Mem_en_o, Excp_o, Data_one_o, Data_two_o, br_ju_addr_o, inc_pc_o, opcode_o, rd_o, rs_o, err_o);
 
 
 input clk, rst;
 
  //inputs that are CONTROL UNIT SIGNALS//////////////////////////////////////////////////
  input [3:0] ALU_op;
  input [2:0] branch_jump_op; 
  input [1:0] Ext_op, Dst_reg, PC_src;
  input ALU_src, Ext_sign, Reg_write, Mem_read, Mem_write, JAL, Mem_reg, Mem_en, Excp;
  /////////////////////////////////////////////////////////////////////////////////////////
  
  //inputs that are NOT CONTROL UNIT SIGNALS/////////////////////////////////////////////////
   input [15:0] Data_one; // Rs data
   input [15:0] Data_two; // Rt data
   input [15:0] br_ju_addr;
   input [15:0] inc_pc;
   input [4:0] opcode; 
   input [2:0] rd;//register number
   input [2:0] rs;//register number
   input err;
  ///////////////////////////////////////////////////////////////////////////////////////////
  
  //outputs that are CONTROL UNIT SIGNALS///////////////////////////////////////////////////
  output [3:0] ALU_op_o;
  output [2:0] branch_jump_op_o; 
  output [1:0] Ext_op_o, Dst_reg_o, PC_src_o;
  output ALU_src_o, Ext_sign_o, Reg_write_o, Mem_read_o, Mem_write_o, JAL_o, Mem_reg_o, Mem_en_o, Excp_o;
  ///////////////////////////////////////////////////////////////////////////////////
  
  //outputs that are NOT CONTROL UNIT SIGNALS///////////////////////////////////////////////
   output [15:0] Data_one_o; // Rs data
   output [15:0] Data_two_o; // Rt data
   output [15:0] br_ju_addr_o;
   output [15:0] inc_pc_o; 
   output [4:0] opcode_o;
   output [2:0] rd_o;
   output [2:0} rs_o;
   output err_o;
   /////////////////////////////////////////////////////////////////////////////////////////
   
   
   //flops for CONTROL UNIT SIGNALS//////////////////////////////////////////////////
    dff alu_op_flop[3:0](.q(ALU_op_o), .d(ALU_op), .clk(clk), .rst(rst));
    dff b_j_flop[2:0](.q(branch_jump_op_o), .d(branch_jump_op), .clk(clk), .rst(rst));
    dff ext_flop[1:0](.q(Ext_op), .d(Ext_op), .clk(clk), .rst(rst));
    dff dst_flop[1:0](.q(Dst_reg_o), .d(Dst_reg), .clk(clk), .rst(rst));
    dff pc_src_flop[1:0](.q(PC_src_o), .d(PC_src), .clk(clk), .rst(rst));
    dff ALU_src_flop(.q(ALU_src_o), .d(ALU_src), .clk(clk), .rst(rst));
    dff EXT_sign_flop(.q(Ext_sign_o), .d(Ext_sign), .clk(clk), .rst(rst));
    dff Reg_write_flop(.q(Reg_write_o), .d(Reg_write), .clk(clk), .rst(rst));
    dff Mem_read_flop(.q(Mem_read_o), .d(Mem_read), .clk(clk), .rst(rst));
    dff Mem_write_flop(.q(Mem_write_o), .d(Mem_write), .clk(clk), .rst(rst));
    dff JAL_flop(.q(JAL_o), .d(JAL), .clk(clk), .rst(rst));
    dff Mem_reg_flop(.q(Mem_reg_o), .d(Mem_reg), .clk(clk), .rst(rst));
    dff Mem_en_flop(.q(Mem_en_o), .d(Mem_en), .clk(clk), .rst(rst));
    dff Excp_flop(.q(Excp_o), .d(Excp), .clk(clk), .rst(rst));
    ////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    //flops for NOT CONTROL UNIT SIGNALS//////////////////////////////////////////////////////
    dff Data_one_flop[15:0](.q(Data_one_o), .d(Data_one), .clk(clk), .rst(rst));
    dff Data_two_flop[15:0](.q(Data_two_o), .d(Data_two), .clk(clk), .rst(rst));
    dff br_ju_addr_flop[15:0](.q(br_ju_addr_o), .d(br_ju_addr), .clk(clk), .rst(rst));
    dff inc_pc_flop[15:0](.q(inc_pc_o), .d(inc_pc), .clk(clk), .rst(rst));
    dff opcode_flop [4:0](.q(opcode_o), .d(opcode), .clk(clk), .rst(rst));
    dff rd_flop [2:0] (.q(rd_0), .d(rd), .clk(clk), .rst(rst));
    dff rs_flop [2:0] (.q(rs_0), .d(rs), .clk(clk), .rst(rst));
    dff err_flop(.q(err_o), .d(err), .clk(clk), .rst(rst));
    /////////////////////////////////////////////////////////////////////////////////////////
    
    



endmodule
