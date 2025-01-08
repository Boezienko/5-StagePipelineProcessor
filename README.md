# 5-StagePipelineProcessor
 
# 5-Stage Pipeline Processor ## Overview This project is a 5-stage pipeline processor coded in Verilog using the ARMv8 instruction set. The processor is designed to run on a Raspberry Pi or an Ubuntu virtual machine using Icarus Verilog for simulation and GTKWave for waveform analysis.

## Files
- `SignExtender.v`: Performs sign extension for different instruction types.
- `NextPC.v`: Calculates the next program counter (PC) value.
- `InstructionMemory.v`: Implements read-only instruction memory.
- `DataMemory.v`: Implements data memory for storing and retrieving data.
- `ALU.v`: Implements the Arithmetic Logic Unit (ALU).
- `32x64Register.v`: Implements a 32x64 register file.
- `SingleCycleControl.v`: Implements the control unit for a single-cycle processor.
- `SingleCycleProc.v`: Implements the single-cycle processor.
- `SingleCycleProcTest.v`: Tests the single-cycle processor. 

## Prerequisites
- Raspberry Pi or Ubuntu virtual machine
- Icarus Verilog 
- GTKWave

## Installation
1. **Clone the repository from GitHub**:
```sh git clone https://github.com/yourusername/5-Stage-Pipeline-Processor.git cd 5-Stage-Pipeline-Processor```
2. **Install Icarus Verilog**:
```sh sudo apt-get install iverilog```
3. **Install GTKWave**:
```sh sudo apt-get install gtkwave```

## Usage
1. **Compile the Verilog files**:
```sh iverilog -o SincleCycleProcTest SincleCycleControl.v SincleCycleProc.v SincleCycleProcTest.v ALU.v DataMemory.v InstructionMemory.v NextPC.v SignExtender.v```
2. **Run the simulation**:
```sh vvp SincleCycleProcTest```
3. **Open GTKWave and Load the VCD file**:
```sh gtkwave SincleCycleProcTest.vcd```

