module cache_controller(addr, clk, rst, read, write, hit, dirty, valid, stall_mem,
                        err, busy, enable, mem_wr, mem_rd, comp, c_write,
                        valid_in, mem_cache_wr, done);

input [15:0] addr;
input clk, rst;
input read, write;
input hit, dirty, valid, stall_mem;
input err;
input [3:0] busy;

output enable, mem_wr, mem_rd, comp;
output c_write, valid_in, mem_cache_wr, done;




endmodule
