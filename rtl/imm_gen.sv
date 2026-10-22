module imm_gen
  import rv32i_pkg::*;
(
  input  logic [31:0] instr,      
  input  imm_type_e   imm_type,   
  output logic [31:0] imm_val   
);

  always_comb begin
    case (imm_type)
      IMM_I:   imm_val =  { {20{instr[31]}}, instr[31:20] };
      IMM_S:   imm_val = { {20{instr[31]}},instr[31], instr[30:25], instr[11:8], instr[7]};
      IMM_B:   imm_val = { {19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
      IMM_U:   imm_val = {instr[31:12], 12'b0};
      IMM_J:   imm_val = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
      default: imm_val = 32'b0;
    endcase
  end

endmodule