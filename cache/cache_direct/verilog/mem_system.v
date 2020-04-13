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

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (c_tag_out),
                          .data_out             (c_data_out),
                          .hit                  (CacheHit),
                          .dirty                (c_dirty),
                          .valid                (c_valid),
                          .err                  (c_err),
                          // Inputs
                          .enable               (c_enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (c_data_in),
                          .comp                 (c_comp),
                          .write                (c_write),
                          .valid_in             (c_valid_in));

   four_bank_mem mem(// Outputs
                     .data_out          (mem_data_out),
                     .stall             (mem_stall),
                     .busy              (mem_busy),
                     .err               (mem_err),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_addr),
                     .data_in           (mem_data_in),
                     .wr                (mem_write),
                     .rd                (mem_read));


   // your code here

   // cache wires and IOs
   wire [2:0] offset;
   wire [7:0] index;
   wire [4:0] tag;
   wire [4:0] c_tag_out;
   wire [15:0] c_data_out;
   wire c_dirty;
   wire c_valid;
   wire c_err;
   wire c_enable;
   wire [15:0] c_data_in;
   wire c_comp;
   wire c_write;
   wire c_valid_in;

   // mem wires and IOs
   wire [15:0] mem_data_out;
   wire [15:0] mem_addr;
   wire [3:0] mem_busy;
   wire mem_err;
   wire [15:0] mem_data_in;
   wire mem_write;
   wire mem_read;
   wire mem_stall;

   // cntrl wires and IOs
   wire mem_cache_write;
   wire cache_stall;

   // assign inputs to cache
   assign index = Addr[10:3];
   assign c_data_in = (mem_cache_write) ? mem_data_out : DataIn;

   // assign inputs to cache cntrl

   // assign inputs to memory blk
   assign mem_data_in = (c_dirty) ? c_data_out : DataIn;

   cache_controller ctrl(.addr(Addr), .clk(clk), .rst(rst), .read(Rd), .write(Wr), .hit(CacheHit), .dirty(c_dirty), .valid(c_valid), .stall_mem(Stall),
                           .err(err), .busy(mem_busy), .enable(c_enable), .mem_wr(mem_write), .mem_rd(mem_read), .comp(c_comp), .c_write(c_write),
                           .valid_in(c_valid_in), .mem_cache_wr(mem_cache_write), .done(Done), .stall_cache(cache_stall), .mem_address(mem_addr), .cache_offset(offset),
                           .cache_tag_out(tag), .cache_tag_in(c_tag_out));

   // assign outputs of mem system
   assign DataOut = (CacheHit) ? c_data_out : mem_data_out;
   assign err = c_err | mem_err;
   // the stall signal should be high when FSM is handling a cache request and no
   // other requests should be taken at this time
   assign Stall = mem_stall | cache_stall;

endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
