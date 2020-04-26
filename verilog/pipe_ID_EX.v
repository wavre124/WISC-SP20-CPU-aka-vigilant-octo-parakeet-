module pipe_ID_EX(clk, rst, halt, ALU_op, Dst_reg, PC_src, ALU_src, Reg_write, Mem_read, Mem_write, Mem_reg, Mem_en, valid_rd,
                  instruction, immediate, Data_one, Data_two, rd, rs, rt, write_sel, halt_o, ALU_op_o,
                  Dst_reg_o, PC_src_o, ALU_src_o, Reg_write_o, Mem_read_o, Mem_write_o, Mem_reg_o,
                  Mem_en_o, instruction_o, immediate_o, Data_one_o, Data_two_o, rd_o, rs_o, rt_o, write_sel_o, valid_rd_o, stall_decode, JAL, JAL_o,
                  bj_write_data, bj_write_data_o, instruction_ex, valid_rt, valid_rt_o, inst_mis_align, inst_mis_align_o, d_Stall);

  input clk, rst;

  //inputs that are CONTROL UNIT SIGNALS//////////////////////////////////////////////////
  input [3:0] ALU_op;
  input [1:0] Dst_reg, PC_src;
  input ALU_src, Reg_write, Mem_read, Mem_write, Mem_reg, Mem_en, halt, valid_rd;
  input valid_rt, inst_mis_align, d_Stall;
  /////////////////////////////////////////////////////////////////////////////////////////

  //inputs that are NOT CONTROL UNIT SIGNALS/////////////////////////////////////////////////
   input [15:0] instruction, instruction_ex;
   input [15:0] immediate;
   input [15:0] Data_one; // Rs data
   input [15:0] Data_two; // Rt data
   input [15:0] bj_write_data;
   input [2:0] rd;//register number
   input [2:0] rs;//register number
   input [2:0] rt;//register number
   input [2:0] write_sel;//register number
   input stall_decode;
   input JAL;
  ///////////////////////////////////////////////////////////////////////////////////////////

  //outputs that are CONTROL UNIT SIGNALS///////////////////////////////////////////////////
  output [3:0] ALU_op_o;
  output [1:0] Dst_reg_o, PC_src_o;
  output ALU_src_o, Reg_write_o, Mem_read_o, Mem_write_o, Mem_reg_o, Mem_en_o, halt_o, valid_rd_o, JAL_o;
  output valid_rt_o, inst_mis_align_o;
  ///////////////////////////////////////////////////////////////////////////////////

  //outputs that are NOT CONTROL UNIT SIGNALS///////////////////////////////////////////////
   output [15:0] instruction_o;
   output [15:0] immediate_o;
   output [15:0] Data_one_o; // Rs data
   output [15:0] Data_two_o; // Rt data
   output [15:0] bj_write_data_o;
   output [2:0] rd_o;
   output [2:0] rs_o;
   output [2:0] rt_o;
   output [2:0] write_sel_o;//register number
   /////////////////////////////////////////////////////////////////////////////////////////

   //check for stall_decode to turn into a nop
   wire [15:0] instruction_s;
   wire Reg_write_s;
   //thought about turning pc_src to a zero but think that would create_dump file too soon
   wire Mem_read_s;
   //mem_reg does not matter
   wire Mem_write_s;
   wire halt_s;
   //i think these are the only important signals
   wire [4:0] opcode;
   localparam siic = 5'b00010;
   localparam rti = 5'b00011;
   assign opcode = instruction_ex[15:11];
   assign instruction_s = ((stall_decode) | (opcode == siic) | (opcode == rti) ) ? 16'h0800 : instruction;
   assign Reg_write_s = ((stall_decode) | (opcode == siic) | (opcode == rti) )? 1'b0 : Reg_write; //honestly not sure if we need this but oh well
   assign Mem_read_s = ((stall_decode) | (opcode == siic) | (opcode == rti) ) ? 1'b0 : Mem_read;
   assign Mem_write_s = ((stall_decode) | (opcode == siic) | (opcode == rti) ) ? 1'b0 : Mem_write;
   assign halt_s = ( (opcode == siic) | (opcode == rti) ) ? 1'b0 : halt;

   wire [15:0] instruction_wire;
   wire [15:0] immediate_wire;
   wire [15:0] data_one_wire;
   wire [15:0] data_two_wire;
   wire [15:0] bj_flop_wire;
   wire [2:0] rd_flop_wire;
   wire [2:0] rs_flop_wire;
   wire [2:0] rt_flop_wire;
   wire [2:0] ws_flop_wire;

   wire [3:0] ALU_op_wire;
   wire [1:0] Dst_reg_wire;
   wire [1:0] PC_src_wire;
   wire ALU_src_wire;
   wire Reg_write_wire;
   wire Mem_read_wire;
   wire Mem_write_wire;
   wire Mem_reg_wire;
   wire Mem_en_wire;
   wire halt_wire;
   wire valid_rd_wire;
   wire JAL_wire;
   wire valid_rt_wire;
   wire inst_err_wire;

   assign instruction_wire = (d_Stall) ? instruction_o : instruction_s;
   assign immediate_wire = (d_Stall) ? immediate_o : immediate;
   assign data_one_wire = (d_Stall) ? Data_one_o : Data_one;
   assign data_two_wire = (d_Stall) ? Data_two_o : Data_two;
   assign bj_flop_wire = (d_Stall) ? bj_write_data_o : bj_write_data;
   assign rd_flop_wire = (d_Stall) ? rd_o : rd;
   assign rs_flop_wire = (d_Stall) ? rs_o : rs;
   assign rt_flop_wire = (d_Stall) ? rt_o : rt;
   assign ws_flop_wire = (d_Stall) ? write_sel_o : write_sel;

   assign ALU_op_wire = (d_Stall) ? ALU_op_o : ALU_op;
   assign Dst_reg_wire = (d_Stall) ? Dst_reg_o : Dst_reg;
   assign PC_src_wire = (d_Stall) ?  PC_src_o : PC_src;
   assign ALU_src_wire = (d_Stall) ?  ALU_src_o : ALU_src;
   assign Reg_write_wire = (d_Stall) ?  Reg_write_o : Reg_write_s;
   assign Mem_read_wire = (d_Stall) ?  Mem_read_o : Mem_read_s;
   assign Mem_write_wire = (d_Stall) ?  Mem_write_o : Mem_write_s;
   assign Mem_reg_wire = (d_Stall) ?  Mem_reg_o : Mem_reg;
   assign Mem_en_wire = (d_Stall) ?  Mem_en_o : Mem_en;
   assign halt_wire = (d_Stall) ?  halt_o : halt_s;
   assign valid_rd_wire = (d_Stall) ?  valid_rd_o : valid_rd;
   assign JAL_wire = (d_Stall) ?  JAL_o : JAL;
   assign valid_rt_wire = (d_Stall) ?  valid_rt_o : valid_rt;
   assign inst_err_wire = (d_Stall) ?  inst_mis_align_o : inst_mis_align;

   //flops for CONTROL UNIT SIGNALS//////////////////////////////////////////////////
    dff alu_op_flop[3:0](.q(ALU_op_o), .d(ALU_op_wire), .clk(clk), .rst(rst));
    dff dst_flop[1:0](.q(Dst_reg_o), .d(Dst_reg_wire), .clk(clk), .rst(rst));
    dff pc_src_flop[1:0](.q(PC_src_o), .d(PC_src_wire), .clk(clk), .rst(rst));
    dff ALU_src_flop(.q(ALU_src_o), .d(ALU_src_wire), .clk(clk), .rst(rst));
    dff Reg_write_flop(.q(Reg_write_o), .d(Reg_write_wire), .clk(clk), .rst(rst));
    dff Mem_read_flop(.q(Mem_read_o), .d(Mem_read_wire), .clk(clk), .rst(rst));
    dff Mem_write_flop(.q(Mem_write_o), .d(Mem_write_wire), .clk(clk), .rst(rst));
    dff Mem_reg_flop(.q(Mem_reg_o), .d(Mem_reg_wire), .clk(clk), .rst(rst));
    dff Mem_en_flop(.q(Mem_en_o), .d(Mem_en_wire), .clk(clk), .rst(rst));
    dff halt_flop(.q(halt_o), .d(halt_wire), .clk(clk), .rst(rst));
    dff valid_rd_flop(.q(valid_rd_o), .d(valid_rd_wire), .clk(clk), .rst(rst));
    dff JAL_flop(.q(JAL_o), .d(JAL_wire), .clk(clk), .rst(rst));
    dff valid_rt_flop(.q(valid_rt_o), .d(valid_rt_wire), .clk(clk), .rst(rst));
    dff inst_err_flop(.q(inst_mis_align_o), .d(inst_err_wire), .clk(clk), .rst(rst));
    ////////////////////////////////////////////////////////////////////////////////////////

    //flops for NOT CONTROL UNIT SIGNALS//////////////////////////////////////////////////////
    dff ins_flop[15:0](.q(instruction_o), .d(instruction_wire), .clk(clk), .rst(rst));
    dff imm_flop[15:0](.q(immediate_o), .d(immediate_wire), .clk(clk), .rst(rst));
    dff Data_one_flop[15:0](.q(Data_one_o), .d(data_one_wire), .clk(clk), .rst(rst));
    dff Data_two_flop[15:0](.q(Data_two_o), .d(data_two_wire), .clk(clk), .rst(rst));
    dff bj_flop[15:0](.q(bj_write_data_o), .d(bj_flop_wire), .clk(clk), .rst(rst));
    dff rd_flop [2:0] (.q(rd_o), .d(rd_flop_wire), .clk(clk), .rst(rst));
    dff rs_flop [2:0] (.q(rs_o), .d(rs_flop_wire), .clk(clk), .rst(rst));
    dff rt_flop [2:0] (.q(rt_o), .d(rt_flop_wire), .clk(clk), .rst(rst));
    dff ws_flop [2:0] (.q(write_sel_o), .d(ws_flop_wire), .clk(clk), .rst(rst));
    /////////////////////////////////////////////////////////////////////////////////////////

endmodule
