module hazard_det(rd_ID_EX, rt_ID_EX, rs_ID_EX
                  rd_EX_MEM, EX_MEM_reg_write, rd_MEM_WB
                  MEM_wb_reg_write, PC_source, stall_decode, flush_fetch);

input [2:0] rd_ID_EX;
input [2:0] rt_ID_EX;
input [2:0] rs_ID_EX;

input [2:0] rd_EX_MEM;
input EX_MEM_reg_write;

input [2:0] rd_MEM_WB;
input MEM_wb_reg_write;
input [1:0] PC_source;

// stalling the pipe_ID_EX
//output stall_execute;

// stalling the pipe_IF_ID
output stall_decode;
output flush_fetch;

// assume branch taken for all branch/control hazards

assign stall_decode = ((EX_MEM_reg_write) | ((rd_EX_MEM == rt_ID_EX) | (rd_EX_MEM == rs_ID_EX))) ? 1'b1 :
                      ((MEM_WB_reg_write) | ((rd_MEM_WB == rt_ID_EX) | (rd_MEM_WB == rs_ID_EX))) ? 1'b1 : 1'b0;

assign flush_fetch = (PC_source == 2'b10) ? 1'b1 : 1'b0;

endmodule
