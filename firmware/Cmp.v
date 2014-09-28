
module CMP(ALUFun,Z,V,N,S);
    input [2:0] ALUFun;
    input Z,V,N;
    output [31:0] S;
    wire [31:0]A,B,C,D,E,F,G,H;
    assign A={31'd0,~Z};
    assign B={31'd0,Z};
    assign C={31'd0,N};
    assign D=32'd0;
    assign E={31'd0,~N};
    assign F=32'd0;
    assign G={31'd0,Z||N};
    assign H={31'd0,~(Z||N)};
    Mux_8 m(A,B,C,D,E,F,G,H,ALUFun,S);  
  endmodule
