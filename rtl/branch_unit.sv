module branch_unit
  import rv32i_pkg::*;
  (
  input logic [31:0] rs1_data,
  input logic [31:0] rs2_data,
  input logic [31:0] instr,
  output logic taken);
  
  logic [2:0] funct3;
  assign funct3 = instr[14:12];
  
  always_comb begin 
    case(funct3)
      case funct3:
      F3_BEQ  : taken = (rs1_data == rs2_data);
      F3_BNE  : taken = (rs1_data != rs2_data);
      F3_BLT  : taken = ($signed(rs1_data) <  $signed(rs2_data));   
      F3_BGE  : taken = ($signed(rs1_data) >= $signed(rs2_data));   
      F3_BLTU : taken = (rs1_data <  rs2_data) ;  
      F3_BGEU : taken = (rs1_data >= rs2_data) ;  
      default : taken = 0 ;                     
    endcase
      
  end 
endmodule 
  