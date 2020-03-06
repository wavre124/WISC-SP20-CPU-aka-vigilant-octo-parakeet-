module and3 (in1,in2,in3,out);
    input in1,in2,in3;
    output out;

    wire int_sig;

    and2 and_one(.in1(in1), .in2(in2), .out(int_sig));
    and2 and_two(.in1(int_sig), .in2(in3), .out(out));

endmodule
