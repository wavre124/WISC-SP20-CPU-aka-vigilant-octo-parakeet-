module pipe_ID_EX(clk, rst, halt, ALU_op, Dst_reg, PC_src, ALU_src, Reg_write, Mem_read, Mem_write, Mem_reg, Mem_en, valid_rd,
                  instruction, immediate, Data_one, Data_two, rd, rs, rt, write_sel, halt_o, ALU_op_o,
                  Dst_reg_o, PC_src_o, ALU_src_o, Reg_write_o, Mem_read_o, Mem_write_o, Mem_reg_o,
                  Mem_en_o, instruction_o, immediate_o, Data_one_o, Data_two_o, rd_o, rs_o, rt_o, write_sel_o, valid_rd_o, stall_decode, JAL, JAL_o,
                  bj_write_data, bj_write_data_o, instruction_ex, valid_rt, valid_rt_o);

  input clk, rst;

  //inputs that are CONTROL UNIT SIGNALS//////////////////////////////////////////////////
  input [3:0] ALU_op;
  input [1:0] Dst_reg, PC_src;
  input ALU_src, Reg_write, Mem_read, Mem_write, Mem_reg, Mem_en, halt, valid_rd;
  input valid_rt;
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
  output valid_rt_o;
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
   //flops for CONTROL UNIT SIGNALS//////////////////////////////////////////////////
    dff alu_op_flop[3:0](.q(ALU_op_o), .d(ALU_op), .clk(clk), .rst(rst));
    dff dst_flop[1:0](.q(Dst_reg_o), .d(Dst_reg), .clk(clk), .rst(rst));
    dff pc_src_flop[1:0](.q(PC_src_o), .d(PC_src), .clk(clk), .rst(rst));
    dff ALU_src_flop(.q(ALU_src_o), .d(ALU_src), .clk(clk), .rst(rst));
    dff Reg_write_flop(.q(Reg_write_o), .d(Reg_write_s), .clk(clk), .rst(rst));
    dff Mem_read_flop(.q(Mem_read_o), .d(Mem_read_s), .clk(clk), .rst(rst));
    dff Mem_write_flop(.q(Mem_write_o), .d(Mem_write_s), .clk(clk), .rst(rst));
    dff Mem_reg_flop(.q(Mem_reg_o), .d(Mem_reg), .clk(clk), .rst(rst));
    dff Mem_en_flop(.q(Mem_en_o), .d(Mem_en), .clk(clk), .rst(rst));
    dff halt_flop(.q(halt_o), .d(halt_s), .clk(clk), .rst(rst));
    dff valid_rd_flop(.q(valid_rd_o), .d(valid_rd), .clk(clk), .rst(rst));
    dff JAL_flop(.q(JAL_o), .d(JAL), .clk(clk), .rst(rst));
    dff valid_rt_flop(.q(valid_rt_o), .d(valid_rt), .clk(clk), .rst(rst));
    ////////////////////////////////////////////////////////////////////////////////////////

    //flops for NOT CONTROL UNIT SIGNALS//////////////////////////////////////////////////////
    dff ins_flop[15:0](.q(instruction_o), .d(instruction_s), .clk(clk), .rst(rst));
    dff imm_flop[15:0](.q(immediate_o), .d(immediate), .clk(clk), .rst(rst));
    dff Data_one_flop[15:0](.q(Data_one_o), .d(Data_one), .clk(clk), .rst(rst));
    dff Data_two_flop[15:0](.q(Data_two_o), .d(Data_two), .clk(clk), .rst(rst));
    dff bj_flop[15:0](.q(bj_write_data_o), .d(bj_write_data), .clk(clk), .rst(rst));
    dff rd_flop [2:0] (.q(rd_o), .d(rd), .clk(clk), .rst(rst));
    dff rs_flop [2:0] (.q(rs_o), .d(rs), .clk(clk), .rst(rst));
    dff rt_flop [2:0] (.q(rt_o), .d(rt), .clk(clk), .rst(rst));
    dff ws_flop [2:0] (.q(write_sel_o), .d(write_sel), .clk(clk), .rst(rst));
    /////////////////////////////////////////////////////////////////////////////////////////

endmodule
