module aliens(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		KEY,
		SW,
		// The ports below are for the VGA output.  Do not change.
		// VGA_CLK,   						//	VGA Clock
		// VGA_HS,							//	VGA H_SYNC
		// VGA_VS,							//	VGA V_SYNC
		// VGA_BLANK_N,					//	VGA BLANK
		// VGA_SYNC_N,						//	VGA SYNC
		// VGA_R,   						//	VGA Red[9:0]
		// VGA_G,	 						//	VGA Green[9:0]
		// VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;			//	50 MHz
	input   [4:0]   SW;
	input   [0:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	// output			VGA_CLK;   				//	VGA Clock
	// output			VGA_HS;					//	VGA H_SYNC
	// output			VGA_VS;					//	VGA V_SYNC
	// output			VGA_BLANK_N;			//	VGA BLANK
	// output			VGA_SYNC_N;				//	VGA SYNC
	// output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	// output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	// output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	


	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	// vga_adapter VGA(
			// .resetn(resetn),
			// .clock(CLOCK_50),
			// .colour(colour),
			// .x(x),
			// .y(y),
			// .plot(writeEn),
			// /* Signals for the DAC to drive the monitor. */
			// .VGA_R(VGA_R),
			// .VGA_G(VGA_G),
			// .VGA_B(VGA_B),
			// .VGA_HS(VGA_HS),
			// .VGA_VS(VGA_VS),
			// .VGA_BLANK(VGA_BLANK_N),
			// .VGA_SYNC(VGA_SYNC_N),
			// .VGA_CLK(VGA_CLK));
		// defparam VGA.RESOLUTION = "160x120";
		// defparam VGA.MONOCHROME = "FALSE";
		// defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		// defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.

	
    // Instansiate datapath
	// datapath d0(...);

	datapath D0 (
	
	);
	
    // Instansiate FSM control
    // control c0(...);
    
	control C0(

	);
	
endmodule

module control(
	input clk,
	input resetn,
	input go_x, go_y,
	
	output reg ld_x, ld_y, ld_colour,
	output reg count_enable,
	output reg writeEn
	);
	
	reg [4:0] current_state, next_state;
	
	localparam  S_LOAD_X         = 5'd0,
               S_LOAD_X_WAIT    = 5'd1,
               S_LOAD_Y         = 5'd2,
               S_LOAD_Y_WAIT    = 5'd3,
               S_CYCLE_0        = 5'd4,
               S_CYCLE_1        = 5'd5,
               S_CYCLE_2        = 5'd6,
					S_CYCLE_3        = 5'd7,
					S_CYCLE_4        = 5'd8,
					S_CYCLE_5        = 5'd9,
					S_CYCLE_6        = 5'd10,
					S_CYCLE_7        = 5'd11,
					S_CYCLE_8        = 5'd12,
					S_CYCLE_9        = 5'd13,
					S_CYCLE_10       = 5'd14,
					S_CYCLE_11       = 5'd15,
					S_CYCLE_12       = 5'd16,
					S_CYCLE_13       = 5'd17,
					S_CYCLE_14       = 5'd18,
					S_CYCLE_15       = 5'd19;
	
	// Next state logic aka our state table
    always@(*)
		begin: state_table 
            case (current_state)
               S_LOAD_X: next_state = go_x ? S_LOAD_X_WAIT : S_LOAD_X; // Loop in current state until value is input
               S_LOAD_X_WAIT: next_state = go_x ? S_LOAD_X_WAIT : S_LOAD_Y; // Loop in current state until go signal goes low
               S_LOAD_Y: next_state = go_y ? S_LOAD_Y_WAIT : S_LOAD_Y; // Loop in current state until value is input
               S_LOAD_Y_WAIT: next_state = go_y ? S_LOAD_Y_WAIT : S_CYCLE_0; // Loop in current state until go signal goes low
               S_CYCLE_0: next_state = S_CYCLE_1;
					S_CYCLE_1: next_state = S_CYCLE_2;
					S_CYCLE_2: next_state = S_CYCLE_3;
					S_CYCLE_3: next_state = S_CYCLE_4;
					S_CYCLE_4: next_state = S_CYCLE_5;
					S_CYCLE_5: next_state = S_CYCLE_6;
					S_CYCLE_6: next_state = S_CYCLE_7;
					S_CYCLE_7: next_state = S_CYCLE_8;
					S_CYCLE_8: next_state = S_CYCLE_9;
					S_CYCLE_9: next_state = S_CYCLE_10;
					S_CYCLE_10: next_state = S_CYCLE_11;
					S_CYCLE_11: next_state = S_CYCLE_12;
					S_CYCLE_12: next_state = S_CYCLE_13;
					S_CYCLE_13: next_state = S_CYCLE_14;
					S_CYCLE_14: next_state = S_CYCLE_15;
               S_CYCLE_15: next_state = S_LOAD_X; // we will be done our two operations, start over after
				default:    next_state = S_LOAD_X;
        endcase
    end // state_table

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
		  // By default make all our signals 0ld_x = 1'b0;
		  ld_x = 1'b0;
        ld_y = 1'b0;
        ld_colour = 1'b0;
		  count_enable = 1'b0;
		  writeEn = 1'b0;
		  
		  case (current_state)
            S_LOAD_X: begin
                ld_x = 1'b1;
            end
            S_LOAD_Y: begin
                ld_y = 1'b1;
					 ld_colour = 1'b1;
            end
            S_CYCLE_0: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
				S_CYCLE_1: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
				S_CYCLE_2: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
				S_CYCLE_3: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
				S_CYCLE_4: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
				S_CYCLE_5: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
				S_CYCLE_6: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
				S_CYCLE_7: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
				S_CYCLE_8: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
				S_CYCLE_9: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
				S_CYCLE_10: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
				S_CYCLE_11: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
				S_CYCLE_12: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
				S_CYCLE_13: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
				S_CYCLE_14: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
				S_CYCLE_15: begin
                count_enable = 1'b1;
					 writeEn = 1'b1;
            end
//				default: begin
//					count_enable = 1'b1;
//					writeEn = 1'b1;
//				end// don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_X;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module datapath(
	input clk,
	input resetn,
	input [4:0] data_in, // This will come from ROM with alien statuses (1 = alive or 0 = dead).
	
	input ld_status, count_enable,
	input ld_pixel,
	input x_enable, y_enable,
	input x_move, y_move,
	
	output reg [7:0] x_plot,
	output reg [7:0] y_plot,
	output [2:0] colour,
	output plot_enable
	);
	
	reg [7:0] x;
	reg [7:0] y;
		
	reg [4:0] status_out;
	
	reg [3:0] counter_out;
	reg [5:0] coordinate_count;

	wire status_enable;
	assign status_enable = (counter_out == 1'b0) ? 0 : 1;
	
	assign plot_enable = status_out[4];
	
	wire pixel_enable;
	assign pixel_enable = (coordinate_count == 1'b0) ? 0: 1;
			
	// Alien status register.
	always @ (posedge clk) begin
		if (!resetn)
			status_out <= data_in[4:0];
		else if (ld_status == 1'b1)
			status_out <= data_in[4:0];
		else if (status_enable == 1'b1)
			status_out <= (status_out << 1'b1);
	end
	
	// 3-bit counter, counts 5 cycles for alien status register.
	always @ (posedge clk) begin
		if (!resetn) begin
			counter_out <= 3'd0;
		end
		else if (count_enable == 1'b1) begin
			if (counter_out == 3'd4)
				counter_out <= 3'd0;
			else
				counter_out <= counter_out + 1'b1;
		end
	end
	
	// Registers x, y, and colour.
   always @ (posedge clk) begin
		if (!resetn) begin
			x <= 8'd100;
			y <= 8'd10; 
		end
		else if (x_enable == 1'b1) begin
			if (x_move == 1'b1)
				x <= x + 2'd2;
			else
				x <= x - 2'd2;
		end
		else if (y_enable) begin
			if (y_move == 1'b1)
				y <= y + 4'd10;
		end
	end

// TO BE USED FOR MUTATING ALIEN ROWS.
// Determine left most and right most X.
//	always @ (posedge clk) begin
//		if (!resetn) begin
//			lm_x <= 8'd100;
//			rm_x <= 8'd102;
//		end
//		if (data_in[4] == 1'b0)
//			if (data_in[3] == 1'b1)
//				lm_x <= 8'd88;
//			else if (data_in[2] == 1'b1)
//				lm_x <= 8'd76;
//			else if (data_in[1] == 1'b1)
//				lm_x <= 8'd64;
//			else
//				lm_x <= 8'd52;
//		if (data_in[0] == 1'b0)
//			if (data_in[1] == 1'b1)
//				rm_x <= 8'd114
//			else if (data_in[2] == 1'b1)
//				rm_x <= 8'd126
//			else if (data_in[3] == 1'b1)
//				rm_x <= 8'd138;
//			else
//				rm_x <= 150;
//	end
	
	
	// Output X and Y to plot.
   always @ (posedge clk) begin
		if (!resetn) begin
			x_plot <= 8'd0;
			y_plot <= 8'd0; 
		end
		else begin
			x_plot <= x + coordinate_count[2:0];
			y_plot <= y + coordinate_count[5:3];
		end
   end

	//6-bit counter to calculate plot coordinates.
	always @ (posedge clk) begin
		if (!resetn)
			coordinate_count <= 6'd0;
		else if (count_enable == 1'b1) begin
			if (coordinate_count == 4'd63)
				coordinate_count <= 4'd0;
			else
				coordinate_count <= coordinate_count + 1'b1;
		end
	end
	
	pixel_from_sprite find_colour(
		.clk(clk),
		.resetn(resetn),
		.address(coordinate_count[5:3]),
		.ld_pixel(ld_pixel),
		.enable(pixel_enable),
		.colour(colour)
	);

endmodule

module pixel_from_sprite(clk, resetn, address, ld_pixel, enable, colour);
	input [2:0] address;
	input clk;
	input resetn;
	input ld_pixel;
	input enable;
	output reg [2:0] colour;
	
	wire [7:0] pixel_row;
	assign pixel_row = 8'b11111111;
	
	reg [7:0] pixel_out;
			
	always @(posedge clk)
	begin
		if (resetn == 1'b0) begin
			pixel_out <= 8'd0;
			colour <= 3'b000;
		end
		else if (ld_pixel == 1'b1) begin
			pixel_out <= pixel_row;
			colour <= {3{pixel_row[7]}};
		end
		else if (enable == 1'b1) begin
			pixel_out <= (pixel_out <<	1'b1);
			colour <= {3{pixel_row[7]}};
		end
	end
	
//	test_sprite_ROM sprite_ROM(
//		.address({2'b0, address}),
//		.clock(clk),
//		.q(pixel_row)
//	);
endmodule

// megafunction wizard: %ROM: 1-PORT%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: altsyncram 

// ============================================================
// File Name: test_sprite_ROM.v
// Megafunction Name(s):
// 			altsyncram
//
// Simulation Library Files(s):
// 			altera_mf
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 16.0.0 Build 211 04/27/2016 SJ Lite Edition
// ************************************************************


//Copyright (C) 1991-2016 Altera Corporation. All rights reserved.
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, the Altera Quartus Prime License Agreement,
//the Altera MegaCore Function License Agreement, or other 
//applicable license agreement, including, without limitation, 
//that your use is for the sole purpose of programming logic 
//devices manufactured by Altera and sold by Altera or its 
//authorized distributors.  Please refer to the applicable 
//agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module test_sprite_ROM (
	address,
	clock,
	q);

	input	[4:0]  address;
	input	  clock;
	output	[7:0]  q;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri1	  clock;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire [7:0] sub_wire0;
	wire [7:0] q = sub_wire0[7:0];

	altsyncram	altsyncram_component (
				.address_a (address),
				.clock0 (clock),
				.q_a (sub_wire0),
				.aclr0 (1'b0),
				.aclr1 (1'b0),
				.address_b (1'b1),
				.addressstall_a (1'b0),
				.addressstall_b (1'b0),
				.byteena_a (1'b1),
				.byteena_b (1'b1),
				.clock1 (1'b1),
				.clocken0 (1'b1),
				.clocken1 (1'b1),
				.clocken2 (1'b1),
				.clocken3 (1'b1),
				.data_a ({8{1'b1}}),
				.data_b (1'b1),
				.eccstatus (),
				.q_b (),
				.rden_a (1'b1),
				.rden_b (1'b1),
				.wren_a (1'b0),
				.wren_b (1'b0));
	defparam
		altsyncram_component.address_aclr_a = "NONE",
		altsyncram_component.clock_enable_input_a = "BYPASS",
		altsyncram_component.clock_enable_output_a = "BYPASS",
`ifdef NO_PLI
		altsyncram_component.init_file = "../../Users/Patrick/Documents/Project/test_sprite.rif"
`else
		altsyncram_component.init_file = "../../Users/Patrick/Documents/Project/test_sprite.hex"
`endif
,
		altsyncram_component.intended_device_family = "Cyclone V",
		altsyncram_component.lpm_hint = "ENABLE_RUNTIME_MOD=NO",
		altsyncram_component.lpm_type = "altsyncram",
		altsyncram_component.numwords_a = 32,
		altsyncram_component.operation_mode = "ROM",
		altsyncram_component.outdata_aclr_a = "NONE",
		altsyncram_component.outdata_reg_a = "UNREGISTERED",
		altsyncram_component.widthad_a = 5,
		altsyncram_component.width_a = 8,
		altsyncram_component.width_byteena_a = 1;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: ADDRESSSTALL_A NUMERIC "0"
// Retrieval info: PRIVATE: AclrAddr NUMERIC "0"
// Retrieval info: PRIVATE: AclrByte NUMERIC "0"
// Retrieval info: PRIVATE: AclrOutput NUMERIC "0"
// Retrieval info: PRIVATE: BYTE_ENABLE NUMERIC "0"
// Retrieval info: PRIVATE: BYTE_SIZE NUMERIC "8"
// Retrieval info: PRIVATE: BlankMemory NUMERIC "0"
// Retrieval info: PRIVATE: CLOCK_ENABLE_INPUT_A NUMERIC "0"
// Retrieval info: PRIVATE: CLOCK_ENABLE_OUTPUT_A NUMERIC "0"
// Retrieval info: PRIVATE: Clken NUMERIC "0"
// Retrieval info: PRIVATE: IMPLEMENT_IN_LES NUMERIC "0"
// Retrieval info: PRIVATE: INIT_FILE_LAYOUT STRING "PORT_A"
// Retrieval info: PRIVATE: INIT_TO_SIM_X NUMERIC "0"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
// Retrieval info: PRIVATE: JTAG_ENABLED NUMERIC "0"
// Retrieval info: PRIVATE: JTAG_ID STRING "NONE"
// Retrieval info: PRIVATE: MAXIMUM_DEPTH NUMERIC "0"
// Retrieval info: PRIVATE: MIFfilename STRING "../../Users/Patrick/Documents/Project/test_sprite.hex"
// Retrieval info: PRIVATE: NUMWORDS_A NUMERIC "32"
// Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "0"
// Retrieval info: PRIVATE: RegAddr NUMERIC "1"
// Retrieval info: PRIVATE: RegOutput NUMERIC "0"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "1"
// Retrieval info: PRIVATE: SingleClock NUMERIC "1"
// Retrieval info: PRIVATE: UseDQRAM NUMERIC "0"
// Retrieval info: PRIVATE: WidthAddr NUMERIC "5"
// Retrieval info: PRIVATE: WidthData NUMERIC "8"
// Retrieval info: PRIVATE: rden NUMERIC "0"
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: CONSTANT: ADDRESS_ACLR_A STRING "NONE"
// Retrieval info: CONSTANT: CLOCK_ENABLE_INPUT_A STRING "BYPASS"
// Retrieval info: CONSTANT: CLOCK_ENABLE_OUTPUT_A STRING "BYPASS"
// Retrieval info: CONSTANT: INIT_FILE STRING "../../Users/Patrick/Documents/Project/test_sprite.hex"
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
// Retrieval info: CONSTANT: LPM_HINT STRING "ENABLE_RUNTIME_MOD=NO"
// Retrieval info: CONSTANT: LPM_TYPE STRING "altsyncram"
// Retrieval info: CONSTANT: NUMWORDS_A NUMERIC "32"
// Retrieval info: CONSTANT: OPERATION_MODE STRING "ROM"
// Retrieval info: CONSTANT: OUTDATA_ACLR_A STRING "NONE"
// Retrieval info: CONSTANT: OUTDATA_REG_A STRING "UNREGISTERED"
// Retrieval info: CONSTANT: WIDTHAD_A NUMERIC "5"
// Retrieval info: CONSTANT: WIDTH_A NUMERIC "8"
// Retrieval info: CONSTANT: WIDTH_BYTEENA_A NUMERIC "1"
// Retrieval info: USED_PORT: address 0 0 5 0 INPUT NODEFVAL "address[4..0]"
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT VCC "clock"
// Retrieval info: USED_PORT: q 0 0 8 0 OUTPUT NODEFVAL "q[7..0]"
// Retrieval info: CONNECT: @address_a 0 0 5 0 address 0 0 5 0
// Retrieval info: CONNECT: @clock0 0 0 0 0 clock 0 0 0 0
// Retrieval info: CONNECT: q 0 0 8 0 @q_a 0 0 8 0
// Retrieval info: GEN_FILE: TYPE_NORMAL test_sprite_ROM.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL test_sprite_ROM.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL test_sprite_ROM.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL test_sprite_ROM.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL test_sprite_ROM_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL test_sprite_ROM_bb.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL test_sprite_ROM_syn.v TRUE
// Retrieval info: LIB_FILE: altera_mf
