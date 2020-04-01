module hazard_det(rd_ID_EX, rt_ID_EX, rs_ID_EX,
                  rd_EX_MEM, rs_EX_MEM, EX_MEM_reg_write, EX_MEM_op, rd_MEM_WB, rs_MEM_WB,
                  MEM_wb_reg_write, MEM_wb_op, PC_source, stall_decode, flush_fetch);

input [2:0] rd_ID_EX;
input [2:0] rt_ID_EX;
input [2:0] rs_ID_EX;

input [2:0] rd_EX_MEM;
input [2:0] rs_EX_MEM;
input EX_MEM_reg_write;
input [4:0] EX_MEM_op;

input [2:0] rd_MEM_WB;
input [2:0] rs_MEM_WB;
input MEM_wb_reg_write;
input [4:0] MEM_wb_op;
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

assign stall_decode = ((EX_MEM_reg_write) & ((rd_EX_MEM == rt_ID_EX) | (rd_EX_MEM == rs_ID_EX))) ? 1'b1 :
                      ((MEM_WB_reg_write) & ((rd_MEM_WB == rt_ID_EX) | (rd_MEM_WB == rs_ID_EX))) ? 1'b1 :
			                ((EX_MEM_op == stu) & ((rs_EX_MEM == rt_ID_EX) | (rs_EX_MEM == rs_ID_EX))) ? 1'b1 :
		                  ((MEM_wb_op == stu) & ((rs_MEM_WB == rt_ID_EX) | (rs_MEM_WB == rs_ID_EX))) ? 1'b1 : 1'b0;

assign flush_fetch = (PC_source == 2'b10) ? 1'b1 : 1'b0;

//special instructions we need to watch out for
//STU writes to RS so RS has a data dependency if any instruction in front of
//us in pipeline has OP code of 10011
//
//All JAL and JALR instructions write to R7 so we need to check if any insturctions in
//front of us have an opcode of 00110 or opcode of 00111
//should pass in opcode from all stages



//things I added:
//hazard_detect
//1) ability to accept opcode from  last two pipeline regs
//2) receiving RS for other two pipeline regs for STU
//3) added to stall decode ability to stall if seeing STU
//4) changed stall logic to be AND and not ORS
//
//pipe_id_ex
//1)added input/output/flop for opcode
//2)added input/output/flop for RD/RS
//3)added input/output/flop for inc_pc
//
//
//decode
//1)added RD as an output which is based on kshitij logic from control unit
//2)added RS as an output which is hardcoded to [10:8] because the only time
//we care about RS is if it is STU and our stall decode logic is smart enough
//to detect that
//3)added opcode as an output
//4)added inc_pc as an input and output
//
//execute
//1)added data_2 as an output
//2)added RD, Rs, and opcode as input/output
//
//pipe_ex_mem
//1)finished this one
//
//things we need to think about
//are there any wires that cross over a stage of pipeline, yes inc_pc which is
//used in mux going into ALU, data_2 going from decode to memory
//need to change decode quite a bit to use the signals that are from pipeline
//regs and not from the current instruction in decode
endmodule
