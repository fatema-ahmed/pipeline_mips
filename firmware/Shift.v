module Shift(a,b,op,sh);
  input [31:0]a,b;
  input [1:0]op;
  output [31:0]sh;
  wire [31:0]s0,s1,s3;
  SLL sll(a,b,s0);
  SRL srl(a,b,s1);
  SRA sra(a,b,s3);
  Mux_4 mux_sh(s0,s1,0,s3,op,sh);
endmodule


module SLL (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
  wire [31:0]S1;
  wire [31:0]S2;
  wire [31:0]S3;
  wire [31:0]S4;
  SLL_a0 go1(a,b,S1);
  SLL_a1 go2(a,S1,S2);
  SLL_a2 go3(a,S2,S3);
  SLL_a3 go4(a,S3,S4);
  SLL_a4 go5(a,S4,S);
endmodule
  
module SLL_a0 (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
  MuxTwo a01 (S[0],b[0],1'b0,a[0]);
  
  genvar i;
  generate
    for(i=1;i<32;i=i+1)
    begin
    MuxTwo  a(S[i],b[i],b[i-1],a[0]);
    end
  endgenerate
  
endmodule

module SLL_a1 (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
  MuxTwo a01 (S[0],b[0],1'b0,a[1]);
  MuxTwo a02 (S[1],b[1],1'b0,a[1]);
  
  genvar i;
  generate
    for(i=2;i<32;i=i+1)
    begin
    MuxTwo  a(S[i],b[i],b[i-2],a[1]);
    end
  endgenerate
endmodule

module SLL_a2 (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
  MuxTwo a01 (S[0],b[0],1'b0,a[2]);
  MuxTwo a02 (S[1],b[1],1'b0,a[2]);
  MuxTwo a03 (S[2],b[2],1'b0,a[2]);
  MuxTwo a04 (S[3],b[3],1'b0,a[2]);
  
  genvar i;
  generate
    for(i=4;i<32;i=i+1)
    begin
    MuxTwo  a(S[i],b[i],b[i-4],a[2]);
    end
  endgenerate
endmodule

module SLL_a3 (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
  MuxTwo a01 (S[0],b[0],1'b0,a[3]);
  MuxTwo a02 (S[1],b[1],1'b0,a[3]);
  MuxTwo a03 (S[2],b[2],1'b0,a[3]);
  MuxTwo a04 (S[3],b[3],1'b0,a[3]);
  MuxTwo a05 (S[4],b[4],1'b0,a[3]);
  MuxTwo a06 (S[5],b[5],1'b0,a[3]);
  MuxTwo a07 (S[6],b[6],1'b0,a[3]);
  MuxTwo a08 (S[7],b[7],1'b0,a[3]);
  
  genvar i;
  generate
    for(i=8;i<32;i=i+1)
    begin
    MuxTwo  a(S[i],b[i],b[i-8],a[3]);
    end
  endgenerate
endmodule

module SLL_a4 (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
  MuxTwo a01 (S[0],b[0],1'b0,a[4]);
  MuxTwo a02 (S[1],b[1],1'b0,a[4]);
  MuxTwo a03 (S[2],b[2],1'b0,a[4]);
  MuxTwo a04 (S[3],b[3],1'b0,a[4]);
  MuxTwo a05 (S[4],b[4],1'b0,a[4]);
  MuxTwo a06 (S[5],b[5],1'b0,a[4]);
  MuxTwo a07 (S[6],b[6],1'b0,a[4]);
  MuxTwo a08 (S[7],b[7],1'b0,a[4]);
  MuxTwo a09 (S[8],b[8],1'b0,a[4]);
  MuxTwo a10 (S[9],b[9],1'b0,a[4]);
  MuxTwo a11 (S[10],b[10],1'b0,a[4]);
  MuxTwo a12 (S[11],b[11],1'b0,a[4]);
  MuxTwo a13 (S[12],b[12],1'b0,a[4]);
  MuxTwo a14 (S[13],b[13],1'b0,a[4]);
  MuxTwo a15 (S[14],b[14],1'b0,a[4]);
  MuxTwo a16 (S[15],b[15],1'b0,a[4]);
  
  genvar i;
  generate
    for(i=16;i<32;i=i+1)
    begin
    MuxTwo  a(S[i],b[i],b[i-16],a[4]);
    end
  endgenerate
endmodule

module SRL (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
  wire [31:0]S1;
  wire [31:0]S2;
  wire [31:0]S3;
  wire [31:0]S4;
  SRL_a0 go1(a,b,S1);
  SRL_a1 go2(a,S1,S2);
  SRL_a2 go3(a,S2,S3);
  SRL_a3 go4(a,S3,S4);
  SRL_a4 go5(a,S4,S);
endmodule
  
module SRL_a0 (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
  
  
  genvar i;
  generate
    for(i=0;i<31;i=i+1)
    begin
    MuxTwo  a(S[i],b[i],b[i+1],a[0]);
    end
  endgenerate
  
  MuxTwo a32 (S[31],b[31],1'b0,a[0]);
endmodule

module SRL_a1 (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
 
  genvar i;
  generate
    for(i=0;i<30;i=i+1)
    begin
    MuxTwo  a(S[i],b[i],b[i+2],a[1]);
    end
  endgenerate
  
  MuxTwo a31 (S[30],b[30],1'b0,a[1]);
  MuxTwo a32 (S[31],b[31],1'b0,a[1]);
endmodule

module SRL_a2 (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
 
  genvar i;
  generate
    for(i=0;i<28;i=i+1)
    begin
    MuxTwo  a(S[i],b[i],b[i+4],a[2]);
    end
  endgenerate
  
  MuxTwo a29 (S[28],b[28],1'b0,a[2]);
  MuxTwo a30 (S[29],b[29],1'b0,a[2]);
  MuxTwo a31 (S[30],b[30],1'b0,a[2]);
  MuxTwo a32 (S[31],b[31],1'b0,a[2]);
endmodule

module SRL_a3 (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;

  genvar i;
  generate
    for(i=0;i<24;i=i+1)
    begin
    MuxTwo  a(S[i],b[i],b[i+8],a[3]);
    end
  endgenerate
  
  MuxTwo a25 (S[24],b[24],1'b0,a[3]);
  MuxTwo a26 (S[25],b[25],1'b0,a[3]);
  MuxTwo a27 (S[26],b[26],1'b0,a[3]);
  MuxTwo a28 (S[27],b[27],1'b0,a[3]);
  MuxTwo a29 (S[28],b[28],1'b0,a[3]);
  MuxTwo a30 (S[29],b[29],1'b0,a[3]);
  MuxTwo a31 (S[30],b[30],1'b0,a[3]);
  MuxTwo a32 (S[31],b[31],1'b0,a[3]);
endmodule

module SRL_a4 (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
  

  genvar i;
  generate
    for(i=0;i<16;i=i+1)
    begin
    MuxTwo  a(S[i],b[i],b[i+16],a[4]);
    end
  endgenerate
  
  MuxTwo a17 (S[16],b[16],1'b0,a[4]);
  MuxTwo a18 (S[17],b[17],1'b0,a[4]);
  MuxTwo a19 (S[18],b[18],1'b0,a[4]);
  MuxTwo a20 (S[19],b[19],1'b0,a[4]);
  MuxTwo a21 (S[20],b[20],1'b0,a[4]);
  MuxTwo a22 (S[21],b[21],1'b0,a[4]);
  MuxTwo a23 (S[22],b[22],1'b0,a[4]);
  MuxTwo a24 (S[23],b[23],1'b0,a[4]);
  MuxTwo a25 (S[24],b[24],1'b0,a[4]);
  MuxTwo a26 (S[25],b[25],1'b0,a[4]);
  MuxTwo a27 (S[26],b[26],1'b0,a[4]);
  MuxTwo a28 (S[27],b[27],1'b0,a[4]);
  MuxTwo a29 (S[28],b[28],1'b0,a[4]);
  MuxTwo a30 (S[29],b[29],1'b0,a[4]);
  MuxTwo a31 (S[30],b[30],1'b0,a[4]);
  MuxTwo a32 (S[31],b[31],1'b0,a[4]);
endmodule

module SRA (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
  wire [31:0]S1;
  wire [31:0]S2;
  wire [31:0]S3;
  wire [31:0]S4;
  SRA_a0 go1(a,b,S1);
  SRA_a1 go2(a,S1,S2);
  SRA_a2 go3(a,S2,S3);
  SRA_a3 go4(a,S3,S4);
  SRA_a4 go5(a,S4,S);
endmodule
  
module SRA_a0 (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
  

  
  genvar i;
  generate
    for(i=0;i<31;i=i+1)
    begin
    MuxTwo  a(S[i],b[i],b[i+1],a[0]);
    end
  endgenerate
  
  MuxTwo a32 (S[31],b[31],b[31],a[0]);
endmodule

module SRA_a1 (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
  
  genvar i;
  generate
    for(i=0;i<30;i=i+1)
    begin
    MuxTwo  a(S[i],b[i],b[i+2],a[1]);
    end
  endgenerate
  
  MuxTwo a31 (S[30],b[30],b[31],a[1]);
  MuxTwo a32 (S[31],b[31],b[31],a[1]);
endmodule

module SRA_a2 (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
 
  genvar i;
  generate
    for(i=0;i<28;i=i+1)
    begin
    MuxTwo  a(S[i],b[i],b[i+4],a[2]);
    end
  endgenerate
  
  MuxTwo a29 (S[28],b[28],b[31],a[2]);
  MuxTwo a30 (S[29],b[29],b[31],a[2]);
  MuxTwo a31 (S[30],b[30],b[31],a[2]);
  MuxTwo a32 (S[31],b[31],b[31],a[2]);
endmodule

module SRA_a3 (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
 
  genvar i;
  generate
    for(i=0;i<24;i=i+1)
    begin
    MuxTwo  a(S[i],b[i],b[i+8],a[3]);
    end
  endgenerate
  
  MuxTwo a25 (S[24],b[24],b[31],a[3]);
  MuxTwo a26 (S[25],b[25],b[31],a[3]);
  MuxTwo a27 (S[26],b[26],b[31],a[3]);
  MuxTwo a28 (S[27],b[27],b[31],a[3]);
  MuxTwo a29 (S[28],b[28],b[31],a[3]);
  MuxTwo a30 (S[29],b[29],b[31],a[3]);
  MuxTwo a31 (S[30],b[30],b[31],a[3]);
  MuxTwo a32 (S[31],b[31],b[31],a[3]);
endmodule

module SRA_a4 (a,b,S); 
  input [31:0]b;
  input [31:0]a;
  output [31:0]S;
  
 
  genvar i;
  generate
    for(i=0;i<16;i=i+1)
    begin
    MuxTwo  a(S[i],b[i],b[i+16],a[4]);
    end
  endgenerate
  
  MuxTwo a17 (S[16],b[16],b[31],a[4]);
  MuxTwo a18 (S[17],b[17],b[31],a[4]);
  MuxTwo a19 (S[18],b[18],b[31],a[4]);
  MuxTwo a20 (S[19],b[19],b[31],a[4]);
  MuxTwo a21 (S[20],b[20],b[31],a[4]);
  MuxTwo a22 (S[21],b[21],b[31],a[4]);
  MuxTwo a23 (S[22],b[22],b[31],a[4]);
  MuxTwo a24 (S[23],b[23],b[31],a[4]);
  MuxTwo a25 (S[24],b[24],b[31],a[4]);
  MuxTwo a26 (S[25],b[25],b[31],a[4]);
  MuxTwo a27 (S[26],b[26],b[31],a[4]);
  MuxTwo a28 (S[27],b[27],b[31],a[4]);
  MuxTwo a29 (S[28],b[28],b[31],a[4]);
  MuxTwo a30 (S[29],b[29],b[31],a[4]);
  MuxTwo a31 (S[30],b[30],b[31],a[4]);
  MuxTwo a32 (S[31],b[31],b[31],a[4]);
endmodule