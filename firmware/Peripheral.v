module Peripheral (reset,clk,rd,wr,addr,wdata,rdata,led,switch,digi,irqout,en);
input reset,clk;
input rd,wr;
input [31:0] addr;
input [31:0] wdata;
output [31:0] rdata;
reg [31:0] rdata;
output en;
reg en;

output [7:0] led;
reg [7:0] led;
input [7:0] switch;
output [11:0] digi;
reg [11:0] digi;
output irqout;
reg irqout;

reg [31:0] TH,TL;
reg [2:0] TCON;

wire tenup;
wire [3:0]unit,decade;
wire [6:0]unitdi,decadedi;
wire [11:0]udigi,ddigi;
assign tenup=wdata[3]&wdata[2]|wdata[3]&wdata[1];
assign unit=(tenup)?(wdata-4'b1010):wdata;
assign decade=(tenup)?4'b0001:4'b0;
assign udigi={5'b11101,unitdi};
assign ddigi={5'b11011,decadedi};
decorder7 decode1(unit,unitdi);
decorder7 decode2(decade,decadedi);

always@(*) begin
	if(rd) begin
		case(addr)
			32'h40000000: begin
			rdata <= TH;
			en<=1;
			end			
			32'h40000004: begin
			rdata <= TL;
			en<=1;
			end			
			32'h40000008: begin
			rdata <= {29'b0,TCON};
			en<=1;
			end				
			32'h4000000C: begin
			rdata <= {24'b0,led};
			en<=1;
			end			
			32'h40000010: begin
			rdata <= {24'b0,switch};
			en<=1;
			end
			32'h40000014: begin
			rdata <= {20'b0,digi};
			en<=1;
			end
			default: rdata <= 32'b0;
		endcase
	end
	else
		rdata <= 32'b0;
end

always@(negedge reset or posedge clk) begin
	if(~reset) begin
		TH <= 32'b0;
		TL <= 32'b0;
		TCON <= 3'b0;	
	end
	else begin
	  irqout<=0;
		if(TCON[0]) begin	//timer is enabled
			if(TL==32'hffffffff) begin
				TL <= TH;
				if(TCON[1])
				begin
				TCON[2] <= 1'b1;		//irq is enabled
				irqout<=1;
				end
			end
			else TL <= TL + 1;
		end
		
		if(wr) begin
			case(addr)
				32'h40000000: TH <= wdata;
				32'h40000004: TL <= wdata;
				32'h40000008: TCON <= wdata[2:0];		
				32'h4000000C: led <= wdata[7:0];			
				32'h40000014: begin
				if(digi==ddigi) digi <= udigi;
				else  digi<= ddigi;
				end
				default: ;
			endcase
		end
	end
end
endmodule



module decorder7(x,out);
	 input [3:0] x;
	 output [6:0] out;
	 assign out = 
	 (x==0)?7'b000_0001:
	 (x==1)?7'b100_1111:
	 (x==2)?7'b001_0010:
	 (x==3)?7'b000_0110:
	 (x==4)?7'b100_1100:
	 (x==5)?7'b010_0100:
	 (x==6)?7'b010_0000:
	 (x==7)?7'b000_1111:
	 (x==8)?7'b000_0000:
	 (x==9)?7'b000_0100:
	 (x==10)?7'b000_1000:
	 (x==11)?7'b110_0000:
	 (x==12)?7'b011_0001:
	 (x==13)?7'b100_0010:
	 (x==14)?7'b011_0000:
	 (x==15)?7'b011_1000:7'b111_1111;             
endmodule
