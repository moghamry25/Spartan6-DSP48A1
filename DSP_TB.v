module DSP_TB ();

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
	parameter RSTTYPE      = "ASYNC";

	reg [17:0]A,B,D,BCIN;
	reg [47:0]C,PCIN;
	reg [7:0]OPMODE;
	reg CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,
		  RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;

	wire [17:0]BCOUT;
	wire [47:0]PCOUT,P;
	wire [35:0]M;
	wire CARRYOUT , CARRYOUTF ;

	DSP #(A0REG,A1REG,B0REG,B1REG,CREG,DREG,MREG,PREG,CARRYINREG,
		CARRYOUTREG,OPMODEREG,CARRYINSEL,B_INPUT,RSTTYPE
		)DUT(A,B,C,D,CARRYIN,CARRYOUT,CARRYOUTF,OPMODE,
	    CLK,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,
	    RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,
	    BCOUT,PCOUT,P,M);

	initial begin
	CLK=0;

	forever
	#1 CLK=~CLK;
	end

	initial begin

		A=0;B=0;D=0;BCIN=0;C=0;PCIN=0;OPMODE=0;
		CARRYIN=0;RSTA=0;RSTB=0;RSTM=0;RSTP=0;RSTC=0;
		RSTD=0;RSTCARRYIN=0;RSTOPMODE=0;CEA=1;CEB=1;
		CEM=1;CEP=1;CEC=1;CED=1;CECARRYIN=1;CEOPMODE=1;
		
        @(negedge CLK);

        // Test case 1: P = a
        A = 2; B = 3; D = 6; C = 4; PCIN = 2; BCIN = 1; OPMODE = 8'b00010010;
        @(negedge CLK); @(negedge CLK); @(negedge CLK);@(negedge CLK);

        // Test case 2: P = 4 
        A = 2; B = 2; D = 2; C = 2; PCIN = 2; BCIN = 0; OPMODE = 8'b10010010;
        @(negedge CLK); @(negedge CLK); 

        // Test case 3: P = 2
        A = 2; B = 4; D = 2; C = 2; PCIN = 2; BCIN = 0; OPMODE = 8'b10011010;
        @(negedge CLK); @(negedge CLK); @(negedge CLK);@(negedge CLK);

        // Test case 4: P = 6
        A = 2; B = 4; D = 3; C = 2; PCIN = 2; BCIN = 0; OPMODE = 8'b10011010;
        @(negedge CLK); @(negedge CLK);

        // Test case 5: 
        A = 2; B = 4; D = 2; C = 2; PCIN = 2; BCIN = 0; OPMODE = 8'b00001010;

        @(negedge CLK); @(negedge CLK); @(negedge CLK);@(negedge CLK);

        // Test case 6: 
        A = 2; B = 24; D = 2; C = 2; PCIN = 12; BCIN = 12; OPMODE = 8'b11010010;
        @(negedge CLK);@(negedge CLK);

        // Test case 7:  
        A = 2; B = 4; D = 9; C = 5; PCIN = 2; BCIN = 1; OPMODE = 8'b10010010;
        @(negedge CLK);@(negedge CLK); @(negedge CLK);@(negedge CLK);

        // Test case 8: 
        A = 2; B = 4; D = 2; C = 10; PCIN = 5; BCIN = 0; OPMODE = 8'b01010010;

        @(negedge CLK); @(negedge CLK); @(negedge CLK);@(negedge CLK);

        // Test case 9:
        A = 2; B = 4; D = 5; C = 2; PCIN = 8; BCIN = 0; OPMODE = 8'b10010010;
        @(negedge CLK);@(negedge CLK); @(negedge CLK); @(negedge CLK);

        // Test case 10: 
        A = 2; B = 3; D = 6; C = 4; PCIN = 2; BCIN = 8; OPMODE = 8'b00111101;
        @(negedge CLK);@(negedge CLK); @(negedge CLK); @(negedge CLK);
        A = 2; B = 3; D = 6; C = 4; PCIN = 2; BCIN = 8; OPMODE = 8'b00111101;

		$stop;
	end
endmodule : DSP_TB