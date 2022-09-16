`timescale 1ns / 1ps

module Histogram_tb();   
    
    parameter C_DATA_WIDTH = 8;
    parameter C_QUANTITY = 16;
    
    reg clk_i;
    reg rstn_i;
    reg valid_i;
    reg write_en_i;
    reg last_i;
    reg [C_DATA_WIDTH - 1 : 0] data_i;
    
    wire last_o;
    wire valid_o;
    wire [$clog2(C_QUANTITY) - 1 : 0] data_o;
    
    localparam DATA_RANGE = 15;
    localparam NUM_TEST_DATA = 256;
    
    reg _vld = 0;
    
    initial begin
        clk_i      = 0;
        rstn_i     = 0;
        valid_i    = 0;
        last_i     = 0;
    end
    
    initial begin
        # 2 
        forever # 5 clk_i = ~clk_i;
    end
    
    integer i, _outPixelCnt;
    initial begin
        # 20 rstn_i = ~rstn_i;
        for (i = 0; i < NUM_TEST_DATA; i = i + 1) begin
            @ (posedge clk_i) begin           
                _vld = $urandom_range(1, 0);
                valid_i <= _vld;
                if (_vld == 1) begin
                    data_i <= $urandom_range(DATA_RANGE); // 0 ~ DATA_RANGE
                    $display("The clk number: %d and data: %d.", i, data_i);
                    if (i < (NUM_TEST_DATA-1)) begin
                        last_i <= 0;
                    end
                    else if (i == (NUM_TEST_DATA-1)) begin
                        last_i <= 1;
                        valid_i <= 0;
                    end
                end
                else begin
                    last_i <= 0;
                end
            end
        end
    end
    
    Histogram Histogram_uut
    (
       .clk_i(clk_i),
       .rstn_i(rstn_i),
       .valid_i(valid_i),
       .write_en_i(),
       .last_i(last_i),
       .data_i(data_i),
       .last_o(last_o),
       .valid_o(valid_o),
       .data_o(data_o)       
    );
    
    // Histogram_tb.v Block and Non-block Test
    //    reg dff_sample;
    //    always @ (posedge clk_i) begin
    //        dff_sample <= valid_i;
    //    end
    
endmodule
