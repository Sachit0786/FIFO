`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2024 23:56:35
// Design Name: 
// Module Name: FIFO_tb
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


`timescale 1ns / 1ps

module FIFO_tb;

// Testbench signals
reg clk;
reg reset;
reg write_en;
reg read_en;
reg [7:0] data_in;
wire [7:0] data_out;
wire empty;
wire full;

// Instantiate the FIFO module
FIFO uut (
    .clk(clk),
    .reset(reset),
    .write_en(write_en),
    .read_en(read_en),
    .data_in(data_in),
    .data_out(data_out),
    .empty(empty),
    .full(full)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock period is 10ns
end

// Test process
initial begin
    // Initialize inputs
    reset = 1;
    write_en = 0;
    read_en = 0;
    data_in = 8'b0;
    
    // Apply reset
    #10 reset = 0; // Deassert reset after 10ns
    
    // Test case 1: Write to FIFO
    write_data(8'hA5); // Write 0xA5 to FIFO
    write_data(8'h3C); // Write 0x3C to FIFO
    write_data(8'h7E); // Write 0x7E to FIFO
    
    // Test case 2: Read from FIFO
    #10 read_en = 1; // Start reading
    #10 read_en = 0;
    
    #10 read_en = 1; // Continue reading
    #10 read_en = 0;
    
    #10 read_en = 1; // Continue reading
    #10 read_en = 0;
    
    // Test case 3: Fill FIFO to full
    #10 reset = 1; // Reset FIFO
    #10 reset = 0;
    
    repeat(5) write_data(8'hFF); // Fill FIFO with 0xFF
    write_data(8'hE0);
    write_data(8'hE1);
    write_data(8'hE2);
    write_data(8'hE3);
    write_data(8'hE4);
    write_data(8'hE5);
    write_data(8'hF0);
    write_data(8'hF1);
    write_data(8'hF2);
    write_data(8'hF3);
    write_data(8'hF4);
    write_data(8'hF5);
    write_data(8'hF6);
    write_data(8'hF7);
    write_data(8'hF8);
    write_data(8'hF9);
    #10; // Wait for a while
    
    // Test case 4: Check full and empty flags
    if (full)
        $display("FIFO is full as expected");
    else
        $display("FIFO is not full - ERROR");
    
    // Test case 5: Empty FIFO and check empty flag

    repeat(18) begin
        read_en = 1; // Read all data
        #10 read_en = 0;
    end    
    repeat(18) begin
        #10 read_en = 1; // Read all data
        #10 read_en = 0;
    end
    
    if (empty)
        $display("FIFO is empty as expected");
    else
        $display("FIFO is not empty - ERROR");
    
    // Finish simulation
    #100;
    $stop;
end

// Task to write data to FIFO
task write_data;
    input [7:0] data;
    begin
        #10;
        write_en = 1;
        data_in = data;
        #10;
        write_en = 0;
    end
endtask

task write_data_without_delay;
    input [7:0] data;
    begin
        #10;
        write_en = 1;
        data_in = data;
    end
endtask

endmodule

