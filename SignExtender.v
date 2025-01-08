module SignExtender(BusImm, Imm26, Ctrl);
	// declaring ports
  output reg [63:0] BusImm; //outputs 64 bit extended
  input [25:0] Imm26; //instruction input
  input [2:0] Ctrl; //2 bit control signal
  
  reg [1:0] shift;
 
 //<= for registers, = wires

  always @(*) begin
  case (Ctrl)							   // 000 for I-Type, 001 for D-Type, 010 for B-Type, 011 for CBZ
	3'b000 :  begin		// I-type
		               // extension bit is the leftmost bit on the immediate
      BusImm <= {{52{1'b0}}, Imm26[21:10]};  //adding bits on left 
		 end
	3'b001 :  begin		// D-type
		                // extension bit is the leftmost bit on the immediate
			BusImm <= {{55{Imm26[20]}}, Imm26[20:12]};  //adding bits on left
		 end
	3'b010 :  begin		// B-type
		            
			BusImm <= {{38{Imm26[25]}}, Imm26[25:0]};  //adding bits on left
	
		 end
	3'b011 :  begin		// CBZ
		                  // extension bit is the leftmost bit on the immediate
			BusImm <= {{45{Imm26[23]}}, Imm26[23:5]};  //adding bits on left

		 end
	default :  begin
            BusImm <= {{48{1'b0}}, Imm26[20:5]};       // extension bit is the leftmost bit on the immediate
		    

		 end
		
	endcase // case (Ctrl)
  end // always @ (Ctrl)
endmodule