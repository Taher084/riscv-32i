module control
  import rv31i_pkg::*;
  (
  input logic [31:0] instr,
  ouput logic reg_write, mem_write, jal, jalr, branch,
  ouput logic imm_type_e imm_type,
  ouput logic wb_sel_e wb_sel,
  ouput logic op_a_sel_e op_sel_a,
  ouput logic op_b_sel_e op_sel_b,
  ouput logic alu_opr_e alu_op);
  
  logic [6:0] opcode;
  logic [2:0] funct3;
  logic [6:0] funct7;

  assign opcode = instr[6:0];
  assign funct3 = instr[14:12];
  assign funct7 = instr[31:25];
  
  always_comb begin 
  //defaults 
  reg_write = 0;
  mem_write = 0; 
  jal = 0;
  jalr = 0;
  branch = 0;
  imm_type = IMM_I;
  wb_sel = WB_ALU;
  op_sel_a = OPA_RS1;
  op_sel_b = OPB_RS2;
  alu_op = ALU_ADD;
  
  
  //Decoder 
  
  case(opcode) 
  
  OP_OP:                                    //R-type
        reg_write = 1
        case funct3:                            // ALU decoder, R-type rules
          F3_ADD_SUB : alu_op = (funct7 == F7_ALT) ? ALU_SUB : ALU_ADD
          F3_SLL     : alu_op = ALU_SLL
          F3_SLT     : alu_op = ALU_SLT
          F3_SLTU    : alu_op = ALU_SLTU
          F3_XOR     : alu_op = ALU_XOR
          F3_SRL_SRA : alu_op = (funct7 == F7_ALT) ? ALU_SRA : ALU_SRL
          F3_OR      : alu_op = ALU_OR
          F3_AND     : alu_op = ALU_AND
        endcase
          
  OP_OP_IMM:                                // I-type
    reg_write = 1;  op_b_sel = OPB_IMM;  imm_type = IMM_I
    case funct3:                            // ALU decoder, I-type rules
      F3_ADD_SUB : alu_op = ALU_ADD         
      F3_SLL     : alu_op = ALU_SLL
      F3_SLT     : alu_op = ALU_SLT
      F3_SLTU    : alu_op = ALU_SLTU
      F3_XOR     : alu_op = ALU_XOR
      F3_SRL_SRA : alu_op = (funct7 == F7_ALT) ? ALU_SRA : ALU_SRL
      F3_OR      : alu_op = ALU_OR
      F3_AND     : alu_op = ALU_AND
    endcase
    
   OP_LOAD: begin                                 // lb, lh, lw, lbu, lhu
        reg_write = 1'b1;
        op_b_sel  = OPB_IMM;
        imm_type  = IMM_I;
        alu_op    = ALU_ADD;                         // address = rs1 + imm
        wb_sel    = WB_MEM;
      end

      OP_STORE: begin                                // sb, sh, sw
        mem_write = 1'b1;
        op_b_sel  = OPB_IMM;
        imm_type  = IMM_S;
        alu_op    = ALU_ADD;                         // address = rs1 + imm
      end

      OP_BRANCH: begin                               // beq, bne, blt, bge, bltu, bgeu
        branch    = 1'b1;
        imm_type  = IMM_B;
      end

      OP_JAL: begin
        reg_write = 1'b1;
        jal       = 1'b1;
        imm_type  = IMM_J;
        wb_sel    = WB_PC4;                          // rd = return address
      end

      OP_JALR: begin
        reg_write = 1'b1;
        jalr      = 1'b1;
        imm_type  = IMM_I;
        op_b_sel  = OPB_IMM;
        alu_op    = ALU_ADD;                         // target = rs1 + imm
        wb_sel    = WB_PC4;
      end

      OP_LUI: begin
        reg_write = 1'b1;
        op_b_sel  = OPB_IMM;
        imm_type  = IMM_U;
        alu_op    = ALU_PASS_B;                      // rd = immediate
      end

      OP_AUIPC: begin
        reg_write = 1'b1;
        op_a_sel  = OPA_PC;
        op_b_sel  = OPB_IMM;
        imm_type  = IMM_U;
        alu_op    = ALU_ADD;                         // rd = PC + immediate
      end

      default: ;                                     // unknown: defaults stand
    endcase
  end

endmodule
      
  
  
  
  
  
  