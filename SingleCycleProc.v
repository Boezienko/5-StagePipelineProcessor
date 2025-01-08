//`include "32x64Register.v"
//`include "ALU.v"
//`include "DataMemory.v"
//`include "InstructionMemory.v"
//`include "NextPC.v"
//`include "SignExtender.v"
//`include "SingleCycleControl.v"

module singlecycle(
    input resetl,
    input [63:0] startpc,
    output reg [63:0] currentpc,
    output [63:0] dmemout,
    input CLK
);

    wire [63:0] dmemmux;
  
    // Next PC connections
    wire [63:0] nextpc;       // The next PC, to be updated on clock cycle

    // Instruction Memory connections
    wire [31:0] instruction;  // The current instruction

    // Parts of instruction
    wire [4:0] rd;            // The destination register
    wire [4:0] rm;            // Operand 1
    wire [4:0] rn;            // Operand 2
    wire [10:0] opcode;

    // Control wires
    wire reg2loc;
    wire alusrc;
    wire mem2reg;
    wire regwrite;
    wire memread;
    wire memwrite;
    wire branch;
    wire uncond_branch;
    wire [3:0] aluctrl;
    wire [2:0] signop;

    // Register file connections
    wire [63:0] regoutA;     // Output A
    wire [63:0] regoutB;     // Output B

    // ALU connections
    wire [63:0] aluout;
    wire zero;

    // Sign Extender connections
    wire [63:0] extimm;
    wire [25:0] inext;
  

    // PC update logic
    always @(negedge CLK)
    begin
        if (resetl)
            currentpc <= nextpc;
        else
            currentpc <= startpc;
    end
	
	// making the next PC with NextPC for next instruction
    NextPC NextPC(
        .NextPC(nextpc),
        .CurrentPC(currentpc),
        .SignExtImm64(extimm),
        .Branch(branch),
        .ALUZero(zero),
        .Uncondbranch(uncond_branch)
    );
	
    // Parts of instruction
    assign rd = instruction[4:0];
    assign rm = instruction[9:5];
    assign rn = reg2loc ? instruction[4:0] : instruction[20:16];
    assign opcode = instruction[31:21];
    assign inext = instruction[25:0];
	
  
	// getting instructions
    InstructionMemory imem(
        .Data(instruction),
        .Address(currentpc)
    );
	
	// control unit
    control control(
        .reg2loc(reg2loc),
        .alusrc(alusrc),
        .mem2reg(mem2reg),
        .regwrite(regwrite),
        .memread(memread),
        .memwrite(memwrite),
        .branch(branch),
        .uncond_branch(uncond_branch),
        .aluop(aluctrl),
        .signop(signop),
        .opcode(opcode)
    );

    /*
    * Connect the remaining datapath elements below.
    * Do not forget any additional multiplexers that may be required.
    */
	
	// making the mux that goes into ALU
	wire [63:0] mux2out;
    assign mux2out = alusrc ? extimm : regoutB;
	
  //sign extender
  SignExtender SignExt(
    
    .BusImm(extimm),
    .Imm26(inext),
    .Ctrl(signop)
  );
  
	// making the ALU 
	ALU ALU(
            .BusW(aluout),
            .BusA(regoutA),
            .BusB(mux2out),
            .ALUCtrl(aluctrl),
            .Zero(zero)
        );
	
	// making mux after data memory
	
    DataMemory DataMemory(
        .ReadData(dmemout),
        .Address(aluout),
        .WriteData(regoutB),
        .MemoryRead(memread),
        .MemoryWrite(memwrite),
        .Clock(CLK)
    );
	
	assign dmemmux = mem2reg ? dmemout: aluout;
	
	// making register file
	Register32x64 Register32x64(
        .BusA(regoutA),
        .BusB(regoutB),
        .BusW(dmemmux),
        .RA(rm),
        .RB(rn),
        .RW(rd),
        .RegWr(regwrite),
        .Clk(CLK)
    );

endmodule