module hazard_det(rd_ID_EX, rt, rs,
                  rd_EX_MEM, rs_ID_EX, EX_MEM_reg_write, EX_MEM_ins, rs_EX_MEM,
                  MEM_wb_reg_write, MEM_wb_ins, PC_source, stall_decode, flush_fetch, EX_MEM_valid_rd, MEM_wb_valid_rd, curr_ins);

input [2:0] rd_ID_EX;
input [2:0] rt;
input [2:0] rs;
input [15:0] curr_ins;
input [2:0] rd_EX_MEM;
input [2:0] rs_ID_EX;
input EX_MEM_reg_write;
input [15:0] EX_MEM_ins;
input EX_MEM_valid_rd, MEM_wb_valid_rd;
input [2:0] rs_EX_MEM;
input MEM_wb_reg_write;
input [15:0] MEM_wb_ins;
input [1:0] PC_source;
wire [5:0] opcode;
wire [2:0] RD;
// stalling the pipe_ID_EX
//output stall_execute;
assign opcode = curr_ins[15:11];
// stalling the pipe_IF_ID
output stall_decode;
output flush_fetch;

// assume branch taken for all branch/control hazards

assign RD = curr_ins[7:5];

localparam stu = 5'b10011;
localparam jal = 5'b00110;
localparam jalr = 5'b00111;
localparam lbi = 5'b11000;
localparam store = 5'b10000; 
localparam slbi = 5'b10010; 
wire [4:0] EX_MEM_op;
wire [4:0] MEM_wb_op;

assign EX_MEM_op = EX_MEM_ins[15:11];
assign MEM_wb_op = MEM_wb_ins[15:11];

wire ex_mem_reg_valid_rd;
assign ex_mem_reg_valid_rd = EX_MEM_reg_write & EX_MEM_valid_rd;
wire rs_rt_1;
assign rs_rt_1 = (rd_ID_EX == rt  | rd_ID_EX == rs);
wire mem_reg_valid_rd;
assign mem_reg_valid_rd = MEM_wb_reg_write & EX_MEM_valid_rd;
wire rs_rt_2;
assign rs_rt_2 = (rd_EX_MEM == rt) | (rd_EX_MEM == rs);
wire rs_rt_d;
assign rs_rt_d = (rd_ID_EX == RD);
wire rs_rt_d2;
assign rs_rt_d2 = (rd_EX_MEM == RD) | (rd_EX_MEM == RD);
wire write_rs_ex_mem;
assign write_rs_ex_mem = ((EX_MEM_op == lbi) | (EX_MEM_op == stu) | (EX_MEM_op == slbi));
wire write_rs_mem_wb;
assign write_rs_mem_wb = ((MEM_wb_op == lbi) | (MEM_wb_op == stu) | (MEM_wb_op == slbi));
wire rs_reg_ex_mem;
assign rs_reg_ex_mem =  (rs_ID_EX == RD);

wire rs_reg_mem_wb;
assign rs_reg_mem_wb = (rs_EX_MEM == RD);


assign stall_decode = (ex_mem_reg_valid_rd & rs_rt_1) ? 1'b1 :
                      (mem_reg_valid_rd & rs_rt_2) ? 1'b1 :
			                ((opcode == store | opcode == stu) & (((ex_mem_reg_valid_rd & rs_rt_d) | (mem_reg_valid_rd & rs_rt_d2)) | (write_rs_ex_mem & rs_reg_ex_mem) | (write_rs_mem_wb &                        rs_reg_mem_wb))) ? 1'b1 :
                      ((write_rs_ex_mem) & ((rs_ID_EX == rt) | (rs_ID_EX == rs))) ? 1'b1 :
	                  	((write_rs_mem_wb) & ((rs_EX_MEM == rt) | (rs_EX_MEM == rs))) ? 1'b1 : 1'b0;

assign flush_fetch = (PC_source == 2'b10) ? 1'b1 : 1'b0;

//special instructions we need to watch out for
//STU writes to RS so RS has a data dependency if any instruction in front of
//us in pipeline has OP code of 10011
//
//All JAL and JALR instructions write to R7 so we need to check if any insturctions in
//front of us have an opcode of 00110 or opcode of 00111
//should pass in opcode from all stages


//things i changed, changed input to hazard detect to RS/RT instead of one from pipe as well as the module instantiation names and changed it our stall logic



endmodule
