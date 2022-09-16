`timescale 1ns / 1ps

module Histogram
    #(
        parameter C_DATA_WIDTH = 8,
        parameter C_QUANTITY = 16
    )
    (
        input clk_i,
        input rstn_i, 
        input valid_i,
        input write_en_i,
        input last_i,
        input [C_DATA_WIDTH - 1 : 0] data_i,
       
        output last_o,
        output valid_o,
        output [$clog2(C_QUANTITY) - 1 : 0] data_o
    );
    
    // Parameter declaration
    reg  valid_i_r;                                      
    reg  [C_DATA_WIDTH - 1 : 0] data_i_r;
    reg  valid_o;                     
    reg  [$clog2(C_QUANTITY) - 1 : 0] data_o;              

    wire [$clog2(C_QUANTITY) - 1 : 0] write_address;        // statistics pixel as write address
    wire [$clog2(C_QUANTITY) - 1 : 0] read_address;          
    
    wire inc_rst;                                           // increment_reset
    wire inc_en;                                            // increment_enable
    
    reg  [(2**C_DATA_WIDTH) - 1 : 0] out_pixel_count;
    reg  [(2**C_DATA_WIDTH) - 1 : 0] _out_pixel_count;                                // 1: statistics, 0: output
    wire [C_DATA_WIDTH - 1 : 0] inc_data;             // data = count + count_feedback
    wire [$clog2(C_QUANTITY) - 1 : 0] inc_count_fb;         // increment_count_feedback
    reg  [$clog2(C_QUANTITY) - 1 : 0] inc_count;            // increment_count
    
    // Delay data_i by clock cycle
    always @ (posedge clk_i) begin
        if (!rstn_i) begin
            valid_i_r  <= 1'b0;
            data_i_r   <= {C_DATA_WIDTH{1'b0}};
        end
        else begin
            valid_i_r  <= valid_i;
            data_i_r   <= data_i;
        end
    end   

    // Statistics increment counter
    always @ (posedge clk_i) begin
        if (inc_rst)
            inc_count <= {{$clog2(C_QUANTITY){1'b0}}, 1'b1};
        else if (inc_en)
            inc_count <= inc_count + {{$clog2(C_QUANTITY)-1{1'b0}}, 1'b1};
        else
            inc_count <= inc_count;
    end
    
    reg statistics_flag;
    // Switch statistics and output flag
    always @ (posedge clk_i) begin
        if (!rstn_i) begin
            statistics_flag <= 1'b1;
        end
        else begin
            if (last_i & valid_i_r) begin
                statistics_flag <= 1'b0;
            end
            else begin
                statistics_flag <= statistics_flag;
            end
        end
    end
    
    // Output data_o
    always @ (posedge clk_i) begin
        if (statistics_flag) begin
            out_pixel_count <= 1'b0;
        end
        else begin
            if (out_pixel_count < (2**C_DATA_WIDTH - 1)) begin
                data_o <= inc_count_fb; // here have problem
                out_pixel_count <= out_pixel_count + 1'b1;
            end
            else if (out_pixel_count == ((2**C_DATA_WIDTH) - 1)) begin
                statistics_flag = 1'b1;
            end
        end
    end   

    assign inc_rst = ((data_i_r != data_i) | ((valid_i == 1'b1) & (valid_i_r == 1'b0))) ? 1'b1 :1'b0;
    assign inc_en = ((data_i_r == data_i) & (valid_i == 1'b1) & (valid_i_r == 1'b1)) ? 1'b1 : 1'b0;
    assign inc_data = (statistics_flag == 1'b1) ? inc_count + inc_count_fb : {C_DATA_WIDTH{1'b0}};
    assign write_en_i = (((data_i_r != data_i) & (valid_i == 1'b1)) | ((valid_i  == 1'b1) & (valid_i_r == 1'b0)));
    assign read_address = (statistics_flag == 1'b1) ? data_i : out_pixel_count;
    assign write_address = data_i_r;

    RAM_Generator RAM0
    (
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        .write_en_i(write_en_i),
        .write_address_i(write_address),
        .read_address_i(read_address),
        .write_data_i(inc_data),
        .read_data_o(inc_count_fb)
    );
    

    
endmodule