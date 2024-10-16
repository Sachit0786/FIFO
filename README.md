# FIFO Module
## Overview
This project contains a Verilog-based implementation of a Synchronous FIFO (First-In, First-Out) memory. A FIFO operates in a first-in, first-out manner, meaning the data written into the memory first will be read out first. This particular FIFO design is synchronous, meaning both the write and read operations are synchronized to a single clock signal (clk), making it suitable for designs where the read and write operations are driven by the same clock domain.<br>

### Features:
1) Data Width: 8-bit wide data bus (parameterized).<br>
2) Depth: Default FIFO depth is 16 (parameterizable).<br>
3) Status Signals: <br>
  1) empty: Indicates whether the FIFO is empty (i.e., no data available to read). <br>
  2) full: Indicates whether the FIFO is full (i.e., no more space available to write). <br>
4) Reset Signal: The FIFO can be reset asynchronously, setting the read and write pointers to zero and marking the FIFO as empty.<br>
5) Parameterizable Pointers: FIFO uses parameterized write (wr_ptr) and read (rd_ptr) pointers for flexibility in different depth configurations.<br>
6) Write/Read Enable: Independent write_en and read_en signals control whether the module writes or reads from the memory.<br>

### Synchronous FIFO:
This design is a synchronous FIFO, meaning that both read and write operations occur on the rising edge of the clock (clk). The read and write pointers (wr_ptr and rd_ptr) update in sync with the clock, ensuring that data movement through the FIFO is predictable and consistent.

## Signals

### Input Signals: <br>
1) clk: The system clock, driving both read and write operations synchronously.<br>
2) reset: Asynchronous reset signal, used to reset the FIFO to an initial state.<br>
3) write_en: Enables writing of data into the FIFO when asserted.<br>
4) read_en: Enables reading of data from the FIFO when asserted.<br>
5) data_in [7:0]: 8-bit input data to be written into the FIFO.<br>

### Output Signals:
1) data_out [7:0]: 8-bit output data from the FIFO. It outputs the next available data only if the FIFO is not empty.<br>
2) empty: A status signal indicating when the FIFO is empty.<br>
3) full: A status signal indicating when the FIFO is full.<br>


## Internal Logic

### Write Operation:
Data is written into the FIFO at the location pointed to by wr_ptr (write pointer).<br>
After each write operation, wr_ptr is incremented by 1.<br>
The FIFO becomes full when the wr_ptr advances to the position directly before the rd_ptr (read pointer).<br>

### Read Operation:
Data is read from the FIFO at the location pointed to by rd_ptr.<br>
After each read operation, rd_ptr is incremented by 1.<br>
The FIFO becomes empty when the rd_ptr catches up to the wr_ptr.<br>

### Empty and Full Status:
The empty signal is asserted when wr_ptr and rd_ptr are equal, indicating no data is available for reading.<br>
The full signal is asserted when the write pointer is one position behind the read pointer, meaning the FIFO has no available space for writing new data.<br>

### Parameterization:
The FIFO is designed to be configurable with the following parameters:<br>
1) DEPTH: Defines the depth (number of entries) in the FIFO memory. The default value is 16.<br>
2) DATA_WIDTH: Defines the width of each data word. The default value is 8 bits.<br>
3) PTR_SIZE: Defines the size of the write and read pointers, which is determined by the depth of the FIFO.<br>
