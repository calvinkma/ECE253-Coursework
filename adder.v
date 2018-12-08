module adder(SW, HEX0, HEX1, HEX3, HEX5, LEDR);
	input [8:0]SW; //0-3 X, 4-7 Y, 8 Cin
	output [0:6]HEX0, HEX1, HEX3, HEX5; //HEX1 tens; HEX0 ones
	//x: HEX5; y: HEX3
	output [9:0]LEDR;
	
	wire[4:0] ra_out; //5 bit output of ripple_adding X and Y
	wire X_EC, Y_EC; //for error checking
	
	comparator(SW[3:0], 0, X_EC);
	comparator(SW[7:4], 0, Y_EC);
	assign LEDR[9] = X_EC|Y_EC;
	
	//Display X and Y on HEX5 and HEX3
	to_hex th_x(SW[3:0], HEX5);
	to_hex th_y(SW[7:4], HEX3);
	
	//Add X, Y, Cin. 5 Bit out on wire ra_out
	//ra_out[4] is carry out
	ripple_add ra(SW[8:0], ra_out);
	assign LEDR[0] = ra_out[0];
	assign LEDR[1] = ra_out[1];
	assign LEDR[2] = ra_out[2];
	assign LEDR[3] = ra_out[3];
	assign LEDR[4] = ra_out[4];
	
	SW_in_to_2dig_dec S2D(ra_out[3:0], HEX1, HEX0, ra_out[4]);
endmodule

//Part 3
module ripple_add (in, out);
	input [8:0]in; 
	output [4:0]out; 
	wire c1, c2, c3;
	full_adder FA1(in[0], in[4], in[8], c1, out[0]);
	full_adder FA2(in[1], in[5], c1, c2, out[1]);
	full_adder FA3(in[2], in[6], c2, c3, out[2]);
	full_adder FA4(in[3], in[7], c3, out[4], out[3]);
endmodule

module full_adder (b, a, ci, co, s);
	input b, a, ci;
	output co, s;
	assign co = (a & b) | (a & ~b & ci) | (~a & b & ci);
	assign s = (~a & ~b & ci) | (a & ~b & ~ci)
				| (~a & b & ~ci) | (a & b & ci);
endmodule

//Part 2
module SW_in_to_2dig_dec(SW_in, disp1, disp0, cin);
	input [3:0]SW_in;
	input cin;
	output [0:6]disp1;
	output [0:6]disp0;
	wire [3:0]A_out, mux_out;
	wire [6:0]ones, tens;
	wire z;
	
	comparator C(SW_in[3:0], cin, z); //z
	circuitA A(SW_in[3:0], cin, A_out); //A
	mux M(z, SW_in[3:0], A_out, mux_out);
	to_hex H0(mux_out, ones);
	assign disp0 = ones;
	
	wire [3:0]z_arr;
	assign z_arr[3] = 0;
	assign z_arr[2] = 0;
	assign z_arr[1] = 0;
	assign z_arr[0] = z;
	
	to_hex H1(z_arr, tens);
	assign disp1 = tens;
endmodule

module comparator(V, c, z); //modified from part 2, take 4 bit V and 1 bit carry c
	input [3:0]V;
	input c;
	output z;
	assign z = (~c & ((V[1] & V[3]) | (~V[1] & V[2] & V[3])))
				| (c & (~V[2] & ~V[3]));
endmodule

module circuitA(V, c, A); //modified from part 2, take 4 bit V and 1 bit carry c
	input [3:0]V;
	input c;
	output [3:0]A;
	assign A[3] = c & V[1];
	assign A[2] = (~c & V[3] & V[2] & V[1] & ~V[0])
					| (~c & V[3] & V[2] & V[1] & V[0])
					| (c & ~V[3] & ~V[2] & ~V[1] & ~V[0])
					| (c & ~V[3] & ~V[2] & ~V[1] & V[0]);
	assign A[1] = (~c & V[3] & V[2] & ~V[1] & ~V[0])
					| (~c & V[3] & V[2] & ~V[1] & V[0])
					| (c & ~V[3] & ~V[2] & ~V[1] & ~V[0])
					| (c & ~V[3] & ~V[2] & ~V[1] & V[0]);
	assign A[0] = (~c & V[3] & ~V[2] & V[1] & V[0])
					| (~c & V[3] & V[2] & ~V[1] & V[0])
					| (~c & V[3] & V[2] & V[1] & V[0])
					| (c & ~V[3] & ~V[2] & ~V[1] & V[0])
					| (c & ~V[3] & ~V[2] & V[1] & V[0]);
endmodule

module mux(z, V, A, out); //4 bits, 2 to 1 mux
	input z;
	input [3:0]V;
	input [3:0]A;
	output [3:0]out;
	
	assign out[3] = (~z & V[3]) | (z & A[3]);
	assign out[2] = (~z & V[2]) | (z & A[2]);
	assign out[1] = (~z & V[1]) | (z & A[1]);
	assign out[0] = (~z & V[0]) | (z & A[0]);
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
