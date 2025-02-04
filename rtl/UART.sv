module UART #(                 // Bit rate is 1 Mega Bits per second (1 Mbps)
	parameter D_WIDTH      = 8 ,
	parameter PARITY_O_1   = 0 , // 0 for even 1 for odd
	parameter CLK_FREQ_MHZ = 50  // Clock Frequency in Mega Hz 
) (
	input  logic               clk       ,
	input  logic               arst_n    ,   // a synchoronous reset active low 
	input  logic               start     ,   // input for trasmit the data as a master 
	input  logic [D_WIDTH-1:0] data_in   ,   // data for transmission
	input  logic               Rx        ,
	output logic [D_WIDTH-1:0] data_out  ,
	output logic               error_flag,
	output logic               Tx
);

logic [2:0] next_state     ;
logic [2:0] current_state  ;
logic [9:0] count          ;
logic [4:0] counter        ;
logic       parity_check_R ;
logic       parity_check_T ;
logic       even_odd_R     ;
logic       clk_gen        ;
logic       start_d        ;
logic       Rx_d           ;

logic [D_WIDTH-1:0] data_buff;

localparam
	IDLE     = 3'b000,
	RECIEVE  = 3'b001,
	TRANSMIT = 3'b010,
	PARITY   = 3'b011,
  STOP_T   = 3'b100,  
  STOP_R   = 3'b101;

/*------------------------------------------------------------------------------
-------------------- CLOCK GENERATION OF 1MZ -----------------------------------  
------------------------------------------------------------------------------*/

always_ff @(posedge clk or negedge arst_n) begin
	if(~arst_n) 
		count <= 1;
	else if(clk_gen)
	  count <= 1;
	else 
		count <= count + 1;
end
assign clk_gen = (count == CLK_FREQ_MHZ);

/*------------------------------------------------------------------------------
-------------------- COUNTER FOR NUMBER OF DATA BITS ---------------------------  
------------------------------------------------------------------------------*/

always_ff @(posedge clk or negedge arst_n) begin 
	if(~arst_n)
		counter <= 0;
	else if (current_state == IDLE)
	  counter <= 0;
  else if (clk_gen)
		counter <= counter + 1;
end

always_ff @(posedge clk or negedge arst_n) begin
	if(~arst_n)
		data_buff <= 0;
	else if (clk_gen) begin		
	  if (start)
	  	data_buff <= data_in;
	  else if (current_state == TRANSMIT)
	  	data_buff <= {1'b0, data_buff[D_WIDTH-1:1]};
	  else if (current_state == RECIEVE)
	  	data_buff <= {Rx,data_buff[D_WIDTH-1:1]};
	  else if (current_state == PARITY)
	  	data_buff <= {Rx,data_buff[D_WIDTH-1:1]};
	  else
	  	data_buff <= data_buff;
	end
end

/*------------------------------------------------------------------------------
-------------------- COMBINATION BLOCK FOR NEXT STATE --------------------------  
------------------------------------------------------------------------------*/

always_comb begin 
	case (current_state)
		IDLE     : if(start)                next_state <= TRANSMIT;
		           else if (~Rx)            next_state <= RECIEVE ;
		           else                     next_state <= IDLE    ;
		RECIEVE  : if(counter == D_WIDTH-1) next_state <= PARITY  ;
		           else                     next_state <= RECIEVE ;
		TRANSMIT : if(counter == D_WIDTH)   next_state <= STOP_T  ;
		           else                     next_state <= TRANSMIT;
		PARITY   :                          next_state <= STOP_R  ;
		STOP_R   :                          next_state <= IDLE    ;
		STOP_T   :                          next_state <= IDLE    ;
		default  :                          next_state <= IDLE    ;
	endcase
end

/*------------------------------------------------------------------------------
-------------------- Flip Flop For Next State ----------------------------------  
------------------------------------------------------------------------------*/

always_ff @(posedge clk or negedge arst_n) begin 
	if(~arst_n) 
		current_state <= 0;
	else if (clk_gen)
		current_state <= next_state;
end

/*------------------------------------------------------------------------------
-------------------- COMBINATION BLOCK FOR OUTPUT ------------------------------  
------------------------------------------------------------------------------*/

always@(*) begin
	if (clk_gen) begin
		case (current_state)
			IDLE    : begin 
				          if(start)
				            Tx       <= 0;
				          else
				          	Tx       <= 1;
				          data_out   <= data_out;
				          error_flag <= 0;
				        end
			RECIEVE : begin
				          Tx         <= 1;
				          error_flag <= 0;
				          data_out   <= data_out;
				        end
			TRANSMIT: begin
				          if(counter == D_WIDTH)
				          	Tx <= parity_check_T;
				          else
				            Tx <= data_buff[0];
				          data_out   <= data_out;
				          error_flag <= 0;
				        end
			PARITY  : begin
				          Tx         <= 1;
				          if(Rx != parity_check_R) begin
				          	error_flag <= 1  ;
				            data_out   <= data_out;
				          end
				          else begin	
				            data_out   <= data_buff;
				            error_flag <= 0;
				          end 
				        end
			STOP_T  : Tx  <= 1;
			STOP_R  : if(Rx == 0) error_flag <= 1;
			          else        error_flag <= 0;
			default : begin
			  	        Tx         <= 1;
			  	        data_out   <= 0;
			  	        error_flag <= 0;
			  	      end
		endcase
	end
	else if(~arst_n) begin
		error_flag <= 0;
		data_out   <= 0;
		Tx         <= 1;
	end
	else begin
		error_flag <= error_flag;
		data_out   <= data_out  ;
		Tx         <= Tx        ;
	end
end

assign even_odd_R = ^data_buff;
assign even_odd_T = ^data_in  ;
assign parity_check_R = (PARITY_O_1)? ~even_odd_R : even_odd_R;  
assign parity_check_T = (PARITY_O_1)? ~even_odd_T : even_odd_T;  
  
endmodule 