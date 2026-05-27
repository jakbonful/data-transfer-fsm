# Data Transfer FSM Design Documentation

## 1. Overview
This project implements a finite state machine (FSM) in Verilog that transfers data from an input RAM to an output RAM. The system reads 8-bit values, combines them into 16-bit words, and stores them in a second memory block. Key features include dual-port RAM, one-hot FSM, byte packing, and a verification testbench.

## 2. System Architecture
The design consists of: ram_dp_async_read (RAM module), top_fsm (control FSM), tb_top_fsm (testbench).

## 3. RAM Module (ram_dp_async_read)
A parameterized dual-port RAM with synchronous write and asynchronous read. Write occurs on rising edge when we=1. Read is continuous using assign data_rd = ram[addr_rd].

## 4. Top FSM Module (top_fsm)
Controls transfer of data from input RAM to output RAM by reading two 8-bit values and combining them into one 16-bit word.

## 5. FSM States
One-hot encoding used: IDLE=0001, READ_BYTE0=0010, READ_BYTE1=0100, WRITE_BYTE12=1000.

## 6. FSM Flow
IDLE → READ_BYTE0 → READ_BYTE1 → WRITE_BYTE12 → repeat until done.

## 7. Data Packing
Two 8-bit values are combined using {read_byte1_buffer, read_byte0_buffer} to form a 16-bit word.

## 8. Memory Access Strategy
Input RAM stores bytes, output RAM stores 16-bit words. Output address increments as ram_pointer >> 1.

## 9. Control Signals
ram_pointer tracks read position, ram_out_we enables output write, done_out signals completion, opmode_in starts transfer.

## 10. Completion Condition
Transfer completes when ram_pointer == 31, then done_out = 1 and FSM returns to IDLE.

## 11. Testbench (tb_top_fsm)
Verifies functionality by writing patterns to input RAM, triggering FSM, waiting for done, and checking output correctness.

## 12. Test Procedure
Reset system → write input data → trigger opmode → wait done → read output → compare results.

## 13. Test Pattern
Pattern used: ((i % 2) << 7) + i for input data generation.

## 14. Verification
Uses tasks write_data, read_data, compare_data. Tracks test_count, success_count, error_count.

## 15. Simulation Flow (ModelSim)
vlib work; vlog ram_dp_async_read.v; vlog top_fsm.v; vlog tb_top_fsm.v; vsim work.tb_top_fsm; add wave *; run -all.

## 16. Expected Output
Correct 16-bit packed values, done_out asserted, zero errors in testbench.

## 17. Conclusion
This design demonstrates FSM control, RAM interfacing, byte packing, and verification using a structured Verilog testbench.

