module hazard_det(rd_ID_EX, rt, rs,
                  rd_EX_MEM, rs_EX_MEM, EX_MEM_reg_write, EX_MEM_ins, rs_MEM_WB,
                  MEM_wb_reg_write, MEM_wb_ins, PC_source, stall_decode, flush_fetch, EX_MEM_valid_rd, MEM_wb_valid_rd);

input [2:0] rd_ID_EX;
input [2:0] rt;
input [2:0] rs;

input [2:0] rd_EX_MEM;
input [2:0] rs_EX_MEM;
input EX_MEM_reg_write;
input [15:0] EX_MEM_ins;
input EX_MEM_valid_rd, MEM_wb_valid_rd;
input [2:0] rs_MEM_WB;
input MEM_wb_reg_write;
input [15:0] MEM_wb_ins;
input [1:0] PC_source;

// stalling the pipe_ID_EX
//output stall_execute;

// stalling the pipe_IF_ID
output stall_decode;
output flush_fetch;

// assume branch taken for all branch/control hazards

//did not add functionality to this but i think a weird bug we will need to
//think about is since the jumps do not use RS we may be stalling when we dont
//have to? but its also a jump so i guess it would unconditionally jumpa and
//it would not matter? something good to talk about with kshitij
localparam stu = 5'b10011;
localparam j = 5'b00100;
localparam jr = 5'b00101;
localparam jal = 5'b00110;
localparam jalr = 5'b00111;
localparam lbi = 5'b11000;

wire [4:0] EX_MEM_op;
wire [4:0] MEM_wb_op;

assign EX_MEM_op = EX_MEM_ins[15:11];
assign MEM_wb_op = MEM_wb_ins[15:11];

assign stall_decode = ((EX_MEM_reg_write) & ((rd_ID_EX == rt) | (rd_ID_EX == rs))) ? 1'b1 :
                      ((MEM_wb_reg_write) & ((rd_EX_MEM == rt) | (rd_EX_MEM == rs))) ? 1'b1 :
			                //((EX_MEM_op == lbi) & ((rs_EX_MEM == rt) | (rs_EX_MEM == rs))) ? 1'b1 :
                      //((MEM_wb_op == lbi) & ((rs_MEM_WB == rt) | (rs_MEM_WB == rs))) ? 1'b1 :
                      ((EX_MEM_op == stu) & ((rs_EX_MEM == rt) | (rs_EX_MEM == rs))) ? 1'b1 :
	                  	((MEM_wb_op == stu) & ((rs_MEM_WB == rt) | (rs_MEM_WB == rs))) ? 1'b1 : 1'b0;

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
