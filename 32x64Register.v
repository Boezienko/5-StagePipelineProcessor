`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2022 11:46:39 PM
// Design Name: 
// Module Name: 32x24Register
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Register32x64(BusA, BusB, BusW, RW, RA, RB, RegWr, Clk);
    output wire [63:0] BusA;
    output wire [63:0] BusB;
    input wire [63:0] BusW;
    input [4:0] RW, RA, RB;             // making 5 bit busses to pick which of the 32 register
    input RegWr;
    input Clk;
    reg [63:0] registers [31:0];        // 64 32 bit registers
     
    assign BusA = registers[RA];
    assign BusB = registers[RB];
    
    // making register 31 zero
    initial
        begin
            registers[31] <= 64'b0;     //making XZR
        end
    
    always @ (negedge Clk) begin        //data on Bus W sotred in Rw on falling clock edge
        if(RegWr & RW != 5'b11111)          
            begin
                registers[RW] <= BusW;      // if RegWr == 1 and it's not XZR we store the data on Bus W into the register specified by RW
            end
        end
endmodule
