`include"Mips_D.v"

module test;
  reg clk,reset;
  reg [7:0]switch;
  wire [7:0] led;
  wire [6:0] digi_out1;	//0: CG,CF,CE,CD,CC,CB,CA
  wire [6:0] digi_out2;	//1: CG,CF,CE,CD,CC,CB,CA
  wire [6:0] digi_out3;	//2: CG,CF,CE,CD,CC,CB,CA
  wire [6:0] digi_out4;	//3: CG,CF,CE,CD,CC,CB,CA
 
  Mips_D st(reset,clk,switch,led,digi_out1,digi_out2,digi_out3,digi_out4);
  initial
  begin
    clk=0;
    reset=1;
    switch=8'b1111_1010;
  end
  initial
  fork
  forever #1 clk=~clk;
  #2 reset=0;
  #3 reset=1;
  join
endmodule