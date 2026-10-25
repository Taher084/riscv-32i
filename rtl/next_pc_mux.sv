module next_pc_mux 
    import rv32i_pkg ::*;
    (
        input pc_sel_e pc_sel,
        input logic [31:0] pc_plus_4,
        input logic [31:0] pc_plus_imm,
        input logic [31:0] alu_result,
        output logic [31:0] next_pc
    );

    always_comb begin 
        case(pc_sel)
         
            PC_PLUS4 : 
                next_pc = pc_plus_4;
            PC_BRANCH :
                next_pc = pc_plus_imm;
            PC_JAL :
                next_pc = pc_plus_imm;
            PC_JALR :
                next_pc = {alu_result[31:1], 1'b0};;
            default :
                next_pc = pc_plus_4;    
        endcase
    end 
endmodule
