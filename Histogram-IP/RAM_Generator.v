`timescale 1ns / 1ps

module RAM_Generator
	#(
		parameter C_DATA_WIDTH   = 8,
		parameter C_DEPTH        = 16,
		parameter C_CE_IN        = 0
	)
	(
		input  clk_i,
        input  rstn_i,
		input  clk_en_i,
		input  write_en_i,
		
		input  [$clog2(C_DEPTH) - 1 : 0] write_address_i,
		input  [C_DATA_WIDTH - 1 : 0]    write_data_i,

		input  [$clog2(C_DEPTH) - 1 : 0] read_address_i,
		output [C_DATA_WIDTH - 1 : 0]    read_data_o

	);

	reg [C_DATA_WIDTH - 1 : 0] read_data_r;
	reg [C_DATA_WIDTH - 1 : 0] buffer [C_DEPTH - 1 : 0];

	wire clk_en = C_CE_IN ? clk_en_i : 1;

	assign read_data_o = read_data_r;
	
    integer i;
    initial begin
        for (i = 0; i < C_DEPTH; i = i + 1) begin
            buffer[i] <= 0; 
        end
        read_data_r <= 0;
    end
    
    always @ (posedge clk_i) begin
        if (clk_en) begin
            if (write_en_i) begin
                buffer[write_address_i] <= write_data_i;
            end
            read_data_r <= buffer[read_address_i];
        end
    end

endmodule