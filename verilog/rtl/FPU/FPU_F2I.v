module FPU_Float_to_Int(FLOAT_TO_INT_input_float, FLOAT_TO_INT_input_rm, FLOAT_TO_INT_input_opcode_FI, FLOAT_TO_INT_input_opcode_signed, FLOAT_TO_INT_input_opcode_unsigned, rst_l, FLOAT_TO_INT_output_int, FLOAT_TO_INT_output_invalid_flag, FLOAT_TO_INT_output_inexact_flag);

parameter std = 15;//Bfloat16 and IEEE16
//parameter std = 31;//IEEE32
//parameter std = 63;//IEEE64

parameter man = 9;//IEEE16
//parameter man = 6;//Bfloat16
//parameter man = 22;//IEEE32
//parameter man = 51;//IEEE64

parameter exp = 4;//IEEE16
//parameter exp = 7;//IEEE32 and Bfloat16 
//parameter exp = 10;//IEEE64

//parameter bias = 127;//Bfloat16
parameter bias = 15;//16
//parameter bias = 127;//32
//parameter bias = 1023;//64

input [std : 0]FLOAT_TO_INT_input_float;
input [2:0]FLOAT_TO_INT_input_rm;
input FLOAT_TO_INT_input_opcode_FI;
input FLOAT_TO_INT_input_opcode_signed;
input FLOAT_TO_INT_input_opcode_unsigned;
input rst_l;


output [31 : 0]FLOAT_TO_INT_output_int;
output FLOAT_TO_INT_output_invalid_flag;
output FLOAT_TO_INT_output_inexact_flag;




wire [std : 0] FLOAT_TO_INT_input_wire_float;
wire [63 : 0]FLOAT_TO_INT_wire_float_mapped;
wire [10 : 0]FLOAT_TO_INT_wire_shifts_interim;
wire [10 : 0]FLOAT_TO_INT_wire_shifts_final;
wire [83 : 0]FLOAT_TO_INT_wire_shifted_data;
wire FLOAT_TO_INT_wire_condition_inf, FLOAT_TO_INT_wire_condition_rnte, FLOAT_TO_INT_wire_condition_rntmm;
wire FLOAT_TO_INT_wire_rounding;
wire [31 : 0]FLOAT_TO_INT_wire_rounded_int;
wire [31 : 0]FLOAT_TO_INT_wire_main_output;
wire FLOAT_TO_INT_bit_exception_for_max_caught, FLOAT_TO_INT_bit_exception_for_min_caught, FLOAT_TO_INT_bit_pos_infinity_caught, FLOAT_TO_INT_bit_neg_infinity_caught, FLOAT_TO_INT_bit_NaN_caught, FLOAT_TO_INT_bit_subnormal_caught;
wire FLOAT_TO_INT_wire_max, FLOAT_TO_INT_wire_min;
wire FLOAT_TO_INT_bit_fraction_caught;
wire [31 : 0]FLOAT_TO_INT_wire_output_interim_1_1, FLOAT_TO_INT_wire_output_exceptions, FLOAT_TO_INT_wire_output_interim_1_2;
wire FLOAT_TO_INT_bit_exception_for_max_1_caught, FLOAT_TO_INT_bit_exception_for_max_2_caught, FLOAT_TO_INT_bit_exception_for_min_1_caught;
wire FLOAT_TO_INT_wire_hidden_bit_decision;

//Setting the input to zero if rst_l or opcode_FI is low
assign FLOAT_TO_INT_input_wire_float = (FLOAT_TO_INT_input_opcode_FI && rst_l) ? FLOAT_TO_INT_input_float : {(std+1){1'b0}};

//Mapping the data to 64bit precision std
assign FLOAT_TO_INT_wire_float_mapped = {FLOAT_TO_INT_input_wire_float[std], (FLOAT_TO_INT_input_wire_float[std-1 : man+1] - bias[exp : 0] + 11'b011_1111_1111), ( {FLOAT_TO_INT_input_wire_float[man:0], {(51-man){1'b0}}} ) };

