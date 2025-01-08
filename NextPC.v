`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module NextPC(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);

    //declaring ports
    input [63:0] CurrentPC, SignExtImm64;
    input Branch, ALUZero, Uncondbranch;
    output reg [63:0] NextPC;

    //internal variable
    reg mux;

    always @(*)
        begin

            //mutiplexers have delay of #1
            //mux gate logic for PC addressing
            mux <= Uncondbranch | (Branch & ALUZero);

            if(mux)
                begin
                    //ADD has delay of #2
                    NextPC <= CurrentPC + (SignExtImm64 << 2);
                end

            else if(~mux)
                begin
                    //ADDI has delay of #1
                    NextPC <= CurrentPC + 4;
                end
        end
endmodule
