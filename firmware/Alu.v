`include"Add_Sub.v"
`include"Shift.v"
`include"Logic.v"
`include"Cmp.v"

module Alu(A,B,ALUFun,Sign,S);
  input [31:0]A,B;
  input [5:0]ALUFun;
  input Sign;
  output [31:0]S;
  wire [31:0]s,sh,loc,cm;
  wire Z,V,N;
  Add_Sub A1(A,B,ALUFun[0],Sign,Z,V,N,s);
  Shift A2(A,B,ALUFun[1:0],sh);
  Logic A3(A,B,ALUFun[3:0],loc);
  CMP A4(ALUFun[3:1],Z,V,N,cm);   
  Mux_4 A5(s,loc,sh,cm,ALUFun[5:4],S);
endmodule


module Mux_2(a,b,s,y);  //32bits 2mux  0a 1b
  input s;
  input [31:0] a,b;
  output [31:0] y;
  genvar i;
  generate
    for(i=0;i<32;i=i+1)
    begin
    MuxTwo  a(y[i],a[i],b[i],s);
    end
  endgenerate
  
endmodule

module Mux_4(S00,S01,S10,S11,s,y);
  input [1:0] s;
  input [31:0] S00,S01,S10,S11;
  output [31:0] y;
  wire [31:0]t1,t2;
  
  Mux_2 mm0(S00,S01,s[0],t1);
  Mux_2 mm1(S10,S11,s[0],t2);
  Mux_2 mm2(t1,t2,s[1],y);
endmodule

module Mux_8(S0,S1,S2,S3,S4,S5,S6,S7,s,y);
  input [2:0] s;
  input [31:0] S0,S1,S2,S3,S4,S5,S6,S7;
  output [31:0] y;
  wire [31:0]t3,t4;
  
  Mux_4 mmm0(S0,S1,S2,S3,s[1:0],t3);
  Mux_4 mmm1(S4,S5,S6,S7,s[1:0],t4);
  Mux_2 mmm3(t3,t4,s[2],y);
endmodule



module MuxTwo(y,a,b,s);  //1bit 2mux  0a 1b
  input a,b,s;
  output y;
 
  not  n1(Nots,s);
  and  a1(N1,s,b);
  and  a2(N2,Nots,a);
  and  a3(N3,a,b);
  or  o1(y,N1,N2,N3);
endmodule

module MuxFour(a,b,c,d,s,y);
  input a,b,c,d;
  input [1:0] s;
  output y;
  MuxTwo m0(a,b,s[0],o1);
  MuxTwo m1(c,d,s[0],o2);
  MuxTwo m2(o1,o2,s[1],y);
endmodule

module MuxEight(a,b,c,d,e,f,g,h,s,y);
  input a,b,c,d,e,f,g,h;
  input [2:0] s;
  output y;
  
  MuxFour m0(a,b,c,d,s[1:0],o1);
  MuxFour m1(e,f,g,h,s[1:0],o2);
  MuxTwo m2(o1,o2,s[2],y);
endmodule

