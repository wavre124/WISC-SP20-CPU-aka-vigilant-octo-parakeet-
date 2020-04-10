/*
   CS/ECE 552 Spring '20

   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
module execute (data_1, data_2, signed_immediate, ALU_src, ALU_op, data_out, rd_d, rs_d, rt_d,
  rd_e, rs_e, rd_m, rs_m, execute_data, memory_read_data, mem_address, reg_write_ex, reg_write_mem,
  mem_read_ex, mem_read_mem, valid_rt, instruction_d, instruction_e, instruction_m, valid_rd_e, valid_rd_m);


  input [2:0] rd_d, rs_d, rt_d; //thse are the registers from decode to execuite that stage will have the value get forwarded to them
  input [2:0] rd_e, rs_e;//these are the registers from execute to memory that will potentiall have its value forwared into the decode registers
  input [2:0] rd_m, rs_m; //inputs from memory to wb that are used for mem-ex forwarding
  input [15:0] execute_data;
  input [15:0] memory_read_data , mem_address;
  input reg_write_ex, reg_write_mem, mem_read_ex, mem_read_mem, valid_rt, valid_rd_e, valid_rd_m;
  input [15:0] instruction_d, instruction_e, instruction_m;

  input [15:0] data_1, data_2, signed_immediate;
  input [3:0] ALU_op;
  input ALU_src;
  output [15:0] data_out;
  wire [15:0] reg_2;
  wire [15:0] data_1_helper;
  wire [15:0] reg_2_helper;
  //00 is for RT
  //01 is for signed immediate passed in from decode stage
  mux2_1_N mux1 (.InA(data_2), .InB(signed_immediate), .S(ALU_src), .Out(reg_2));

  alu alu1(.InA(data_1_helper), .InB(reg_2_helper), .Op(ALU_op), .Out(data_out), .Zero(), .Ofl());

  forward_unit forward1(.execute_data(execute_data), .memory_read_data(memory_read_data), .mem_address(mem_address), .data_one(data_1), .reg_2(reg_2),
    .rd_d(rd_d), .rs_d(rs_d), .rt_d(rt_d), .rd_e(rd_e), .rs_e(rs_e), .rd_m(rd_m), .rs_m(rs_m), .reg_write_ex(reg_write_ex),
    .reg_write_mem(reg_write_mem), .mem_read_ex(mem_read_ex), .mem_read_mem(mem_read_mem), .valid_rt(valid_rt),
    .instruction_d(instruction_d), .instruction_e(instruction_e), .instruction_m(instruction_m), .valid_rd_e(valid_rd_e), .valid_rd_m(valid_rd_m),
    .data_rs(data_1_helper), .reg_2_o(reg_2_helper));

endmodule
