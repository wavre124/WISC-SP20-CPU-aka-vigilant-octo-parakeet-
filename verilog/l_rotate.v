module l_rotate(In, Cnt, Out);

  // declare constant for size of inputs, outputs (N) and # bits to shift (C)
  parameter   N = 16;
  parameter   C = 4;
  parameter   O = 2;

  input [N-1:0]   In;
  input [C-1:0]   Cnt;
  output [N-1:0]  Out;

  wire wire15_1, wire14_1, wire13_1, wire12_1, wire11_1, wire10_1, wire9_1, wire8_1;
  wire wire7_1, wire6_1, wire5_1, wire4_1, wire3_1, wire2_1, wire1_1,  wire0_1;

  wire wire15_2, wire14_2, wire13_2, wire12_2, wire11_2, wire10_2, wire9_2, wire8_2;
  wire wire7_2, wire6_2, wire5_2, wire4_2, wire3_2, wire2_2, wire1_2, wire0_2;

  wire wire15_3, wire14_3, wire13_3, wire12_3, wire11_3, wire10_3, wire9_3, wire8_3;
  wire wire7_3, wire6_3, wire5_3, wire4_3, wire3_3, wire2_3, wire1_3, wire0_3;

  // rotate by 1
  mux2_1 mux_zero_sh0(.InA(In[0]), .InB(In[15]), .S(Cnt[0]), .Out(wire0_1));
  mux2_1 mux_zero_sh1(.InA(In[1]), .InB(In[0]), .S(Cnt[0]), .Out(wire1_1));
  mux2_1 mux_zero_sh2(.InA(In[2]), .InB(In[1]), .S(Cnt[0]), .Out(wire2_1));
  mux2_1 mux_zero_sh3(.InA(In[3]), .InB(In[2]), .S(Cnt[0]), .Out(wire3_1));
  mux2_1 mux_zero_sh4(.InA(In[4]), .InB(In[3]), .S(Cnt[0]), .Out(wire4_1));
  mux2_1 mux_zero_sh5(.InA(In[5]), .InB(In[4]), .S(Cnt[0]), .Out(wire5_1));
  mux2_1 mux_zero_sh6(.InA(In[6]), .InB(In[5]), .S(Cnt[0]), .Out(wire6_1));
  mux2_1 mux_zero_sh7(.InA(In[7]), .InB(In[6]), .S(Cnt[0]), .Out(wire7_1));
  mux2_1 mux_zero_sh8(.InA(In[8]), .InB(In[7]), .S(Cnt[0]), .Out(wire8_1));
  mux2_1 mux_zero_sh9(.InA(In[9]), .InB(In[8]), .S(Cnt[0]), .Out(wire9_1));
  mux2_1 mux_zero_sh10(.InA(In[10]), .InB(In[9]), .S(Cnt[0]), .Out(wire10_1));
  mux2_1 mux_zero_sh11(.InA(In[11]), .InB(In[10]), .S(Cnt[0]), .Out(wire11_1));
  mux2_1 mux_zero_sh12(.InA(In[12]), .InB(In[11]), .S(Cnt[0]), .Out(wire12_1));
  mux2_1 mux_zero_sh13(.InA(In[13]), .InB(In[12]), .S(Cnt[0]), .Out(wire13_1));
  mux2_1 mux_zero_sh14(.InA(In[14]), .InB(In[13]), .S(Cnt[0]), .Out(wire14_1));
  mux2_1 mux_zero_sh15(.InA(In[15]), .InB(In[14]), .S(Cnt[0]), .Out(wire15_1));

  // rotate by 2
  mux2_1 mux_one_sh0(.InA(wire0_1), .InB(wire14_1), .S(Cnt[1]), .Out(wire0_2));
  mux2_1 mux_one_sh1(.InA(wire1_1), .InB(wire15_1), .S(Cnt[1]), .Out(wire1_2));
  mux2_1 mux_one_sh2(.InA(wire2_1), .InB(wire0_1), .S(Cnt[1]), .Out(wire2_2));
  mux2_1 mux_one_sh3(.InA(wire3_1), .InB(wire1_1), .S(Cnt[1]), .Out(wire3_2));
  mux2_1 mux_one_sh4(.InA(wire4_1), .InB(wire2_1), .S(Cnt[1]), .Out(wire4_2));
  mux2_1 mux_one_sh5(.InA(wire5_1), .InB(wire3_1), .S(Cnt[1]), .Out(wire5_2));
  mux2_1 mux_one_s6(.InA(wire6_1), .InB(wire4_1), .S(Cnt[1]), .Out(wire6_2));
  mux2_1 mux_one_sh7(.InA(wire7_1), .InB(wire5_1), .S(Cnt[1]), .Out(wire7_2));
  mux2_1 mux_one_sh8(.InA(wire8_1), .InB(wire6_1), .S(Cnt[1]), .Out(wire8_2));
  mux2_1 mux_one_sh9(.InA(wire9_1), .InB(wire7_1), .S(Cnt[1]), .Out(wire9_2));
  mux2_1 mux_one_sh10(.InA(wire10_1), .InB(wire8_1), .S(Cnt[1]), .Out(wire10_2));
  mux2_1 mux_one_sh11(.InA(wire11_1), .InB(wire9_1), .S(Cnt[1]), .Out(wire11_2));
  mux2_1 mux_one_sh12(.InA(wire12_1), .InB(wire10_1), .S(Cnt[1]), .Out(wire12_2));
  mux2_1 mux_one_sh13(.InA(wire13_1), .InB(wire11_1), .S(Cnt[1]), .Out(wire13_2));
  mux2_1 mux_one_sh14(.InA(wire14_1), .InB(wire12_1), .S(Cnt[1]), .Out(wire14_2));
  mux2_1 mux_one_sh15(.InA(wire15_1), .InB(wire13_1), .S(Cnt[1]), .Out(wire15_2));

  // rotate by 4
  mux2_1 mux_two_sh0(.InA(wire0_2), .InB(wire12_2), .S(Cnt[2]), .Out(wire0_3));
  mux2_1 mux_two_sh1(.InA(wire1_2), .InB(wire13_2), .S(Cnt[2]), .Out(wire1_3));
  mux2_1 mux_two_sh2(.InA(wire2_2), .InB(wire14_2), .S(Cnt[2]), .Out(wire2_3));
  mux2_1 mux_two_sh3(.InA(wire3_2), .InB(wire15_2), .S(Cnt[2]), .Out(wire3_3));
  mux2_1 mux_two_sh4(.InA(wire4_2), .InB(wire0_2), .S(Cnt[2]), .Out(wire4_3));
  mux2_1 mux_two_sh5(.InA(wire5_2), .InB(wire1_2), .S(Cnt[2]), .Out(wire5_3));
  mux2_1 mux_two_s6(.InA(wire6_2), .InB(wire2_2), .S(Cnt[2]), .Out(wire6_3));
  mux2_1 mux_two_sh7(.InA(wire7_2), .InB(wire3_2), .S(Cnt[2]), .Out(wire7_3));
  mux2_1 mux_two_sh8(.InA(wire8_2), .InB(wire4_2), .S(Cnt[2]), .Out(wire8_3));
  mux2_1 mux_two_sh9(.InA(wire9_2), .InB(wire5_2), .S(Cnt[2]), .Out(wire9_3));
  mux2_1 mux_two_sh10(.InA(wire10_2), .InB(wire6_2), .S(Cnt[2]), .Out(wire10_3));
  mux2_1 mux_two_sh11(.InA(wire11_2), .InB(wire7_2), .S(Cnt[2]), .Out(wire11_3));
  mux2_1 mux_two_sh12(.InA(wire12_2), .InB(wire8_2), .S(Cnt[2]), .Out(wire12_3));
  mux2_1 mux_two_sh13(.InA(wire13_2), .InB(wire9_2), .S(Cnt[2]), .Out(wire13_3));
  mux2_1 mux_two_sh14(.InA(wire14_2), .InB(wire10_2), .S(Cnt[2]), .Out(wire14_3));
  mux2_1 mux_two_sh15(.InA(wire15_2), .InB(wire11_2), .S(Cnt[2]), .Out(wire15_3));

  // rotate by 8
  mux2_1 mux_three_sh0(.InA(wire0_3), .InB(wire8_3), .S(Cnt[3]), .Out(Out[0]));
  mux2_1 mux_three_sh1(.InA(wire1_3), .InB(wire9_3), .S(Cnt[3]), .Out(Out[1]));
  mux2_1 mux_three_sh2(.InA(wire2_3), .InB(wire10_3), .S(Cnt[3]), .Out(Out[2]));
  mux2_1 mux_three_sh3(.InA(wire3_3), .InB(wire11_3), .S(Cnt[3]), .Out(Out[3]));
  mux2_1 mux_three_sh4(.InA(wire4_3), .InB(wire12_3), .S(Cnt[3]), .Out(Out[4]));
  mux2_1 mux_three_sh5(.InA(wire5_3), .InB(wire13_3), .S(Cnt[3]), .Out(Out[5]));
  mux2_1 mux_three_sh6(.InA(wire6_3), .InB(wire14_3), .S(Cnt[3]), .Out(Out[6]));
  mux2_1 mux_three_sh7(.InA(wire7_3), .InB(wire15_3), .S(Cnt[3]), .Out(Out[7]));
  mux2_1 mux_three_sh8(.InA(wire8_3), .InB(wire0_3), .S(Cnt[3]), .Out(Out[8]));
  mux2_1 mux_three_sh9(.InA(wire9_3), .InB(wire1_3), .S(Cnt[3]), .Out(Out[9]));
  mux2_1 mux_three_sh10(.InA(wire10_3), .InB(wire2_3), .S(Cnt[3]), .Out(Out[10]));
  mux2_1 mux_three_sh11(.InA(wire11_3), .InB(wire3_3), .S(Cnt[3]), .Out(Out[11]));
  mux2_1 mux_three_sh12(.InA(wire12_3), .InB(wire4_3), .S(Cnt[3]), .Out(Out[12]));
  mux2_1 mux_three_sh13(.InA(wire13_3), .InB(wire5_3), .S(Cnt[3]), .Out(Out[13]));
  mux2_1 mux_three_sh14(.InA(wire14_3), .InB(wire6_3), .S(Cnt[3]), .Out(Out[14]));
  mux2_1 mux_three_sh15(.InA(wire15_3), .InB(wire7_3), .S(Cnt[3]), .Out(Out[15]));

endmodule
