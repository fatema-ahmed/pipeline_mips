`include"Alu.v"
`include"Control.v"
`include"Mux.v"
`include"Exts.v"
`include"RegFile.v"
`include"DataMem.v"
`include"Peripheral.v"
`include"Rom.v"
`include"Signaldecode.v"
`include"digitube_scan.v"

module ALUss(RegDst,RegWr,ALUSrc1,ALUFun,Sign,MemToReg,MemRd,ConBA,MemWr,ALUSrc2,LUOp,EXTOp,Imm16,Shamt,Rt,Rs,Rd,Ra,xp,
PC_4,clk,reset,ALUOut_0,DataBus_A,led,switch,digi,irqout);
input [1:0]RegDst,MemToReg;
input RegWr,ALUSrc1,MemRd,MemWr,ALUSrc2,Sign,LUOp,EXTOp;
input [5:0]ALUFun;
input [15:0]Imm16;
input [4:0]Shamt,Rt,Rs,Rd,Ra,xp;
input [31:0]PC_4;
input reset,clk;
input [7:0] switch;
output [31:0]ConBA,DataBus_A;
output ALUOut_0,irqout;
output [7:0] led;
output [11:0] digi;
wire [31:0]DataBus_A,DataBus_B,ALUOut,Read_Data,Read_Data0,Read_Data1,DataBus_C,intoALUSrc2,intoConBA,Shamt_32,Imm16_32;
wire [31:0]intoALU1,intoALU2;
wire [4:0]intoAddrC;
wire [31:0]intoLUOp1,intoLUOp2;
wire en;
MuxFour_5 p0(Rd,Rt,Ra,xp,RegDst,intoAddrC);
RegFile p1(reset,clk,Rs,DataBus_A,Rt,DataBus_B,RegWr,intoAddrC,DataBus_C);
EXT_5_32 p2(Shamt,1'b0,Shamt_32);
Mux_2 p3(DataBus_A,Shamt_32,ALUSrc1,intoALU1);  
EXT_16_32 p4(Imm16,1'b0,Imm16_32);
SLL p5(16,Imm16_32,intoLUOp1);      
EXT_16_32 p6(Imm16,EXTOp,intoLUOp2);
Mux_2 p7(intoLUOp2,intoLUOp1,LUOp,intoALUSrc2);
Mux_2 p8(DataBus_B,intoALUSrc2,ALUSrc2,intoALU2);
SLL p9(2,intoLUOp2,intoConBA);
assign ConBA=PC_4+intoConBA;
Alu p10(intoALU1,intoALU2,ALUFun,Sign,ALUOut);
DataMem p11(reset,clk,MemRd,MemWr,ALUOut,DataBus_B,Read_Data0);
Peripheral p12(.reset(reset),.clk(clk),.rd(MemRd),.wr(MemWr),.addr(ALUOut),.wdata(DataBus_B),.rdata(Read_Data1),.led(led),.switch(switch),.digi(digi),.irqout(irqout),.en(en));
Mux_2 p13(Read_Data0,Read_Data1,en,Read_Data);     
Mux_4 p14(ALUOut,Read_Data,PC_4,1,MemToReg,DataBus_C);   //data two choices
LastNumber p15(ALUOut,ALUOut_0);   //Alu_0 for PC
endmodule

module Mips_D(reset,clk,switch,led,digi_out1,digi_out2,digi_out3,digi_out4);
input clk,reset;
input [7:0] switch;
output [7:0]led;
output [6:0] digi_out1;	//0: CG,CF,CE,CD,CC,CB,CA
output [6:0] digi_out2;	//1: CG,CF,CE,CD,CC,CB,CA
output [6:0] digi_out3;	//2: CG,CF,CE,CD,CC,CB,CA
output [6:0] digi_out4;	//3: CG,CF,CE,CD,CC,CB,CA
wire [11:0]digi;
wire [31:0]PCoutin,PCout,PC_4,ConBA,PCSrcIn,JT_32,DataBus_A,In;
wire [31:0]PCin;
wire ALUOut_0,irqout;
wire [25:0]JT;
wire [15:0]Imm16;
wire [4:0]Shamt,Rd,Rt,Rs;
wire [2:0]PCSrc;
wire [1:0]RegDst,MemToReg;
wire RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp;
wire [5:0]ALUFun;
PC q1(PCin,reset,clk,PCout);
assign PC_4=PCout+4;
Mux_2 q2(PC_4,ConBA,ALUOut_0,PCSrcIn); 
Mux_8 q3(PC_4,PCSrcIn,JT_32,DataBus_A,32'h80000004,32'h80000008,1,1,PCSrc,PCin);
SRL q4(2,PCout,PCoutin);  
ROM q5(PCoutin,In);
Signaldecode q6(In,JT,Imm16,Shamt,Rd,Rt,Rs);
JText q7(JT,JT_32);
Control q8(In,irqout,PCSrc,RegDst,RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,LUOp);
ALUss q9(RegDst,RegWr,ALUSrc1,ALUFun,Sign,MemToReg,MemRd,ConBA,MemWr,ALUSrc2,LUOp,EXTOp,Imm16,Shamt,Rt,Rs,Rd,5'd31,5'd26,PC_4,clk,reset,ALUOut_0,DataBus_A,led,switch,digi,irqout);
digitube_scan q10(digi,digi_out1,digi_out2,digi_out3,digi_out4);
endmodule






