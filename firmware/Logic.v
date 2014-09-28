module Logic(A,B,func,Cout);
	input [31:0] A;
	input [31:0] B;
	input [3:0] func;
	output [31:0] Cout;
	
	wire [31:0] And,Or,Nor,Xor;
	Or_32 o0(Or,A,B);
	And_32 a0(And,A,B);
	Nor_32 n0(Nor,A,B);
	Xor_32 x0(Xor,A,B);
	Mux_8 m0(Nor,A,A,Xor,And,A,A,Or,func[3:1],Cout);
	
endmodule

module And_32(Cout,A,B);
	input [31:0] A;
	input [31:0] B;
	output [31:0] Cout;
	genvar i;
	generate
    for(i=0;i<32;i=i+1)
    begin
      and (Cout[i],A[i],B[i]);
    end
  endgenerate
endmodule

module Nor_32(Cout,A,B);
	input [31:0] A;
	input [31:0] B;
	output [31:0] Cout;
	
	genvar i;
	generate
    for(i=0;i<32;i=i+1)
    begin
      nor (Cout[i],A[i],B[i]);
    end
  endgenerate
	
endmodule

module Xor_32(Cout,A,B);
	input [31:0] A;
	input [31:0] B;
	output [31:0] Cout;
	
	genvar i;
	generate
    for(i=0;i<32;i=i+1)
    begin
      xor (Cout[i],A[i],B[i]);
    end
    endgenerate
	
	
endmodule

module Or_32(Cout,A,B);
	input [31:0] A;
	input [31:0] B;
	output [31:0] Cout;
	genvar i;
	generate
    for(i=0;i<32;i=i+1)
    begin
      or (Cout[i],A[i],B[i]);
    end
    endgenerate
	
endmodule
