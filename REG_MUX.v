module REG_MUX (D,OUT,CLK,RST,ENABLE	);

	parameter SIZE = 18 ;
	parameter RSTTYPE = "SYNC";
	parameter SEL = 1 ;

	input [ SIZE - 1 : 0 ]D;
	input CLK,RST,ENABLE; 

	output reg [SIZE-1:0]OUT;

	generate
		if(SEL == 1)begin
		if(RSTTYPE == "ASYNC") begin
			always @(posedge CLK or posedge RST) begin
				if (RST) begin
					OUT <= 0 ;					
				end
				else if(ENABLE) begin
					OUT <= D ;
				end
			end
		end
		else if(RSTTYPE == "SYNC") begin
			 always @(posedge CLK ) begin
			 	if (RST) begin
			 		OUT <= 0 ; 			 		
			 	end
			 	else if(ENABLE) begin
			 		OUT <= D ;
			 	end
			 end
		end
		end		
		else if(SEL == 0 )begin
		always @(*) begin
			OUT = D;
				
			end
		end
	endgenerate
endmodule : REG_MUX