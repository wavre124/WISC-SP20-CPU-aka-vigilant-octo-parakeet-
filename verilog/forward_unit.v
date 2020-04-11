module forward_unit(execute_data, memory_read_data, mem_address, data_one, reg_2 ,rd_d, rs_d, rt_d, rd_e, rs_e, rd_m, rs_m,
  reg_write_ex, reg_write_mem, mem_read_ex, mem_read_mem, valid_rt, instruction_d, instruction_e, instruction_m, valid_rd_e,
  valid_rd_m, data_rs, reg_2_o);

  input [15:0] execute_data, memory_read_data, mem_address; //data from execute, data from memory
  input [15:0] data_one, reg_2; //data one is RS, reg_2 is Rt or signed immediate...... only override reg_2 if valid_rt is high
  input [2:0] rd_d, rs_d, rt_d; //inputs from decode to excute that may have its value replaced
  input [2:0] rd_e, rs_e; //inputs from execute to memory for ex-ex forwarding
  input [2:0] rd_m, rs_m; //inputs from memory to wb that are used for mem-ex forwarding
  input reg_write_ex, reg_write_mem, valid_rd_e, valid_rd_m;
  input mem_read_ex, mem_read_mem;
  input valid_rt; //used in conjunction with reg_2
  input [15:0] instruction_d, instruction_e, instruction_m;

  wire [15:0] data_rt;
  output [15:0] data_rs;
  wire [15:0] data_rd;
  output [15:0] reg_2_o;
  wire need_rd;
  assign reg_2_o = (need_rd) ? data_rd : data_rt;


  wire [4:0] opcode_d;
  assign opcode_d = instruction_d[15:11];

  wire [4:0] opcode_e = instruction_e[15:11];

  wire [4:0]opcode_m;
  assign opcode_m = instruction_m[15:11];



 localparam R7 = 3'b111;
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

//dont want to use forwarding on branch even though i think this is irrelavant
localparam beqz = 5'b01100;
localparam bnez = 5'b01101;
localparam bltz = 5'b01110;
localparam bgez = 5'b01111;
wire branch;
assign branch =  (beqz == opcode_d) | (bnez == opcode_d) | (bltz == opcode_d) | (bgez == opcode_d);

//this wire is used for detecting if both instructions in front of us are writing to the same register, if this is the case then we will need to take wire from
//execute to mem stage ..... doing this in multiple parts for code clarity
wire take_ex; //final wire that will be or reduced


wire take_ex_helper1; //case of both writing to the same Rd for say like a subtract and an add or something in front of us
assign take_ex_helper1 = ((ex_write_rd & mem_write_rd) & (rd_e == rd_m))  ? 1'b1 : 1'b0;

wire take_ex_helper2; //case of mem-wb writing to RS and that RS equals the RD of ex-mem
assign take_ex_helper2 = (mem_write_rs & ex_write_rd & (rs_m == rd_e)) ? 1'b1 : 1'b0;

wire take_ex_helper3; //case of both writing to RS
assign take_ex_helper3 = (ex_write_rs & mem_write_rs & (rs_e == rs_m)) ? 1'b1: 1'b0;

wire take_ex_helper4; //case of ex-mem writing to rs and mem-wb writing to rs
assign take_ex_helper4 = (mem_write_rd & ex_write_rs & (rs_e == rd_m)) ? 1'b1 : 1'b0;

wire take_ex_helper5; //this wire is used to detect if jal/jalr instruction is writing to R7 in execute-mem and other instruction is writing to RS which is r7 in mem-wb
assign take_ex_helper5 = (mem_write_rs & (rs_m == R7) & ex_write_R7) ? 1'b1 : 1'b0;

wire take_ex_helper6; //this wire is similar to above but except checking if instruction writing to R7 is register RD
assign take_ex_helper6 = (mem_write_rd & (rd_m == R7) & ex_write_R7) ? 1'b1 : 1'b0;

