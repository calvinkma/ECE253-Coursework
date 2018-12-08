module mc_adder(SW, HEX0, HEX1, HEX3, HEX5);
	input [8:0]SW;
	output [0:6]HEX0, HEX1, HEX3, HEX5;
	wire Cout;
	wire[3:0] O;
	adder A(SW[3:0], SW[7:4], SW[8], Cout, O);
	wire[3:0] Z;
	wire C;
	greater_than_nine_if G({Cout, O}, Z, C);
	reg[3:0] S0;
	reg[3:0] S1;
	always @(Cout, O, Z, C)
	begin
		S0 = {Cout, O} - Z;
		S1 = {3'b000, C};
	end
	to_hex H1(S0, HEX0);
	to_hex H2(S1, HEX1);
	to_hex H3(SW[3:0], HEX3);
	to_hex H4(SW[7:4], HEX5);
endmodule

module adder(B, A, cin, cout, O);
   input [3:0] A, B;
	input cin;
	output cout;
	output [3:0]O;
	assign {cout, O} = A + B + cin;
endmodule

module greater_than_nine_if(T, Z, C);
	input [4:0]T;
	output [3:0]Z;
	output C;
	reg [3:0]Z;
	reg C;
	always @(T)
	begin
		if (T>9)
		begin
			Z = 10;
			C = 1;
		end
		else
		begin
			Z = 0;
			C = 0;
		end
	end
endmodule
	
module to_hex(in, disp);
	input [3:0]in;
	output [0:6]disp;

	assign disp[0] = (~in[3] & ~in[2] & ~in[1] & in[0])
						| (~in[3] & in[2] & ~in[1] & ~in[0]);
	assign disp[1] = (~in[3] & in[2] & ~in[1] & in[0])
						| (~in[3] & in[2] & in[1] & ~in[0]);
	assign disp[2] = (~in[3] & ~in[2] & in[1] & ~in[0]);
	assign disp[3] = (~in[3] & ~in[2] & ~in[1] & in[0])
						| (~in[3] & in[2] & ~in[1] & ~in[0])
						| (~in[3] & in[2] & in[1] & in[0])
						| (in[3] & ~in[2] & ~in[1] & in[0]);
	assign disp[4] = ~((~in[3] & ~in[2] & ~in[1] & ~in[0])
						| (~in[3] & ~in[2] & in[1] & ~in[0])
						| (~in[3] & in[2] & in[1] & ~in[0])
						| (in[3] & ~in[2] & ~in[1] & ~in[0]));
	assign disp[5] = (~in[3] & ~in[2] & ~in[1] & in[0])
						| (~in[3] & ~in[2] & in[1] & ~in[0])
						| (~in[3] & ~in[2] & in[1] & in[0])
						| (~in[3] & in[2] & in[1] & in[0]);
	assign disp[6] = (~in[3] & ~in[2] & ~in[1] & ~in[0])
						| (~in[3] & ~in[2] & ~in[1] & in[0])
						| (~in[3] & in[2] & in[1] & in[0]);
endmodule		