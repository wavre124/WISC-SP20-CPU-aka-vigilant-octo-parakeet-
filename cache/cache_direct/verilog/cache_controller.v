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

localparam IDLE = 4'b0000;
localparam COMP_READ = 4'b0001;
localparam COMP_WRITE = 4'b0010;
localparam CACHE_READ = 4'b0011;
localparam CACHE_WRITE = 4'b0100;
localparam MEM_WRITE = 4'b0101;
localparam MEM_WRITE_BACK = 4'b0110;
localparam MEM_READ = 4'b0111;
localparam STALL = 4'b1000;





endmodule
