module alu
  import rv32i_pkg::* ;(
  input logic [31:0] srcA,
  input logic [31:0] srcB,
  input logic [31:0] imm_value,
  input alu_opr_e alu_op,
  output logic [31:0] alu_result);

  always_comb begin 
    case(alu_op) 
      ALU_ADD : begin 
        alu_result = srcA + srcB;
      end 
      ALU_SUB : begin 
        alu_result = srcA - srcB; 
      end 

      ALU_SLL : begin 
        alu_result = srcA << srcB[4:0];
      end 

      ALU_SLT : begin 
        alu_result = ($signed(srcA) < $signed(srcB))?1:0; //the values coming in needs to be signed
      end
      ALU_SLTU : begin 
        alu_result = (srcA < srcB) ? 1:0; //the values coming in needs to be unsigned
      end
      ALU_XOR : begin
        alu_result = srcA ^ srcB; 
      end 
      ALU_SRL : begin 
        alu_result = srcA >> srcB[4:0] ; 
      end
      ALU_SRA : begin 
        alu_result = $signed(srcA) >>> srcB[4:0] ; 
      end 

      ALU_OR : begin 
        alu_result = srcA | srcB ; 
      end 
      ALU_AND : begin 
        alu_result = srcA & srcB ; 
      end 
      ALU_OR : begin 
        alu_result = srcA | srcB ; 
      end 
      ALU_PASS_B : begin 
        alu_result = srcB ; 
      end 
      default: alu_result = '0;
    endcase 
  end
endmodule 
  
  
  
