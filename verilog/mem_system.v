/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );

   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;

   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;
   output err;

   localparam IDLE = 5'b00000;
   // input latch wires
   wire [15:0] Addr_latch;
   wire [15:0] DataIn_latch;
   wire Rd_latch;
   wire Wr_latch;
   wire createdump_latch;

   // cache output wires
   wire [4:0] cache_0_tag_out;
   wire [15:0] cache_0_data_out;
   wire cache_0_hit;
   wire cache_0_dirty;
   wire cache_0_valid;
   wire cache_0_err;

   wire [4:0] cache_1_tag_out;
   wire [15:0] cache_1_data_out;
   wire cache_1_hit;
   wire cache_1_dirty;
   wire cache_1_valid;
   wire cache_1_err;

   // cache input wires
   wire c_0_enable;
   wire [4:0] c_0_tag_in;
   wire [2:0] c_0_offset;
   wire [15:0] c_0_data_in;
   wire c_0_comp;
   wire c_0_write;
   wire c_0_valid_in;

   wire c_1_enable;
   wire [4:0] c_1_tag_in;
   wire [2:0] c_1_offset;
   wire [15:0] c_1_data_in;
   wire c_1_comp;
   wire c_1_write;
   wire c_1_valid_in;

   // mem output wires
   wire [15:0] mem_data_out;
   wire mem_stall;
   wire [3:0] busy;
   wire mem_err;

   // mem input wires
   wire [15:0] mem_data_in;
   wire [15:0] mem_addr_in;
   wire mem_wr, mem_rd;

   // cache controller wires
   wire [4:0] curr_state;
   wire mem_cache_wr;
   // if way = 0, cache zero is victimized
   // if way = 1, cache one is victimized
   wire way;
   wire stall_cache, cache_miss;
   wire [7:0] index;

   wire mem_blk;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 1;

   // if memtype is 1 DMem, otherwise 0 IMem
   assign mem_blk = (memtype == 1) ? 1'b1 : 1'b0;

   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (cache_0_tag_out),
                          .data_out             (cache_0_data_out),
                          .hit                  (cache_0_hit),
                          .dirty                (cache_0_dirty),
                          .valid                (cache_0_valid),
                          .err                  (cache_0_err),
                          // Inputs
                          .enable               (c_0_enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump_latch),
                          .tag_in               (c_0_tag_in),
                          .index                (index),
                          .offset               (c_0_offset),
                          .data_in              (c_0_data_in),
                          .comp                 (c_0_comp),
                          .write                (c_0_write),
                          .valid_in             (c_0_valid_in));
   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (cache_1_tag_out),
                          .data_out             (cache_1_data_out),
                          .hit                  (cache_1_hit),
                          .dirty                (cache_1_dirty),
                          .valid                (cache_1_valid),
                          .err                  (cache_1_err),
                          // Inputs
                          .enable               (c_1_enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump_latch),
                          .tag_in               (c_1_tag_in),
                          .index                (index),
                          .offset               (c_1_offset),
                          .data_in              (c_1_data_in),
                          .comp                 (c_1_comp),
                          .write                (c_1_write),
                          .valid_in             (c_1_valid_in));

   four_bank_mem mem(// Outputs
                     .data_out          (mem_data_out),
                     .stall             (mem_stall),
                     .busy              (busy),
                     .err               (mem_err),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump_latch),
                     .addr              (mem_addr_in),
                     .data_in           (mem_data_in),
                     .wr                (mem_wr),
                     .rd                (mem_rd));


   cache_controller ctrl(.clk(clk), .rst(rst), .read(Rd_latch), .write(Wr_latch), .c_hit_0(cache_0_hit), .c_hit_1(cache_1_hit),
                              .c_dirty_0(cache_0_dirty), .c_dirty_1(cache_1_dirty), .c_valid_0(cache_0_valid), .c_valid_1(cache_1_valid),
                              .c_tag_0(cache_0_tag_out), .c_tag_1(cache_1_tag_out), .busy(busy), .addr(Addr_latch),
                              .c_enable_0(c_0_enable), .c_enable_1(c_1_enable), .mem_rd(mem_rd), .mem_wr(mem_wr),
                              .c_comp_0(c_0_comp), .c_comp_1(c_1_comp), .c_write_0(c_0_write), .c_write_1(c_1_write),
                              .valid_in_0(c_0_valid_in), .valid_in_1(c_1_valid_in), .mem_cache_wr(mem_cache_wr), .done(Done), .curr_state(curr_state),
                              .mem_address(mem_addr_in), .c_offset_0(c_0_offset), .c_offset_1(c_1_offset), .c_tag_out_0(c_0_tag_in), .c_tag_out_1(c_1_tag_in),
                              .way(way), .stall(stall_cache), .miss(cache_miss), .mem_blk(mem_blk));

   // your code here
   // latches so signals don't change until we are in IDLE in our FSM
   assign Addr_latch = (curr_state == IDLE) ? Addr : Addr_latch;
   assign DataIn_latch = (curr_state == IDLE) ? DataIn : DataIn_latch;
   assign Rd_latch = (curr_state == IDLE) ? Rd : Rd_latch;
   assign Wr_latch = (curr_state == IDLE) ? Wr : Wr_latch;
   assign createdump_latch = (curr_state == IDLE) ? createdump : createdump_latch;

   assign index = Addr_latch[10:3];
   assign mem_data_in = (way) ? cache_1_data_out : cache_0_data_out;
   assign c_0_data_in = (mem_cache_wr) ? mem_data_out : DataIn_latch;
   assign c_1_data_in = (mem_cache_wr) ? mem_data_out : DataIn_latch;

   assign Stall = mem_stall | stall_cache;
   assign CacheHit = (cache_1_hit & cache_1_valid & ~cache_miss) | (cache_0_hit & cache_0_valid & ~cache_miss);
   assign err = cache_1_err | cache_0_err | mem_err;
   // way is the data from the cache that is either hit or a miss happened but we
   // recovered and read from the cache line
   assign DataOut = (way) ? cache_1_data_out : cache_0_data_out;

endmodule // mem_system




// DUMMY LINE FOR REV CONTROL :9:
