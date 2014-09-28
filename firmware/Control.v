module Control(In,IRQ,PCSrc,RegDst,RegWr,ALUSrc1,ALUSrc2,
                ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,LUOp);
input [31:0] In;
wire [31:0] Instruct;
assign Instruct[31:0]=In[31:0];
input IRQ;
output reg [2:0]PCSrc;
output reg [1:0]RegDst,MemToReg;
output reg [5:0]ALUFun;
output reg RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp;

always @(*)
begin
  if(IRQ)
  begin
    PCSrc=3'b100;//ILLOP
    RegDst=2'b11;//XP
    RegWr=1;//write
    MemWr=0;//not to write
    MemRd=0;//not to read
    MemToReg=2'b10;//PC+4
    //else don't care
  end
  else
  begin
    case(Instruct[31:26])
      6'b000000:         //R-type
      begin
        case(Instruct[5:0])
          6'b10_0000:     //add
          begin
            PCSrc=3'b000;
            RegDst=2'b00;
            RegWr=1;//write
            ALUSrc1=0;
            ALUSrc2=0;
            ALUFun=6'b00_0000;
            Sign=1;//sign
            MemWr=0;
            MemRd=0;
            MemToReg=2'b00;
          end
          6'b10_0001:     //addu
          begin
            PCSrc=3'b000;
            RegDst=2'b00;
            RegWr=1;//write
            ALUSrc1=0;
            ALUSrc2=0;
            ALUFun=6'b00_0000;
            Sign=0;//unsign
            MemWr=0;
            MemRd=0;
            MemToReg=2'b00;
          end
          6'b10_0010:     //sub
          begin
            PCSrc=3'b000;
            RegDst=2'b00;
            RegWr=1;//write
            ALUSrc1=0;
            ALUSrc2=0;
            ALUFun=6'b00_0001;// -
            Sign=1;//sign
            MemWr=0;
            MemRd=0;
            MemToReg=2'b00;
          end
          6'b10_0011:     //subu
          begin
            PCSrc=3'b000;
            RegDst=2'b00;
            RegWr=1;//write
            ALUSrc1=0;
            ALUSrc2=0;
            ALUFun=6'b00_0001;//-
            Sign=0;//unsign
            MemWr=0;
            MemRd=0;
            MemToReg=2'b00;
          end
          6'b10_0100:     //and
          begin
            PCSrc=3'b000;
            RegDst=2'b00;
            RegWr=1;//write
            ALUSrc1=0;
            ALUSrc2=0;
            ALUFun=6'b01_1000;// &
            MemWr=0;
            MemRd=0;
            MemToReg=2'b00;
          end
          6'b10_0101:     //or
          begin
            PCSrc=3'b000;
            RegDst=2'b00;
            RegWr=1;//write
            ALUSrc1=0;
            ALUSrc2=0;
            ALUFun=6'b01_1110;// |
            MemWr=0;
            MemRd=0;
            MemToReg=2'b00;
          end
          6'b10_0110:     //xor
          begin
            PCSrc=3'b000;
            RegDst=2'b00;
            RegWr=1;//write
            ALUSrc1=0;
            ALUSrc2=0;
            ALUFun=6'b01_0110;// ^
            MemWr=0;
            MemRd=0;
            MemToReg=2'b00;
          end
          6'b10_0111:     //nor
          begin
            PCSrc=3'b000;
            RegDst=2'b00;
            RegWr=1;//write
            ALUSrc1=0;
            ALUSrc2=0;
            ALUFun=6'b01_0001;// ~(A|B)
            MemWr=0;
            MemRd=0;
            MemToReg=2'b00;
          end
          6'b10_1010:     //slt
          begin
            PCSrc=3'b000;
            RegDst=2'b00;
            RegWr=1;//write
            ALUSrc1=0;
            ALUSrc2=0;
            ALUFun=6'b11_0101;// 
            Sign=1;
            MemWr=0;
            MemRd=0;
            MemToReg=2'b00;
          end
          6'b00_0000:     //sll & nop
          begin
            PCSrc=3'b000;
            RegDst=2'b00;//rd
            RegWr=1;//write
            ALUSrc1=1;//shamt
            ALUSrc2=0;
            ALUFun=6'b10_0000;// <<
            //Sign=1;
            MemWr=0;
            MemRd=0;
            MemToReg=2'b00;
          end
          6'b00_0010:     //srl
          begin
            PCSrc=3'b000;
            RegDst=2'b00;
            RegWr=1;//write
            ALUSrc1=1;
            ALUSrc2=0;
            ALUFun=6'b10_0001;// >>
            //Sign=1;
            MemWr=0;
            MemRd=0;
            MemToReg=2'b00;
          end
          6'b00_0011:      //sra
          begin
            PCSrc=3'b000;
            RegDst=2'b00;
            RegWr=1;//write
            ALUSrc1=1;
            ALUSrc2=0;
            ALUFun=6'b10_0011;// >>a
            //Sign=1;
            MemWr=0;
            MemRd=0;
            MemToReg=2'b00;
          end
          6'b00_1000:      //jr
          begin
            PCSrc=3'b011;//DataBusA $Ra
            RegWr=0;//not to write
            MemWr=0;
            MemRd=0;
          end
          6'b00_1001:     //jalr
          begin
            PCSrc = 3'b101 ;
            RegDst = 2'b10 ; //Ra 
            RegWr =  1 ;    //write 
            ALUSrc1 = 0 ;   
            ALUSrc2 = 0 ;   
            MemWr = 0 ;    
            MemRd = 0 ;
            MemToReg = 2'b10 ; //PC+4
          end
          default:
          begin
            PCSrc = 3'b101;//XADR
            RegDst=2'b11;//XP
            RegWr=1;//write
            MemWr=0;//not to write
            MemRd=0;//not to read
            MemToReg=2'b10;//PC+4
          end
        endcase
      end
      6'b00_1000:        //addi
      begin
        PCSrc=3'b000;
        RegDst=2'b01;//Rt
        RegWr=1;//write
        ALUSrc1=0;//busA
        ALUSrc2=1;//imm
        ALUFun=6'b00_0000;
        Sign=1;//sign
        MemWr=0;
        MemRd=0;
        MemToReg=2'b00;//ALU
        EXTOp=1;//sign
        LUOp=0;//16
      end
      6'b00_1001:        //addiu
      begin
        PCSrc=3'b000;
        RegDst=2'b01;//Rt
        RegWr=1;//write
        ALUSrc1=0;//busA
        ALUSrc2=1;//imm
        ALUFun=6'b00_0000;
        Sign=0;//nosign
        MemWr=0;
        MemRd=0;
        MemToReg=2'b00;//ALU
        EXTOp=0;//nosign
        LUOp=0;//16
      end
      6'b00_1100:         //andi
      begin
        PCSrc=3'b000;
        RegDst=2'b01;//Rt
        RegWr=1;//write
        ALUSrc1=0;//busA
        ALUSrc2=1;//imm
        ALUFun=6'b01_1000;
        MemWr=0;
        MemRd=0;
        MemToReg=2'b00;//ALU
        EXTOp=0;//nosign
        LUOp=0;//16
      end
      6'b00_1010:        //slti
      begin
        PCSrc=3'b000;
        RegDst=2'b01;//Rt
        RegWr=1;//write
        ALUSrc1=0;//busA
        ALUSrc2=1;//imm
        ALUFun=6'b11_0101;
        Sign=1;//sign
        MemWr=0;
        MemRd=0;
        MemToReg=2'b00;//ALU
        EXTOp=1;//sign
        LUOp=0;//16
      end
      6'b00_1011:        //sltiu
      begin
        PCSrc=3'b000;
        RegDst=2'b01;//Rt
        RegWr=1;//write
        ALUSrc1=0;//busA
        ALUSrc2=1;//imm
        ALUFun=6'b11_0101;
        Sign=0;//nosign
        MemWr=0;
        MemRd=0;
        MemToReg=2'b00;//ALU
        EXTOp=0;//nosign
        LUOp=0;//16
      end
      6'b00_0100:        //beq
      begin
        PCSrc=3'b001;//ALUOut or ConBA
        RegWr=0;
        ALUSrc1=0;//busA
        ALUSrc2=0;//busB
        ALUFun=6'b11_0011;
        Sign=1;
        MemWr=0;
        MemRd=0;
        EXTOp=1;//sign
      end
      6'b00_0101:        //bne
      begin
        PCSrc=3'b001;//ALUOut or ConBA
        RegWr=0;
        ALUSrc1=0;//busA
        ALUSrc2=0;//busB
        ALUFun=6'b11_0001;
        Sign=1;
        MemWr=0;
        MemRd=0;
        EXTOp=1;//sign
      end
      6'b00_0110:        //blez
      begin
        PCSrc=3'b001;//ALUOut or ConBA
        RegWr=0;
        ALUSrc1=0;//busA
        ALUSrc2=0;//busB
        ALUFun=6'b11_1101;
        Sign=1;
        MemWr=0;
        MemRd=0;
        EXTOp=1;//sign
      end
      6'b00_0111:        //bgtz
      begin
        PCSrc=3'b001;//ALUOut or ConBA
        RegWr=0;
        ALUSrc1=0;//busA
        ALUSrc2=0;//busB
        ALUFun=6'b11_1111;
        Sign=1;
        MemWr=0;
        MemRd=0;
        EXTOp=1;//sign
      end
      6'b00_0001:        //bgez
      begin
        PCSrc=3'b001;//ALUOut or ConBA
        RegWr=0;
        ALUSrc1=0;//busA
        ALUSrc2=0;//busB
        ALUFun=6'b11_1001;
        Sign=1;
        MemWr=0;
        MemRd=0;
        EXTOp=1;//sign//
      end
      6'b00_0010:        //j
      begin
        PCSrc=3'b010;//JT
        RegWr=0;
        MemWr=0;
        MemRd=0;
      end
      6'b00_0011:        //jal
      begin
        PCSrc = 3'b010 ;//JT
        RegDst = 2'b10 ; //Ra //
        RegWr =  1 ;    //write 
        ALUSrc1 = 0 ;   //
        ALUSrc2 = 0 ;   //
        MemWr = 0 ;    
        MemRd = 0 ;
        MemToReg = 2'b10 ; //PC+4//
      end
      6'b10_0011:        //lw
      begin
        PCSrc=3'b000;
        RegDst=2'b01;//Rt
        RegWr=1;//write
        ALUSrc1=0;//busA
        ALUSrc2=1;//imm
        ALUFun=6'b00_0000;
        Sign=1;//sign
        MemWr=0;
        MemRd=1;//lw
        MemToReg=2'b01;//RAM
        EXTOp=1;//sign
        LUOp=0;//16
      end
      6'b10_1011:        //sw
      begin
        PCSrc=3'b000;
        RegWr=0;//not to write
        ALUSrc1=0;//busA
        ALUSrc2=1;//imm
        ALUFun=6'b00_0000;
        Sign=1;//sign
        MemWr=1;//sw
        MemRd=0;
        EXTOp=1;//sign
        LUOp=0;//16
      end
      6'b00_1111:        //lui
      begin
        PCSrc=3'b000;
        RegDst=2'b01;//Rt
        RegWr=1;//write
        ALUSrc1=0;//busA
        ALUSrc2=1;//imm
        ALUFun=6'b000000;//or
        //Sign=1;//sign
        MemWr=0;
        MemRd=0;
        MemToReg=2'b00;//ALU
        LUOp=1;//16,0(32)
      end
    
      default:
      begin
        PCSrc = 3'b101;//XADR
        RegDst=2'b11;//XP
        RegWr=1;//write
        MemWr=0;//not to write
        MemRd=0;//not to read
        MemToReg=2'b10;//PC+4
      end
    endcase
  end
end

endmodule