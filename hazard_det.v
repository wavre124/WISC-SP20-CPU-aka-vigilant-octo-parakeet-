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
wire [4:0] opcode;
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
localparam jr = 5'b00101;
localparam lbi = 5'b11000;
localparam store = 5'b10000;
localparam slbi = 5'b10010;
localparam R7 = 3'b111;
wire [4:0] EX_MEM_op;
wire [4:0] MEM_wb_op;

assign EX_MEM_op = EX_MEM_ins[15:11];
assign MEM_wb_op = MEM_wb_ins[15:11];

wire valD_regW_1; //used to check if the instruction is writing to RD ex-mem pipe
assign valD_regW_1 = EX_MEM_reg_write & EX_MEM_valid_rd;

wire equal_rs_rt; //used to check if there is a data dependency with an instruction writing to RD
assign equal_rs_rt = (rd_ID_EX == rt  | rd_ID_EX == rs);

wire valD_regW_2; //used to check if instruction is writing to RD from mem-wb pipe
assign valD_regW_2 = MEM_wb_reg_write & MEM_wb_valid_rd;

wire equal_rs_rt2; //used to check if there is a data dependency with an instruction from mem-wb pipe
assign equal_rs_rt2 = (rd_EX_MEM == rt) | (rd_EX_MEM == rs);

wire rs_rt_r7;
assign rs_rt_r7 = (rt == R7) | (rs == R7);

wire equals_RD_1; //used to check if there is a data dependency for store and stu from ex-mem pipe
assign equals_RD_1 = (rd_ID_EX == RD);

wire equals_RD_2; //used to check if there is a data dependency for store and stu from mem-wb pipe
assign equals_RD_2 = (rd_EX_MEM == RD);

wire write_Rs_1; //lbi, stu, and slbi all write to RS so we need to check for those data dependencies from ex-mem pipe
assign write_Rs_1 = ((EX_MEM_op == lbi) | (EX_MEM_op == stu) | (EX_MEM_op == slbi));

wire write_Rs_2;//lbi, stu, and slbi all write to RS so we need to check for those data dependencies from mem-wb pipe
assign write_Rs_2 = ((MEM_wb_op == lbi) | (MEM_wb_op == stu) | (MEM_wb_op == slbi));

wire rs_equal_rd_1; //stu and store need RD so checking if lbi, slbi, or stu Rs = RD for stu and store from ex-mem pipe
assign rs_equal_rd_1 =  (rs_ID_EX == RD);

wire rs_equal_rs_rt; //checking if rs for lbi/slbi/stu is writing to same Rs
assign rs_equal_rs_rt = (rs_ID_EX == rt) | (rs_ID_EX == rs);

wire rs_equal_rs_rt2;
assign rs_equal_rs_rt2 = (rs_EX_MEM == rt) | (rs_EX_MEM == rs);

wire rs_equal_rd_2; //stu and store need RD so checking if lbi, slbi, or stu Rs = RD for stu and store mem-wb pipe
assign rs_equal_rd_2 = (rs_EX_MEM == RD);

wire r7_write; //jal and jalr both write to r7 so need to check if those instructions are in front of us
assign r7_write = ((EX_MEM_op == jal) | (EX_MEM_op == jalr));

wire r7_write_2; //jal and jalr both write to r7 so check if those instructions are in front of us
assign r7_write_2 = ((MEM_wb_op == jal) | (MEM_wb_op == jalr));

wire st_stu; //these instructions need RD in decode so waiting for that
assign st_stu = (opcode == store) | (opcode == stu);

wire jalr_jr; //these instructions need RS in decode so checking if one of those
assign jalr_jr = (opcode == jalr) | (opcode == jr);

wire lbi_stall; //never stall on lbi so checking for that
assign lbi_stall = (opcode == lbi);

assign stall_decode = (((valD_regW_1 & equal_rs_rt) | (r7_write &  rs_rt_r7) | (write_Rs_1 & rs_equal_rs_rt)) & (~lbi_stall)) ? 1'b1 :
                      //checking first pipe register to see if it is writing to RD and that RD equals Rs/Rt
                      //and it is not lbi because lbi never stalls and also checking if instruction in front us is writing
                      //to R7 and that R7 is equal to Rs/Rt, also checking if isntruction in front us is writing to rs and that rs equals rs/rt ..... maybe include valid Rt signal???

                      (((valD_regW_2 & equal_rs_rt2) | (r7_write_2 &  rs_rt_r7) | (write_Rs_2 & rs_equal_rs_rt2)) & (~lbi_stall)) ? 1'b1 ://same logic as comment above

                      ((jalr_jr) & ((valD_regW_1 & (rd_ID_EX == rs)) | (valD_regW_2 & (rd_EX_MEM == rs)) | (write_Rs_1 & (rs_ID_EX == rs)) |
                      (write_Rs_2 & (rs_EX_MEM == rs)) | (r7_write & (rs == R7)) | (r7_write_2 & (rs == R7)))) ? 1'b1 :
			                //checking to see if it is jal/jalr which need RS, and then checking if instructions in front us in pipeline are writing to an RD that equals RS, also checking
                      //then checking if instructions in front of us write to RS and that RS equals Rs for jal/jalr. or checking if instruction in front of us is writing to R7 and
                      //R7 equals RS

                      ((st_stu) & (~lbi_stall) & (((valD_regW_1 & equals_RD_1) | (valD_regW_2 & equals_RD_2)) | (write_Rs_1 & rs_equal_rd_1) | (write_Rs_2 &
                        rs_equal_rd_2) | (r7_write & (RD == R7)) | (r7_write_2 & (RD == R7) ))) ? 1'b1 :
                      //checking if it is instruction that needs Rd in decode state and then checking if instruction in front of us writes to Rd and that Rd is equal to Rd in decode
                      //stage and checking if the instruciton in front of us is writing to Rs and that Rs equals Rd then checking to see if instruction in front of us is writing to                       //R7 and RD = R7




                      ((write_Rs_2) & (~lbi_stall) & ((rs_EX_MEM == rt) | (rs_EX_MEM == rs))) ? 1'b1 : 1'b0;

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
