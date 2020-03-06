module reg_8_16b(clk, rst, writeEn, writeData, w_select, r0_out, r1_out, r2_out, r3_out, r4_out, r5_out, r6_out, r7_out);

  input clk, rst, writeEn;
  input [15:0] writeData;
  input [2:0] w_select;

  output [15:0] r0_out, r1_out, r2_out, r3_out, r4_out, r5_out, r6_out, r7_out;

  wire dec_0, dec_1, dec_2, dec_3, dec_4, dec_5, dec_6, dec_7;
  wire w_en_0, w_en_1, w_en_2, w_en_3, w_en_4, w_en_5, w_en_6, w_en_7;

  and3 out_0(.in1(~w_select[0]), .in2(~w_select[1]), .in3(~w_select[2]), .out(dec_0));
  and3 out_1(.in1(w_select[0]), .in2(~w_select[1]), .in3(~w_select[2]), .out(dec_1));
  and3 out_2(.in1(~w_select[0]), .in2(w_select[1]), .in3(~w_select[2]), .out(dec_2));
  and3 out_3(.in1(w_select[0]), .in2(w_select[1]), .in3(~w_select[2]), .out(dec_3));
  and3 out_4(.in1(~w_select[0]), .in2(~w_select[1]), .in3(w_select[2]), .out(dec_4));
  and3 out_5(.in1(w_select[0]), .in2(~w_select[1]), .in3(w_select[2]), .out(dec_5));
  and3 out_6(.in1(~w_select[0]), .in2(w_select[1]), .in3(w_select[2]), .out(dec_6));
  and3 out_7(.in1(w_select[0]), .in2(w_select[1]), .in3(w_select[2]), .out(dec_7));

  and2 and_0(.in1(writeEn), .in2(dec_0), .out(w_en_0));
  and2 and_1(.in1(writeEn), .in2(dec_1), .out(w_en_1));
  and2 and_2(.in1(writeEn), .in2(dec_2), .out(w_en_2));
  and2 and_3(.in1(writeEn), .in2(dec_3), .out(w_en_3));
  and2 and_4(.in1(writeEn), .in2(dec_4), .out(w_en_4));
  and2 and_5(.in1(writeEn), .in2(dec_5), .out(w_en_5));
  and2 and_6(.in1(writeEn), .in2(dec_6), .out(w_en_6));
  and2 and_7(.in1(writeEn), .in2(dec_7), .out(w_en_7));

  reg_16b reg_0(.clk(clk), .rst(rst), .writeEn(w_en_0), .inputData(writeData), .outputData(r0_out));
  reg_16b reg_1(.clk(clk), .rst(rst), .writeEn(w_en_1), .inputData(writeData), .outputData(r1_out));
  reg_16b reg_2(.clk(clk), .rst(rst), .writeEn(w_en_2), .inputData(writeData), .outputData(r2_out));
  reg_16b reg_3(.clk(clk), .rst(rst), .writeEn(w_en_3), .inputData(writeData), .outputData(r3_out));
  reg_16b reg_4(.clk(clk), .rst(rst), .writeEn(w_en_4), .inputData(writeData), .outputData(r4_out));
  reg_16b reg_5(.clk(clk), .rst(rst), .writeEn(w_en_5), .inputData(writeData), .outputData(r5_out));
  reg_16b reg_6(.clk(clk), .rst(rst), .writeEn(w_en_6), .inputData(writeData), .outputData(r6_out));
  reg_16b reg_7(.clk(clk), .rst(rst), .writeEn(w_en_7), .inputData(writeData), .outputData(r7_out));

endmodule
