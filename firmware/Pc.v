module PC(PCIn,reset,clk,PCOut);
  input [31:0]PCIn;
  input clk,reset;
  output reg [31:0]PCOut;

  always@(posedge clk,negedge reset)
  begin
    if(reset==0)
      PCOut<=32'h00000000;
    else
      PCOut<=PCIn;
  end
endmodule