module KrossKor();
   //input [15:0] dataA;
   //input [15:0] dataB;
	//input [15:0] wyslany;
   input wire clk;
  
   output reg [1:0] wyslanyA;
	output reg[1:0] wyslanyB;
   input  	   	  	 rst,
	input  			  	 clk,
	input  			  	 ena,
	input  			  	 start,
	output reg 		    rdy
 

);
	
	localparam SIZE = 3;
	localparam [SIZE-1:0] 
								 idle   = 3'h0,
								 init  = 3'h1,
								 check1 = 3'h2,
								 check2 = 3'h3,
								 done = 3'h4,
								 storeMax = 3'h5,
								 corr = 3'h6;
			
								 
	
	reg [SIZE-1:0] state_reg, state_next;
	reg 				rdy_next;
	
	reg  	  [15:0] A_reg,A_next;
	reg     [15:0] B_reg,B_next;
	reg     [15:0] wyslany_reg,wyslany_next;
	
	reg     [15:0] i_reg,i_next;
	reg     [15:0] y_reg,y_next;
	reg     [15:0] max_reg,max_next;
	
	
	// State register
	always@(posedge clk, posedge rst) begin
		if (rst) begin
			state_reg <= init;
			rdy		 <= 1'b0;
		end
		else if (ena) begin
			state_reg <= state_next;
			rdy		 <= rdy_next;
		end
	end

// Registers
	always@(posedge clk, posedge rst) begin
		if (rst) begin
			A_reg <= {(16){1'b0}};
			B_reg <= {(16){1'b0}};
			i_reg <= {(16){1'b0}};
			y_reg <= {(16){1'b0}};
			
			
		end
		else if (ena) begin
			A_reg	<= A_next;
			B_reg <= B_next;
			i_reg <= i_next;
			y_reg <= y_next;
		end		
	end
		
	
	// Next state logic
	always@(*) 
		case(state_reg)
		    idle     : if (start) state_next = init;
			            else state_next = idle; 
 			 init 	 : state_next = check1;
			 check1   : if (i_reg == 5000)
								state_next = done;
			            else begin
							    if (y==20) 
								 state_next = check2;
								 else
								 state_next = corr;							  
			 check2   : if (i_reg==0) 
								state_next = storeMax;
							else begin
							   if (corr_reg>max_reg) 
								   state_next = storeMax;
								else
								   state_next = dodajI;
								  end 
			    
			 storeReady : state_next = init;
			 storeMax : state_next = check1;
			 corr : state_next = check1;
	       dodajI   : state_next = check1;
			
			default: state_next = init;				
		endcase	

// Microoperation logic
     always @ (posedge clk) begin
	  
	  case(state_reg)
	      init : begin 
			       A_next = dataA;
			       wyslany_next = wyslany;
					 S_next = dataS;
					 X_next = dataX;
					 
					 corr_next = 0;
					 i_next = 0;
					 y_next = 0;
					 end
			done : rdy_next = 1'b1;
			storeMax : begin
			           if (corr_reg> max_next) begin 
			                 max_next <= corr_reg;
							  end
			           end
			corr : begin
			             corr_next = corr_reg +X_next[n-m]*S_next[m];
			             y_next=y_reg+1;
						  end	 	 
			dodajI   : begin
			             i_next = i_reg + 1;
						  end
	    
	  
	  end
end	
    
endmodule


 
  