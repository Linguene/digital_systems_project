module gcd_asmd
(
   input  	   	  	 rst,
	input  			  	 clk,
	input  			  	 ena,
	input  			  	 start,
	output reg 		    rdy
);
   
	
	localparam SIZE = 5;
	localparam [SIZE-1:0] 
								 idle   = 5'h0,
								 init  =5'h1,
								 check1 = 5'h2,
								 check2 = 5'h3,
								 done = 5'h4,
								 storeMax = 5'h5,
								 corr = 5'h6,
								 corr_init = 5'h7,
								 increment  =5'h8,
								 nullSuma = 5'h9,
								 check12  = 5'h10;
			
			
								 
	
	reg signed [SIZE-1:0] state_reg, state_next;
	reg signed 				rdy_next;	
	reg signed [21:0]     result_next,result;
				
	reg signed [7:0] pointAm [4999:0]; 
 	reg signed [7:0] sentm [19:0];
	
	integer i;
	integer y;
	reg signed    [7:0] pointA_reg,pointA_next;
	reg signed    [7:0] sent_reg,sent_next;	
	reg signed  [20:0] max_reg,max_next;
	reg signed  [20:0] suma_reg,suma_next;

	initial begin
	$readmemb("C:/Users/eryko/Desktop/SYCYF/SYCYF_PROJEKT/ETAP5/ProjektEtap5/rA_bin.txt", pointAm);
	//$readmemb("C:/Users/eryko/Desktop/SYCYF/SYCYF_PROJEKT/ETAP5/ProjektEtap5/rB_bin.txt", pointAm);
	$readmemb("C:/Users/eryko/Desktop/SYCYF/SYCYF_PROJEKT/ETAP5/ProjektEtap5/sent8_bin.txt", sentm);
	end
	
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
			max_reg <= {(21){1'b0}};
			suma_reg <= {(21){1'b0}};
			
			pointA_reg <= pointAm[0];
			sent_reg <= sentm[0];
			result <= {(22){1'b0}};
		
		end
		else if (ena) begin
			max_reg <= max_next;
			suma_reg <= suma_next;
			result <= result_next;
			
			pointA_reg <= pointA_next;
			sent_reg <= sent_next;
		end		
	end

	
	// Next state logic
	always@(*) 
		case(state_reg)
		// idle – Blok czekający na sygnał, który rozpocznie działanie algorytmu 
		    idle     : if (start) begin
			                 state_next = init;
								end
			            else begin
							state_next = idle;
							end
		// init – Blok inicjujący dane do realizacji programu 					
 			 init 	 : state_next = check1;
		// check1 – Blok sprawdzający czy ilość próbek sygnału wysyłanego nie została przekroczona 
			 check1   : if (i == 4980) begin
								state_next = done;
								end
			            else begin
							   state_next = check12;
							   end							
      
      // check12 - sprawdzamy czy iterowana zmienna y=20, jesli nie to idziemy do stanu corr, jesli tak to do stanu increment
          check12  : if (y<20) begin
								 state_next = corr_init;
								 end
						   else begin
								 state_next= increment;
								 end
							
	   // increment : zerujemy y, zwiększamy o 1 w górę zmienną i
		    increment : state_next = check2;
		
		// check2- Blok sprawdzający dla których próbek wystepuje max wielkość korelacji 
         		
			check2	  : if (suma_reg>max_reg)  begin
								   state_next = storeMax;
									end
							else begin
								   state_next = check1;
									end
							   
		// done- ustawia wartość ready na 1 			    
			 done : state_next = idle;
		// storeMax- przechowuje aktualna maksymalną wartość korelacji,jeśli nowa wartość jest większa od aktualnej to ją zamienia
			 storeMax : state_next = nullSuma;
		// nullSuma - zerujemy sumę - nadajemy wartość domyślną sumy czyli suma=0
		    nullSuma : state_next = check1;	 
	   // corr_init - nadaje zmiennym pointA_next,pointB_next,sent_next wartości z odpowiednich indeksów poszczególnych plików wejściowych
			 corr_init : state_next = corr;
	   // corr- Blok zajmujący się  liczeniem wartość korelacji dla kolejnych próbek
			 corr : state_next = check1;
			
			default: state_next = idle;				
		endcase	

// Microoperation logic
     always @ (*) begin  
	  
	  pointA_next = pointA_reg;
	  sent_next = sent_reg;
	  
	  max_next = max_reg;
	  suma_next = suma_reg;
	  result_next = result;
	  rdy_next	= 1'b0;
	 
	  case(state_reg)
	  
	      init : begin
			       // zmiennym pointA_next i sent_next przypisujemy pierwsze wartości z odpowiednich plików tekstowych
                pointA_next=pointAm[0];
			       sent_next = sentm[0];		 
					 //zmienna i, która iteruje po pointA/pointB(5000 próbek)
					 i = 0;
					 //zmienna y, która iteruje po sent(20 próbek)
					 y = 0;
					 //Domyślna wartość maksymalna
					 max_next = 0;
					 //Początkowa wartość sumy:
					 suma_next = 0;
					 //Wartość na wyjściu:
					 result_next = 0;
					 end
			done : begin
			       rdy_next = 1'b1;
					 result_next=max_reg;	
			       end
			nullSuma : begin
						    suma_next = 0;
			           end		 
			increment : begin
			             y=0;
							 i=i+1;
                    end 			
			storeMax : begin 
								max_next = suma_reg;  
			           end
			corr_init : begin
			              pointA_next = pointAm[i+ y];
							  sent_next = sentm[y];
			            end
			corr : begin
							 suma_next = suma_reg +pointA_reg*sent_reg;
			             y=y+1;
						  end	 	 
	       //default	: 	;//state_reg = idle;	
	   endcase
   end	   
endmodule




 
  