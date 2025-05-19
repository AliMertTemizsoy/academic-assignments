// Testbench for our second RISC-V processor

module riscv_processor_v2_tb();
    reg clk, reset; // Clock and reset signals
    wire [31:0] pc_current; // Current program counter value (address of the current instruction)
    wire [31:0] instr; // Instruction input (from memory)
    wire mem_write; // Memory write enable signal
    wire [31:0] alu_result, write_data; // ALU result and data to be written to memory or register
    wire [31:0] read_data; // Data read from memory
    
    // Monitor for program counter changes
    integer pc_monitor;
    
    // Instruction memory 
    reg [31:0] instr_mem[0:255];  // 256 word'lük bellek
    
    // Data memory 
    reg [31:0] data_mem[0:2047];   
    
    // Processor instantiation
    riscv_processor_v2 dut(
        .clk(clk), // Clock signal
        .reset(reset), // Reset signal
        .pc_current(pc_current), // Current program counter value
        .instr(instr), // Instruction input
        .mem_write(mem_write), // Memory write enable signal
        .alu_result(alu_result), // ALU result output
        .write_data(write_data), // Data to be written to memory or register
        .read_data(read_data) // Data read from memory
    );
    
    // Instruction memory read
    assign instr = instr_mem[pc_current[9:2]]; // Word aligned (PC[9:2] = address / 4)
    
    // Data memory write (word aligned)
    always @(posedge clk) begin
        if (mem_write && !reset) begin // Memory write enabled and not in reset state
            if (alu_result[9:2] < 2048) begin // Memory boundary check
                data_mem[alu_result[9:2]] = write_data; // Word aligned (alu_result[9:2] = address / 4)
                $display("Memory write: address = %d (index %d), data = %h", alu_result, alu_result[9:2], write_data);
            end else begin
                $display("WARNING: Memory write attempt out of bounds! Address: %d", alu_result);
            end
        end
    end
    
    // Data memory read (word aligned)
    assign read_data = (alu_result[9:2] < 2048) ? data_mem[alu_result[9:2]] : 32'b0; // Memory boundary check
    
    // Clock 
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        $dumpfile("processor_v2.vcd"); // VCD file for GTKWave
        $dumpvars(0, riscv_processor_v2_tb); // Dump all variables for waveform viewing
    end
    
    // Test program
    initial begin
        // Initialize memories and signals
        clk = 0; // Clock signal
        reset = 1; // Reset signal
        pc_monitor = 0; // Monitor for program counter changes
        
        $display("Reset state: mem_write = %b", mem_write);
        
        // Initialize instruction memory to NOP
        for (integer i = 0; i < 256; i = i + 1) begin
            instr_mem[i] = 32'h00000013;  // NOP (No Operation) instruction
        end
        
        // Initialize data memory
        for (integer i = 0; i < 2048; i = i + 1) begin
            data_mem[i] = 32'h00000000; // Initialize data memory to zero
        end
        
        // Initialize test program in instruction memory
        
        // Test program: Simple arithmetic and memory operations
        instr_mem[0] = 32'h00500093;  // addi x1, x0, 5    # x1 = 5
        instr_mem[1] = 32'h00300113;  // addi x2, x0, 3    # x2 = 3
        instr_mem[2] = 32'h00209133;  // sll x2, x1, x2    # x2 = x1 << x2 = 5 << 3 = 40
        instr_mem[3] = 32'h00108193;  // addi x3, x1, 1    # x3 = x1 + 1 = 6
        instr_mem[4] = 32'h00100793;  // addi x15, x0, 1  (x15 = 1)
        instr_mem[5] = 32'h001F9293;  // slli x5, x15, 1  (x15 = 1, x5 = 2)
        
        // Memory operations
        instr_mem[6] = 32'h00512023;  // sw x5, 0(x2)      # mem[x2] = x5 (mem[40] = 320)
        instr_mem[7] = 32'h00012303;  // lw x6, 0(x2)      # x6 = mem[x2] (x6 = 320)
        
        // Branch operation
        instr_mem[8] = 32'h00628463;  // beq x5, x6, skip  # x5 == x6 => skip (x5 = 320, x6 = 320)
        instr_mem[9] = 32'h00000013;  // nop               # NOP (No Operation)
        
        // additional instruction to skip to
        instr_mem[10] = 32'h00400393; // addi x7, x0, 4    # x7 = 4
        
        // End program
        instr_mem[11] = 32'h00000063; // beq x0, x0, end   # Infinite loop (end program)
        
        // Release reset
        #10 reset = 0;
        
        // Run for enough cycles to complete the program
        #500;
        
        // Display register file contents
        display_registers();
        
        // Display key memory locations 
        $display("Data Memory Contents:");
        $display("mem[%d] = %h", 40 >> 2, data_mem[40 >> 2]);  
        
        $finish;
    end
    
    // Register file contents display
    task display_registers;
        begin
            $display("Register File Contents:");
            $display("x1 = %h", dut.dp.rf.registers[1]);   // x1 = 5
            $display("x2 = %h", dut.dp.rf.registers[2]);   // x2 = 40
            $display("x3 = %h", dut.dp.rf.registers[3]);   // x3 = 6
            $display("x4 = %h", dut.dp.rf.registers[4]);   // x4 = 12
            $display("x5 = %h", dut.dp.rf.registers[5]);   // x5 = 320
            $display("x6 = %h", dut.dp.rf.registers[6]);   // x6 = 320
            $display("x7 = %h", dut.dp.rf.registers[7]);   // x7 = 4
        end
    endtask
    
    // Program counter monitor
    always @(posedge clk) begin
        if (!reset && pc_current != pc_monitor) begin // Check for changes in program counter
            $display("Time: %4d, PC: %h, Instr: %h", $time, pc_current, instr);
            pc_monitor = pc_current;
        end
    end
endmodule

// iverilog -o processor_v2_vvp -s riscv_processor_v2_tb alu_decoder_v2.v alu_mips_v2.v and_32bit.v control_unit.v datapath.v fulladder_32bit.v imm_generator.v main_decoder.v or_32bit.v program_counter.v register_file.v riscv_processor_v2.v riscv_processor_v2_tb.v setlessthan_32bit.v signext.v sll_32bit.v subtractor_32bit.v
// vvp processor_v2_vvp
// gtkwave 