//Calculating shift amount
assign FLOAT_TO_INT_wire_shifts_interim = (11'b10000011110 - FLOAT_TO_INT_wire_float_mapped[62:52]);

//Setting the shifts to 83 incase they are greater than 83, 83 not 84 cause hidden 1 is letter required for rounding in case of fraction and subnormal numbers 
assign FLOAT_TO_INT_wire_shifts_final = (FLOAT_TO_INT_wire_shifts_interim > 84) ? (11'b000_0101_0011) : FLOAT_TO_INT_wire_shifts_interim ;

// Exponent and mantissa are all zero only in case of zeros, Hidden bit is set to zero only for the case of ) for subnormals it is not set to zero since setting it one will make the STICKY bit 1 (due to how the RTL is done which), sticky being one sets the inexact flag to 1. 
assign FLOAT_TO_INT_wire_hidden_bit_decision = (|FLOAT_TO_INT_input_wire_float[std-1 : 0]);
assign FLOAT_TO_INT_wire_shifted_data = {FLOAT_TO_INT_wire_hidden_bit_decision, FLOAT_TO_INT_wire_float_mapped[51:0],31'b0000000000000000000000000000000} >> (FLOAT_TO_INT_wire_shifts_final);

//Calculating incrementing conditions, if any of the three is high increment is to be done
assign FLOAT_TO_INT_wire_condition_inf = ((FLOAT_TO_INT_wire_shifted_data[50] | FLOAT_TO_INT_wire_shifted_data[51] | (|FLOAT_TO_INT_wire_shifted_data[49:0])) & ((FLOAT_TO_INT_input_rm == 3'b011 & ~FLOAT_TO_INT_wire_float_mapped[63])|(FLOAT_TO_INT_input_rm == 3'b010 & FLOAT_TO_INT_wire_float_mapped[63])));  
assign FLOAT_TO_INT_wire_condition_rnte = (FLOAT_TO_INT_input_rm == 3'b000 & ((FLOAT_TO_INT_wire_shifted_data[51] & (FLOAT_TO_INT_wire_shifted_data[50] | (|FLOAT_TO_INT_wire_shifted_data[49:0]))) | (FLOAT_TO_INT_wire_shifted_data[51] & ((~FLOAT_TO_INT_wire_shifted_data[50]) & ~(|FLOAT_TO_INT_wire_shifted_data[49:0])) & FLOAT_TO_INT_wire_shifted_data[52])));
assign FLOAT_TO_INT_wire_condition_rntmm = (FLOAT_TO_INT_input_rm == 3'b100 & ((FLOAT_TO_INT_wire_shifted_data[51] & (FLOAT_TO_INT_wire_shifted_data[50] | (|FLOAT_TO_INT_wire_shifted_data[49:0]))) | (FLOAT_TO_INT_wire_shifted_data[51] & ((~FLOAT_TO_INT_wire_shifted_data[50]) & ~(|FLOAT_TO_INT_wire_shifted_data[49:0])))));

assign FLOAT_TO_INT_wire_rounding = FLOAT_TO_INT_wire_condition_inf | FLOAT_TO_INT_wire_condition_rnte | FLOAT_TO_INT_wire_condition_rntmm;

//Roudning the Data
assign FLOAT_TO_INT_wire_rounded_int = FLOAT_TO_INT_wire_shifted_data[83:52] + FLOAT_TO_INT_wire_rounding ;

//Converting it to 2's compliment depending on opcode and sign of the number
assign FLOAT_TO_INT_wire_main_output = (FLOAT_TO_INT_input_wire_float[std]) ? ((~FLOAT_TO_INT_wire_rounded_int)+1'b1) : (FLOAT_TO_INT_wire_rounded_int) ;

//-------------------------------------EXCEPTION LOGIC---------------------------------------

assign FLOAT_TO_INT_bit_exception_for_max_caught = 
(((!FLOAT_TO_INT_input_wire_float[std])&                      //If sign is 0 +ve
(FLOAT_TO_INT_input_wire_float[std-1 : man+1] > 30+bias) &    //Exponent is greater than 30
(~(&FLOAT_TO_INT_input_wire_float[std-1 : man+1]))&           //Exponent is not all 1 (INF and NAN)
(FLOAT_TO_INT_input_opcode_signed))                           //Signed operation is being carried out
|
((!FLOAT_TO_INT_input_wire_float[std])&                       //If sign is zero +ve
(FLOAT_TO_INT_input_wire_float[std-1 : man+1] > 31+bias) &    //Exponent is greater than 31
(~(&FLOAT_TO_INT_input_wire_float[std-1 : man+1]))&           //Exponent is not all 1 (INF and NAN)
(FLOAT_TO_INT_input_opcode_unsigned)));                       //Unsigned operation is being carried out

assign FLOAT_TO_INT_bit_exception_for_min_caught =
(((FLOAT_TO_INT_wire_float_mapped[63])& 
(((FLOAT_TO_INT_wire_float_mapped[62 : 52] == 31+1023)	& ((|FLOAT_TO_INT_wire_float_mapped[51 : 22]))) | (FLOAT_TO_INT_wire_float_mapped[62 : 52] > 31+1023))& 	 
(~(&FLOAT_TO_INT_wire_float_mapped[62 : 52]))&
(FLOAT_TO_INT_input_opcode_signed))
|
(FLOAT_TO_INT_input_opcode_unsigned& 
(FLOAT_TO_INT_input_wire_float[std])));

/*
assign FLOAT_TO_INT_bit_exception_for_min_caught =
(std == 63) ?
(((FLOAT_TO_INT_input_wire_float[std])& 
(((FLOAT_TO_INT_input_wire_float[std-1 : man+1] == 31+bias)	& ((|FLOAT_TO_INT_input_wire_float[51 : 22]))) | (FLOAT_TO_INT_input_wire_float[std-1 : man+1] > 31+bias))& 	 
(~(&FLOAT_TO_INT_input_wire_float[std-1 : man+1]))&
(FLOAT_TO_INT_input_opcode_signed))
|
(FLOAT_TO_INT_input_opcode_unsigned& 
(FLOAT_TO_INT_input_wire_float[std])))
:
(((FLOAT_TO_INT_input_wire_float[std])& 
(((FLOAT_TO_INT_input_wire_float[std-1 : man+1] == 31+bias)	& (|FLOAT_TO_INT_input_wire_float[man : 0])) | (FLOAT_TO_INT_input_wire_float[std-1 : man+1] > 31+bias))& 	 
(~(&FLOAT_TO_INT_input_wire_float[std-1 : man+1]))&
(FLOAT_TO_INT_input_opcode_signed))
|
(FLOAT_TO_INT_input_opcode_unsigned& 
(FLOAT_TO_INT_input_wire_float[std])))
;
*/

//Checking for +ve  INF
assign FLOAT_TO_INT_bit_pos_infinity_caught = ((~FLOAT_TO_INT_input_wire_float[std]) & (&FLOAT_TO_INT_input_wire_float[std-1 : man+1]) & (&(~FLOAT_TO_INT_input_wire_float[man:0])));

//Checking for -ve INF
assign FLOAT_TO_INT_bit_neg_infinity_caught = ((FLOAT_TO_INT_input_wire_float[std]) & (&FLOAT_TO_INT_input_wire_float[std-1 : man+1]) & (&(~FLOAT_TO_INT_input_wire_float[man:0])));

//Checking for NANs
assign FLOAT_TO_INT_bit_NaN_caught = ((&FLOAT_TO_INT_input_wire_float[std-1 : man+1]) & (|FLOAT_TO_INT_input_wire_float[man:0]));

//Checking for subnormal numbers
assign FLOAT_TO_INT_bit_subnormal_caught = (FLOAT_TO_INT_input_wire_float[std-1 : man+1] == 0) & (|FLOAT_TO_INT_input_wire_float[man:0]);

//Exponent is lesser than BIAS means number is a fraction, Exponent is not all zero means number is not zero and number is not a subnormal. Condition of subnormal and zero is added since EXP of these numbers is 0 and 0 is lesser than BIAS
assign FLOAT_TO_INT_bit_fraction_caught = (FLOAT_TO_INT_input_wire_float[std-1 : man+1] < bias) & (|FLOAT_TO_INT_input_wire_float[std-1 : man+1]) & (!FLOAT_TO_INT_bit_subnormal_caught);

//Number goes out of range due to rounding
//Signed max
assign FLOAT_TO_INT_bit_exception_for_max_1_caught = 
((!FLOAT_TO_INT_wire_float_mapped[std])&                 //If sign is zero +ve
(FLOAT_TO_INT_wire_float_mapped[62:52] == 30+1023) &     //Exponent == 30
(~(&FLOAT_TO_INT_wire_float_mapped[62:52]))&             //Exponent is not all 1 (INF and NAN)
(&FLOAT_TO_INT_wire_float_mapped[51 : 21])&              //MSB 32 are all 1
(FLOAT_TO_INT_wire_rounding)&                            //Rounding is to be done
(FLOAT_TO_INT_input_opcode_signed));                     //Signed operation is being carried out

//Unsigned max
assign FLOAT_TO_INT_bit_exception_for_max_2_caught = 
((!FLOAT_TO_INT_wire_float_mapped[std])&                //If sign is zero +ve
(FLOAT_TO_INT_wire_float_mapped[62:52] == 31+1023) &    //Exponent == 31
(~(&FLOAT_TO_INT_wire_float_mapped[62:52]))&            //Exponent is not all 1 (INF and NAN)
(&FLOAT_TO_INT_wire_float_mapped[51 : 21])&             //MSB 32 are all 1
(FLOAT_TO_INT_wire_rounding)&                           //Rounding is to be done
(FLOAT_TO_INT_input_opcode_unsigned));                  //Unsigned operation is being carried out

//Signed min, Unsigned min is zero so no need to implement rounding logic for that
assign FLOAT_TO_INT_bit_exception_for_min_1_caught =
((FLOAT_TO_INT_wire_float_mapped[std])&                 //If sign is one -ve
(FLOAT_TO_INT_wire_float_mapped[62:52] == 31+1023)&     //Exponent == 31
(!(|FLOAT_TO_INT_wire_float_mapped[51 : 21]))& 	        //Integer bits of mantissa are all zero
(~(&FLOAT_TO_INT_wire_float_mapped[62:52]))&            //Exponent is not all 1 (INF and NAN)
(FLOAT_TO_INT_wire_rounding)&                           //Rounding up is to done
(FLOAT_TO_INT_input_opcode_signed));                    //Signed operation is to be done

assign FLOAT_TO_INT_wire_max = FLOAT_TO_INT_bit_exception_for_max_caught | FLOAT_TO_INT_bit_pos_infinity_caught | FLOAT_TO_INT_bit_NaN_caught | FLOAT_TO_INT_bit_exception_for_max_1_caught | FLOAT_TO_INT_bit_exception_for_max_2_caught;
//Subnormal and fraction are removed from min condition since they can be handled by main unit it self
assign FLOAT_TO_INT_wire_min = FLOAT_TO_INT_bit_exception_for_min_caught | FLOAT_TO_INT_bit_neg_infinity_caught | FLOAT_TO_INT_bit_exception_for_min_1_caught;

assign FLOAT_TO_INT_wire_output_interim_1_1 = (FLOAT_TO_INT_input_opcode_signed) ? 32'b0111_1111_1111_1111_1111_1111_1111_1111 : 32'b1111_1111_1111_1111_1111_1111_1111_1111 ;
assign FLOAT_TO_INT_wire_output_interim_1_2 = (FLOAT_TO_INT_input_opcode_signed & (FLOAT_TO_INT_bit_exception_for_min_caught | FLOAT_TO_INT_bit_neg_infinity_caught | FLOAT_TO_INT_bit_exception_for_min_1_caught)) ? 32'b1000_0000_0000_0000_0000_0000_0000_0000 : 32'b0000_0000_0000_0000_0000_0000_0000_0000 ;

assign FLOAT_TO_INT_wire_output_exceptions = (FLOAT_TO_INT_wire_max) ? FLOAT_TO_INT_wire_output_interim_1_1 : FLOAT_TO_INT_wire_output_interim_1_2 ;

assign FLOAT_TO_INT_output_int = (FLOAT_TO_INT_wire_max | FLOAT_TO_INT_wire_min) ? FLOAT_TO_INT_wire_output_exceptions : FLOAT_TO_INT_wire_main_output ;

//STICKY bit is getting high for exceptional data therefore in case of exceptional data inexact flag is nulified so that it doesnt get high
assign FLOAT_TO_INT_output_inexact_flag = ((!FLOAT_TO_INT_wire_min) & (!FLOAT_TO_INT_wire_max)) & (| FLOAT_TO_INT_wire_shifted_data[50] | FLOAT_TO_INT_wire_shifted_data[51] | (|FLOAT_TO_INT_wire_shifted_data[49:0]));


assign FLOAT_TO_INT_output_invalid_flag = FLOAT_TO_INT_wire_max | FLOAT_TO_INT_wire_min ;

endmodule
