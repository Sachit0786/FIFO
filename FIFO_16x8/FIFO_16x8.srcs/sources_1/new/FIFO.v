`timescale 1ns / 1ps
module FIFO (
    input wire clk,
    input wire reset,
    input wire write_en,
    input wire read_en,
    input wire [7:0] data_in,
    output wire [7:0] data_out,
    output wire empty,
    output wire full
);

    parameter DEPTH = 16;      // Depth of the FIFO
    parameter DATA_WIDTH = 8;  // Width of the data bus
    parameter PTR_SIZE = 5;    // Pointer size based on depth

    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];  // FIFO memory array
    reg [PTR_SIZE-1:0] wr_ptr;  // Write pointer
    reg [PTR_SIZE-1:0] rd_ptr;  // Read pointer
    reg empty_reg, full_reg;    // Status registers

    // Write process
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wr_ptr <= 0;
        end else if (write_en && !full_reg) begin
            memory[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;  // Increment write pointer
        end
    end

    // Read process
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rd_ptr <= 0;
        end else if (read_en && !empty_reg) begin
            rd_ptr <= rd_ptr + 1;  // Increment read pointer
        end
    end

    // Status logic for empty
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            empty_reg <= 1;  // FIFO is empty after reset
        end else if (write_en && !full_reg && (wr_ptr == rd_ptr)) begin
            empty_reg <= 0;  // Data is written, FIFO is not empty
        end else if (read_en && (wr_ptr == rd_ptr + 1)) begin
            empty_reg <= 1;  // After reading, FIFO becomes empty
        end else if (wr_ptr == rd_ptr) begin
            empty_reg <= 1;  // Write and read pointers equal, FIFO is empty
        end else begin
            empty_reg <= 0;  // Otherwise, FIFO is not empty
        end
    end

    // Status logic for full
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            full_reg <= 0;  // FIFO is not full after reset
        end else if (write_en && ((wr_ptr + 1) % DEPTH == rd_ptr)) begin
            full_reg <= 1;  // FIFO is full when write pointer wraps around
        end else if (read_en) begin
            full_reg <= 0;  // If reading, FIFO can't be full
        end
    end

    // Data retrieval
    assign data_out = (!empty_reg) ? memory[rd_ptr] : 8'hx;  // Output data only if not empty

    // Status outputs
    assign empty = empty_reg;
    assign full = full_reg;

endmodule
