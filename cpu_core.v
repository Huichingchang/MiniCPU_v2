module cpu_core (
	input wire clk,
	input wire rst_n,
	output wire [7:0] alu_result,
	output wire [7:0] data_result,
	output wire [7:0] reg_a_result,
	output wire [7:0] reg_b_result
);

 // Program Counter
 reg [3:0] pc;

 // Instruction
 wire [7:0] instr;

 // Control signals
 wire we_a, we_b, do_alu, do_store;
 wire [1:0] alu_op;  // 2-bit ALU operation code
 wire [3:0] next_pc;  //接Control Unit產生的next_pc

 // Data path
 wire [7:0] reg_a_data, reg_b_data;
 reg [7:0] latched_data_result;  //latch起來,避免x
 wire [7:0] op_a, op_b;
 wire [7:0] alu_result_internal;  // ALU內部輸出

 // Assign outputs
 assign reg_a_result = reg_a_data;
 assign reg_b_result = reg_b_data;
 assign alu_result = alu_result_internal;
 assign data_result = latched_data_result;

 // PC Update
 always @(posedge clk or negedge rst_n) begin
   if(!rst_n)
     pc <= 4'd0;
   else
     pc <= next_pc;
 end

 // Instruction Memory
 instr_mem u_instr_mem(
   .addr(pc),
   .instr(instr)
 );

 // Register File
 reg_file u_reg_file (
   .clk(clk),
   .rst_n(rst_n),
   .we_a(we_a),
   .we_b(we_b),
   .data_in(latched_data_result),  // latch後送給Register
   .data_a(reg_a_data),  //正確接reg_a_data
   .data_b(reg_b_data)   //正確接reg_b_data
 );

 // ===ALU===
 alu u_alu(
   .op_a(op_a),
   .op_b(op_b),
   .alu_op(alu_op),
   .result(alu_result_internal)  // ALU內部連接
 );

 // ===Control Unit===
 control_unit u_control_unit(
   .clk(clk),
   .rst_n(rst_n),
   .instr(instr),
   .we_a(we_a),
   .we_b(we_b),
   .alu_op(alu_op),
   .do_alu(do_alu),
   .do_store(do_store),
   .next_pc(next_pc)
 );

 // Operand選擇
 assign op_a = reg_a_data;
 assign op_b = reg_b_data;

 // Data Selection - latch result to synchronize data
 always @(posedge clk or negedge rst_n) begin
   if (!rst_n)
	latched_data_result  <= 8'd0;
   else
	latched_data_result <= (do_alu) ? alu_result_internal : {4'd0, instr[3:0]};
 end

endmodule