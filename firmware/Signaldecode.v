module Signaldecode(Instruct,JT,Imm16,Shamt,Rd,Rt,Rs);
  input [31:0]Instruct;
  output [25:0]JT;
  output [15:0]Imm16;
  output [4:0]Shamt,Rd,Rt,Rs;
  assign JT=Instruct[25:0];
  assign Imm16=Instruct[15:0];
  assign Shamt=Instruct[10:6];
  assign Rd=Instruct[15:11];
  assign Rt=Instruct[20:16];
  assign Rs=Instruct[25:21];
endmodule