wire take_ex_helper7; //this wire is used for checking if instruction in mem-wb is writing to R7 and Rs is writing to R7 in ex-mem
assign take_ex_helper7 = (mem_write_R7 & ex_write_rs & (rs_e == R7)) ? 1'b1 : 1'b0;

wire take_ex_helper8; //this wire is used for checking if isntruction in mem-wb is writing to R7 and instruction in ex-mem is writing to Rd which is R7
assign take_ex_helper8 = (mem_write_R7 & ex_write_rd & (rd_e == R7)) ? 1'b1 : 1'b0;


assign take_ex = take_ex_helper1 | take_ex_helper2 | take_ex_helper3 | take_ex_helper4 | take_ex_helper5 | take_ex_helper6 | take_ex_helper7 | take_ex_helper8;


//area for checking if instruction could possibly have RT value replaced for add, sub, xor, andn, rol, sll, ror, srl, seq, slt, sle, sco
wire replace_rt_ex; //used to check if RT should be replaced with ex value
wire replace_rt_mem;//used to check if RT should be replaced with mem value

assign replace_rt_ex = (valid_rt & (((rt_d == rd_e) & ex_write_rd) | ((rt_d == rs_e) & ex_write_rs) | ((rt_d == R7) & ex_write_R7))) ? 1'b1 : 1'b0;
assign replace_rt_mem = (valid_rt & (((rt_d == rd_m) & mem_write_rd) | ((rt_d == rs_m) & mem_write_rs) | ((rt_d == R7) & mem_write_R7))) ? 1'b1 : 1'b0;
assign data_rt = ((~take_ex) & replace_rt_mem & mem_read_mem) ? memory_read_data :
                  ((~take_ex) & replace_rt_mem ) ? mem_address :
                  (replace_rt_ex) ? execute_data : reg_2;


//area for checking if instructions Rs could be replaced for all insturctions other than halt, nop, j, jal, siic, lbi  ,and rti

localparam j = 5'b00100;
localparam nop = 5'b00001;
localparam halt = 5'b00000;
localparam siic = 5'b00010;
localparam rti = 5'b00011;

wire no_forward_rs;
assign no_forward_rs =  ((jalr == opcode_d) | (j == opcode_d) | (nop == opcode_d) | (lbi == opcode_d) | (halt == opcode_d) | (siic == opcode_d) | (rti== opcode_d));
wire replace_rs_ex;
wire replace_rs_mem;
assign replace_rs_ex = ((~no_forward_rs) & (((rs_d == rd_e) & ex_write_rd) | ((rs_d == rs_e) & ex_write_rs) |  ((rt_d == R7) & ex_write_R7)));
assign replace_rs_mem = ((~no_forward_rs) & (((rs_d == rd_m) & mem_write_rd) | ((rs_d == rs_m) & mem_write_rs) |  ((rt_d == R7) & mem_write_R7)));
assign data_rs = ((~take_ex) & replace_rs_mem & mem_read_mem) ? memory_read_data :
                  ((~take_ex) & replace_rs_mem) ? mem_address :
                  (replace_rs_ex) ? execute_data : data_one;


//area for checking if RD can be replaced for instructions like store and stu
wire replace_rd_ex;
wire replace_rd_mem;

localparam store = 5'b10000;

assign need_rd = ((opcode_d == stu) | (opcode_d == store));

assign replace_rd_ex = ((need_rd) & (((rd_d == rd_e) & ex_write_rd) | ((rd_d == rs_e) & ex_write_rs) |  ((rd_d == R7) & ex_write_R7)));
assign replace_rd_mem = ((need_rd) & (((rd_d == rd_m) & mem_write_rd) | ((rd_d == rs_m) & mem_write_rs) |  ((rd_d == R7) & mem_write_R7)));
assign data_rd = ((~take_ex) & replace_rd_mem & mem_read_mem) ? memory_read_data :
                  ((~take_ex) & replace_rd_mem) ? mem_address :
                  (replace_rd_ex) ? execute_data : reg_2;







//thoughts:
//i think the only two potential stall cases are now for branching and load operations but could be completely wrong -_-















endmodule
