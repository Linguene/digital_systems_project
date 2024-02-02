module clock_divider(
	input 		 rst,
	input 		 clk,
	input 		 ena,
	input	 [2:0] div_sel,
	output reg	 div_clk
);
	localparam N = 27;
	reg  [N-1:0] cnt_reg;
	wire [N-1:0] cnt_next; 

	always@(posedge clk, posedge rst) begin
		if (rst) 
			cnt_reg <= 0;
		else if (ena)
			cnt_reg <= cnt_next;
	end

	assign cnt_next = cnt_reg + 1;
	
	reg div_clk_next;
	
	always@(posedge clk, posedge rst) begin
		if (rst) 
			div_clk <= 0;
		else if (ena)
			div_clk <= div_clk_next;
	end
						  
	always@(*)
		case(div_sel)
			3'd0 : div_clk_next = cnt_reg[ 0]; // div_clk = clk/2
			3'd1 : div_clk_next = cnt_reg[20]; // div_clk = clk/(2^21) 
			3'd2 : div_clk_next = cnt_reg[21]; // div_clk = clk/(2^22) 
			3'd3 : div_clk_next = cnt_reg[22]; // div_clk = clk/(2^23) 
			3'd4 : div_clk_next = cnt_reg[23]; // div_clk = clk/(2^24) 
			3'd5 : div_clk_next = cnt_reg[24]; // div_clk = clk/(2^25) 
			3'd6 : div_clk_next = cnt_reg[25]; // div_clk = clk/(2^26) 
			3'd7 : div_clk_next = cnt_reg[26]; // div_clk = clk/(2^27) 
		endcase

	endmodule

