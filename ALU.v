`define AND   4'b0000
`define OR    4'b0001
`define ADD   4'b0010
`define SUB   4'b0110
`define PassB 4'b0111
`define MOVZ 4'b11??

module ALU(BusW, BusA, BusB, ALUCtrl, Zero);
    
    parameter n = 64;
	
	
    //declares ports
	
    output  [n-1:0] BusW;
    input   [n-1:0] BusA, BusB;
    input   [3:0] ALUCtrl;
    output  Zero;
    
	//internal reg
    reg     [n-1:0] BusW;
    
    always @(ALUCtrl or BusA or BusB) begin
        casez(ALUCtrl)
            `AND: begin
                BusW <= BusA & BusB;
				$display("AND busA: %h BusW: %h", BusA, BusB, BusW);
            end
            `OR: begin 
			     BusW <=  BusA | BusB;
				$display("OR busA: %h BusW %h", BusA, BusB, BusW);
		    end
			`ADD: begin
			    BusW <= BusA + BusB;
				 $display("ADD busA: %h BusW %h", BusA, BusB, BusW);
			end 
		    `SUB: begin
			    BusW <= BusA - BusB;
				 $display("SUB busA: %h BusW %h", BusA, BusB, BusW);
			end
			`PassB: begin
			     BusW <= BusB;
				 $display("PassB BusB: %BusW = %h", BusB, BusW); //pass b outputs busB
              
			end
            `MOVZ: begin
              BusW <= BusB << (ALUCtrl[1:0]*16);
            end
          
          default BusW = 0;
        endcase
    end
  

  assign #1 Zero = (BusW == 64'b0);
	//$display("zero = %h  BusW = %h", Zero, BusW);
endmodule