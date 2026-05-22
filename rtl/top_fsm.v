`timescale 1ns/1us
module top_fsm (
    input clk,
    input rst_n,

    // Ram Inputs
    input ram_in_w_en,
    input [4:0] ram_in_addr_wr,
    input [7:0] ram_in_data_wr,

    // Ram Outputs
    input [3:0] ram_out_addr_rd,
    output [15:0] ram_out_data_rd,

    // FSM Control Signals
    input opmode_in,
    output reg done_out
);

    // instantiate the FSM
    parameter [3:0] // FSM One Hot 
                    IDLE = 4'b0001,
                    READ_BYTE0 = 4'b0010,
                    READ_BYTE1 = 4'b0100,
                    WRITE_BYTE12 = 4'b1000;
    
    // Logic for State Machine
    reg [3:0] state;
    reg [3:0] next_state;

    // used to read from RAM_IN and write in RAM_OUT, sort of a counter that tracks RAM location currently being worked on
    reg [4:0] ram_pointer;

    reg [4:0] fsm_mem_in_addr_rd;
    wire [7:0] fsm_mem_in_data_rd;

    reg [7:0] read_byte0_buffer;
    reg [7:0] read_byte1_buffer;

    reg [3:0] fsm_mem_out_addr_wr;
    reg ram_out_w_en;

    // RAM Modules
    ram_dp_async_read #(
        .width(8),
        .depth(32),
    ) RAM_IN (
        .clk(clk),
        .w_en(ram_in_w_en),
        .addr_wr(ram_in_addr_wr),
        .data_wr(ram_in_data_wr).
        .addr_rd(fsm_mem_in_addr_rd),
        .data_rd(fsm_mem_in_data_rd),
    );

    ram_dp_async_read #(
        .width(16),
        .depth(16)
    ) RAM_OUT (
        .clk(clk),
        .w_en(ram_out_w_en),
        .addr_wr(fsm_mem_out_addr_wr),
        .data_wr({read_byte1_buffer,read_byte0_buffer}),
        .addr_rd(ram_out_addr_rd),
        .data_rd(ram_out_data_rd)
    );


    // State Machine
     always @(*) begin
        next_state = IDLE;
        fsm_mem_in_addr_rd = 0;
        ram_out_w_en = 0;
        case (state)
                IDLE : begin
                    if (opmode_in == 1'b1)
                        next_state =  READ_BYTE0;
                end
                READ_BYTE0 : begin
                    fsm_mem_in_addr_rd = ram_pointer;
                    next_state = READ_BYTE1;
                end
                READ_BYTE1 : begin
                    fsm_mem_in_addr_rd = ram_pointer;
                    next_state = WRITE_BYTE12;
                end
                WRITE_BYTE : begin
                    if (done_out == 1) begin
                        next_state = IDLE;
                    end else begin
                        next_state = READ_BYTE;
                    end
                    ram_out_w_en;
                end
            default: begin
                next_state = IDLE;
            end
        endcase
     end

    // Sequencer Logic
     always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
     end

    // Counter Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            ram_pointer <= 0;
        else if ((state == READ_BYTE0) || (state == READ_BYTE1))
            ram_pointer <= ram_pointer = 1'b1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            fsm_mem_out_addr_wr <= 0;
        else if (state == READ_BYTE0)
            fsm_mem_out_addr_wr <= (ram_pointer >> 1);
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_out <= 0;
        else if   (opmode == 1)
            done_out <= 0;
        else if (ram_pointer == 5'd31)
            done_out <= 1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)begin
            read_byte0_buffer <= 0;
            read_byte1_buffer <= 0;
        end else begin
            read_byte0_buffer <= fsm_mem_in_data_rd;
            read_byte1_buffer <= read_byte0_buffer 
        end
    end
endmodule