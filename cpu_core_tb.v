`timescale 1ns/1ps
module cpu_core_tb;

  //測試訊號
  reg clk;
  reg rst_n;
  //觀察CPU核心輸出
  wire [7:0] alu_result;
  wire [7:0] data_result;
  wire [7:0] reg_a_result;
  wire [7:0] reg_b_result;

  // Instantiate the DUT (Device Under Test)
  cpu_core uut(
	.clk(clk),
	.rst_n(rst_n),
	.alu_result(alu_result),
        .data_result(data_result),
        .reg_a_result(reg_a_result),
        .reg_b_result(reg_b_result)
        
  );

  //時脈產生器
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 100MHz時脈週期: 10ns
  end

  // Reset流程
  initial begin
    rst_n = 0;
    #20;  //保持一段時間
    rst_n = 1;
  end

  //模擬時間與結束條件
   initial begin
     $display("=== CPU Core Simulation Start ===");
     #2000;  //模擬 2000ns, 夠跑完整指令
     $display("=== CPU Coure Simulation End ===");
     $stop;
   end
endmodule