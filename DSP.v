module DSP (
	A,B,C,D,CARRYIN,CARRYOUT,CARRYOUTF,OPMODE,
	CLK,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,
	RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,
	BCOUT,PCOUT,P,M
	
			);
	//----------------PARAMETERS SECTION -------------
	parameter A0REG 	   = 0 ;
	parameter A1REG 	   = 1 ;
	parameter B0REG 	   = 0 ;
	parameter B1REG 	   = 1 ;
	parameter CREG  	   = 1 ;
	parameter DREG  	   = 1 ;
	parameter MREG  	   = 1 ;
	parameter PREG  	   = 1 ;
	parameter CARRYINREG   = 1 ;
	parameter CARRYOUTREG  = 1 ;
	parameter OPMODEREG    = 1 ;
	parameter CARRYINSEL   = "OPMODE5";
	parameter B_INPUT      = "DIRECT";
	parameter RSTTYPE      = "SYNC";
	//---------------INPUTS SECTION -------------
	input [17:0]A,B,D,BCIN;
	input [47:0]C,PCIN;
	input [7:0]OPMODE;
	input CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,
		  RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
	//---------------OUTPUTS SECTION -------------	  
	output [17:0]BCOUT;
	output [47:0]PCOUT,P;
	output [35:0]M;
	output CARRYOUT , CARRYOUTF ;
	//---------------WIRE SECTION -------------
	wire M2,CINDFF,COUTDFF;
	wire [7:0]opmode;
	wire [17:0]DFF,BDFF,B0DFF,ADD1,M1,B1DFF,A0DFF,A1DFF;
	wire [35:0]MUL,MULDFF;
	wire [47:0]CON,MUX_1,MUX_2,CFF,ADD2,z;
	//---------------REG WITH MUX SECTION -------------
	REG_MUX #(8,RSTTYPE,OPMODEREG)OPMODE_OUT(OPMODE,opmode,CLK,RSTOPMODE,CEOPMODE);
	REG_MUX #(18,RSTTYPE,DREG)D_REG(D,DFF,CLK,RSTD,CED);//D,OUT,CLK,RST,ENABLE
	REG_MUX #(18,RSTTYPE,B0REG)B_REG0(BDFF,B0DFF,CLK,RSTB,CEB);
	REG_MUX #(18,RSTTYPE,B1REG)B_REG1(M1,B1DFF,CLK,RSTB,CEB);
	REG_MUX #(18,RSTTYPE,A0REG)A_REG0(A,A0DFF,CLK,RSTA,CEA);
	REG_MUX #(18,RSTTYPE,A1REG)A_REG1(A0DFF,A1DFF,CLK,RSTA,CEA);
	REG_MUX #(48,RSTTYPE,CREG)C_REG(C,CFF,CLK,RSTC,CEC);
	REG_MUX #(36,RSTTYPE,MREG)OUT_MULTIPLY(MUL,MULDFF,CLK,RSTM,CEM);
	REG_MUX #(1,RSTTYPE,CARRYINREG)CYI(M2,CINDFF,CLK,RSTCARRYIN,CECARRYIN);
	REG_MUX #(1,RSTTYPE,CARRYOUTREG)CYO(COUTDFF,CARRYOUT,CLK,RSTCARRYIN,CECARRYIN);
	REG_MUX #(48,RSTTYPE,PREG)P_REG(ADD2,P,CLK,RSTP,CEP);
	//---------------ASSIGN SECTION -------------	
	assign BDFF = ( B_INPUT == "DIRECT" ) ? B : BCIN ;
	assign ADD1 = (opmode[6] == 1) ?	DFF - B0DFF : DFF + B0DFF ;
	assign M1 = (opmode[4] == 1) ? B0DFF : ADD1 ;
	assign MUL = B1DFF * A1DFF ;
	assign BCOUT = B1DFF ;
	assign CON = {DFF[11:0],A1DFF,B1DFF};
	assign M = MULDFF ;
	assign M2 = (CARRYINSEL == "OPMODE5" ) ? opmode[5] : CARRYIN  ;
	assign {COUTDFF,ADD2} = (opmode[7] == 0 ) ? MUX_1 + MUX_2 + CINDFF : MUX_1 - MUX_2 - CINDFF ;
	assign z = {12'b0000_0000_0000,MULDFF} ;
	assign CARRYOUTF = CARRYOUT ;
	assign PCOUT = P ;
	//--------------- MUX SECTION -------------
	mux4 #(48)MUX1(CON,P,z,48'b0,opmode[1:0],MUX_1);
	mux4 #(48)MUX2(CFF,P,PCIN,48'b0,opmode[3:2],MUX_2);
endmodule : DSP
