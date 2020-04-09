module forward_unit(execute_data, memory_read_data, mem_address, data_one, reg_2 ,rd_d, rs_d, rt_d, rd_e, rs_e, rd_m, rs_m,
  reg_write_ex, reg_write_mem, mem_read_ex, mem_read_mem, valid_rt, instruction_d, instruction_e, instruction_m, valid_rd_e, valid_rd_m);

  input [15:0] execute_data, memory_read_data, mem_address; //data from execute, data from memory
  input [15:0] data_one, reg_2; //data one is RS, reg_2 is Rt or signed immediate...... only override reg_2 if valid_rt is high
  input [2:0] rd_d, rs_d, rt_d; //inputs from decode to excute that may have its value replaced
  input [2:0] rd_e, rs_e; //inputs from execute to memory for ex-ex forwarding
  input [2:0] rd_m, rs_m; //inputs from memory to wb that are used for mem-ex forwarding
  input reg_write_ex, reg_write_mem, valid_rd_e, valid_rd_m;
  input mem_read_ex, mem_read_mem;
  input valid_rt; //used in conjunction with reg_2
  input [15:0] instruction_d, instruction_e, instruction_m;

  wire [4:0] opcode_d;
  assign opcode_d = instruction_d[15:11];

  wire [4:0] opcode_e = instruction_e[15:11];

  wire [4:0]opcode_m;
  assign opcode_m = instruction_m[15:11];


 //insturctions writing to RS
  localparam stu = 5'b10011;
  localparam lbi = 5'b11000;
  localparam slbi = 5'b10010;

  //instructions writing to R7 unconditionally
  localparam jal = 5'b00110;
  localparam jalr = 5'b00111;

  //this wire is used for detecting if instruction is writing to RS in execute/mem stage
wire ex_write_rs;
assign ex_write_rs = ((stu == opcode_e) | (lbi == opcode_e) | (slbi == opcode_e));

//this wire is used for detecting if instruction is writing to RS in the mem/wb stage
wire mem_write_rs;
assign mem_write_rs = ((stu == opcode_m) | (lbi == opcode_m) | (slbi == opcode_m));

//this wire is used for detecting if instruction is writing to R7 in ex-mem stage
wire ex_write_R7;
assign ex_write_R7 = ((jalr == opcode_e) | (jal == opcode_e));

//this wire is used for detecting if instruction is writing to R7 in mem-wb stage
wire mem_write_R7;
assign mem_write_R7 = ((jalr == opcode_m) | (jal == opcode_m));



//this wire is used for detecting if instruction is writing to RD in the execute/mem stage and not a memory read
wire ex_write_rd;
assign ex_write_rd = valid_rd_e & reg_write_ex & (~mem_read_ex);

//this wire is used for detecting if instruction is writing to RD mem/wb stage, will need to use mem_read to determine the proper value to update it with
wire mem_write_rd;
assign mem_write_rd = valid_rd_e & reg_write_mem;

//this wire is used for detecting if both instructions in front of us are writing to the same register, if this is the case then we will need to take wire from
//execute to mem stage ..... doing this in multiple parts for code clarity, will evnetually need to include functionaliy for R7.. should be 6 cases i think
wire take_ex; //final wire that will be or reduced

wire take_ex_helper1; //case of both writing to the same Rd for say like a subtract and an add or something in front of us
assign take_ex_helper1 = ((ex_write_rd & mem_write_rd) & (rd_e == rd_m))  ? 1'b1 : 1'b0;

wire take_ex_helper2; //case of mem-wb writing to RS and that RS equals the RD of ex-mem
assign take_ex_helper2 = (mem_write_rs & ex_write_rd & (rs_m == rd_e)) ? 1'b1 : 1'b0;

wire take_ex_helper3; //case of both writing to RS
assign take_ex_helper3 = (ex_write_rs & mem_write_rs & (rs_e == rs_m)) ? 1'b1: 1'b0;

wire take_ex_helper4; //case of ex-mem writing to rs and mem-wb writing to rs
assign take_ex_helper4 = (mem_write_rd & ex_write_rs & (rs_e == rd_m)) ? 1'b1 : 1'b0;



//area for checking if instruction could possibly have RT value replaced for add, sub, xor, andn, rol, sll, ror, srl, seq, slt, sle, sco




//area for checking if instructions Rs could be replaced for all insturctions other than halt, nop, j, jalr, siic, and rti




//area for checking if RD can be replaced for instructions like store and stu





//thoughts:
//i think the only two potential stall cases are now for branching and load operations but could be completely wrong -_-















endmodule
