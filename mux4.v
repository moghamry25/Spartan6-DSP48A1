module mux4 (
	A,B,C,D,S,OUT
	
);
	parameter size = 1 ;
	input [size - 1 : 0 ]A,B,C,D;
	input [ 1 : 0]S;
	output reg [ size - 1 : 0 ]OUT;
	always @(*) begin
	 	case(S)

	 	2'b00: OUT = A ;
	 	2'b01: OUT = B ;
	 	2'b10: OUT = C ;
	 	2'b11: OUT = D ;

	 	endcase
	 end 
endmodule : mux4