import rv32i_pkg::*;

module pc_reg (
  input logic clk,
  input logic rst_n,
  input logic [LEN-1:0] next_pc,
  output logic [LEN-1:0] pc);

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin 
      pc <= RESET_PC;
    end
    else begin 
      pc <= next_pc;
    end
  end
      
endmodule 
  
  
    
  
  
  