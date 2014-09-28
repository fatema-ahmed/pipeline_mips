module Add_Sub(A,B,func,Sign,Z,V,N,S);
	input [31:0] A,B;
	input func,Sign;
	output [31:0] S;
	output Z,V,N;

	wire [31:0] B1;
	wire [7:0] CO;
	wire [7:0] Sout;
	wire NOTZ;
	wire V0,V1;
	wire N0,N1;

  genvar i;
	generate
    for(i=0;i<32;i=i+1)
    begin
      xor (B1[i],B[i],func);   //gen ju func qiu jia shu
    end
  endgenerate
  
	AdderC4 a0(S[3:0],CO[0],A[3:0],B1[3:0],func);   //jian fa qiu bu +1
	AdderC4 a1(S[7:4],CO[1],A[7:4],B1[7:4],CO[0]);
	AdderC4 a2(S[11:8],CO[2],A[11:8],B1[11:8],CO[1]);  
	AdderC4 a3(S[15:12],CO[3],A[15:12],B1[15:12],CO[2]);  
	AdderC4 a4(S[19:16],CO[4],A[19:16],B1[19:16],CO[3]);  
	AdderC4 a5(S[23:20],CO[5],A[23:20],B1[23:20],CO[4]);  
	AdderC4 a6(S[27:24],CO[6],A[27:24],B1[27:24],CO[5]);  
	AdderC4 a7(S[31:28],CO[7],A[31:28],B1[31:28],CO[6]);  
  //gen ju shu chu pan duan shi fou wei ling
	or(Sout[0],S[0],S[1],S[2],S[3]);
	or(Sout[1],S[4],S[5],S[6],S[7]);
	or(Sout[2],S[8],S[9],S[10],S[11]);
	or(Sout[3],S[12],S[13],S[14],S[15]);
	or(Sout[4],S[16],S[17],S[18],S[19]);
	or(Sout[5],S[20],S[21],S[22],S[23]);
	or(Sout[6],S[24],S[25],S[26],S[27]);
	or(Sout[7],S[28],S[29],S[30],S[31]);	
	or(NOTZ,Sout[0],Sout[1],Sout[2],Sout[3],Sout[4],Sout[5],Sout[6],Sout[7]);
	not(Z,NOTZ);
	xor(V1,CO[6],CO[7]);
	xor(V0,CO[7],func);
	MuxTwo m0(V,V0,V1,Sign);
	and(N0,func,V);
	xor(N1,V,S[31]);
	MuxTwo m1(N,N0,N1,Sign);    
endmodule




module Fulladder(s,p,g,a,b,cin);
	output s,p,g;
	input a,b,cin;
	xor(s,a,b,cin);
	and(g,a,b);
	xor(p,a,b);
endmodule


module Ahead(c,p,g,Cin);
	output [3:0] c;
	input [3:0] p,g;
	input Cin;
	wire c00,c10,c11,c20,c21,c22,c30,c31,c32,c33;
	and(c00,p[0],Cin);
	and(c10,g[0],p[1]);
	and(c11,Cin,p[0],p[1]);
	and(c20,g[1],p[2]);
	and(c21,g[0],p[1],p[2]);
	and(c22,Cin,p[0],p[1],p[2]);
	and(c30,g[2],p[3]);
	and(c31,g[1],p[2],p[3]);
	and(c32,g[0],p[1],p[2],p[3]);
	and(c33,Cin,p[0],p[1],p[2],p[3]);
	or(c[0],g[0],c00);
	or(c[1],g[1],c10,c11);
	or(c[2],g[2],c20,c21,c22);
	or(c[3],g[3],c30,c31,c32,c33);  
endmodule

module AdderC4(s,Cout,a,b,Cin);
	input [3:0] a,b;
	input Cin;

	
	output [3:0] s;
	output Cout;
	
	wire [3:0] p,g,c;

	Fulladder f1(s[0],p[0],g[0],a[0],b[0],Cin);
	Fulladder f2(s[1],p[1],g[1],a[1],b[1],c[0]);
	Fulladder f3(s[2],p[2],g[2],a[2],b[2],c[1]);
	Fulladder f4(s[3],p[3],g[3],a[3],b[3],c[2]);

	Ahead a1(c,p,g,Cin);
	assign Cout = c[3];
  
endmodule
