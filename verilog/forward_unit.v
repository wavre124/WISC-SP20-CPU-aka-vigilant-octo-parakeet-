module forward_unit(execute_data, memory_read_data, mem_address, data_one, reg_2 ,rd_d, rs_d, rt_d, rd_e, rs_e, rd_m, rs_m,
  reg_write_ex, reg_write_mem, mem_read_ex, mem_read_mem, valid_rt);

  input [15:0] execute_data, memory_read_data, mem_address; //data from execute, data from memory
  input [15:0] data_one, reg_2; //data one is RS, reg_2 is Rt or signed immediate...... only override reg_2 if valid_rt is high
  input [2:0] rd_d, rs_d, rt_d; //inputs from decode to excute that may have its value replaced
  input [2:0] rd_e, rs_e; //inputs from execute to memory for ex-ex forwarding
  input [2:0] rd_m, rs_m; //inputs from memory to wb that are used for mem-ex forwarding
  input reg_write_ex, reg_write_mem;
  input mem_read_ex, mem_read_mem;
  input valid_rt; //used in conjunction with reg_2













endmodule
