//for  Rt,Rs,Rd,Ra,xp

module MuxTwo_5(a,b,s,out);
  input [4:0]a,b;
  input s;
  output [4:0]out;
  wire [4:0]s5,ns5,sela,selb;
  genvar i;
  generate
    for(i=0;i<5;i=i+1)
    begin
    assign s5[i]=s;
  end
  endgenerate
  assign ns5=~s5;
  assign sela=ns5&a;
  assign selb=s5&b;
  assign out=sela|selb;
endmodule

module MuxFour_5(c0,c1,c2,c3,s,z);
    input [1:0]s;
    input [4:0]c0,c1,c2,c3;
    output [4:0]z;
    wire [4:0]t0,t1;
    MuxTwo_5 temp1(c0,c1,s[0],t0);
    MuxTwo_5 temp2(c2,c3,s[0],t1);
    MuxTwo_5 temp3(t0,t1,s[1],z);
endmodule