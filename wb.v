/*
   CS/ECE 552 Spring '20

   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
module wb (data_read, address, Mem_reg, data_out);
    // TODO: Your code here
    input [15:0] data_read, address;
    input Mem_reg;
    output [15:0] data_out;

    mux2_1 (.InA(address), .InB(data_read), .S(Mem_reg), .Out(data_out));


endmodule
