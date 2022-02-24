module controller(
/*段间流水指令寄存器*/
input rst,
input [31:0] if_Instr,
input [31:0] id_Instr,
input [31:0] ex_Instr,
input [31:0] me_Instr,
input [31:0] wb_Instr,




input equal,//相等为1，不相等为0


/*ALU状态信号，决定是否写入等操作*/
/*input me_Z,
input me_C,
input me_N,
input me_O,
input wb_Z,
input wb_C,
input wb_N,
input wb_O,*/

output RF_W,
output [3:0] ALUC,//alu识别码

/*选择器*/
output  [1:0] PCMux,
output  [1:0] ALUaMux,
output  [1:0] ALUbMux,
output  rdMux,
output  [1:0] rdcMux,


/*dmem信号*/
output CS,
output DM_R,
output DM_W,

output reg [4:0] stall

    );
    
    
    /*主体思想：分段指令译码，每一个流水段间的译码过程相同（整体替换关键字即可）*/
    
    //定义id分段的指令译码
    wire [5:0] id_op = id_Instr[31:26];
    wire [5:0] id_func = id_Instr[5:0];
    //指令种类，组合逻辑构建
    wire id_add,id_addi,id_addu,id_addiu,id_sub,id_subu;
    wire id_and,id_andi,id_or,id_ori,id_xor,id_xori,id_nor;
    wire id_lui;
    wire id_sll,id_sllv,id_sra,id_srav,id_srl,id_srlv;
    wire id_slt,id_slti,id_sltu,id_sltiu;
    wire id_beq,id_bne;
    wire id_j,id_jal,id_jr;
    wire id_lw,id_sw;
    

    
    //R-TYPE
    assign id_add=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(id_func[5])&(~id_func[4])&(~id_func[3])&(~id_func[2])&(~id_func[1])&(~id_func[0]);
    assign id_addu=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(id_func[5])&(~id_func[4])&(~id_func[3])&(~id_func[2])&(~id_func[1])&(id_func[0]);
    assign id_sub=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(id_func[5])&(~id_func[4])&(~id_func[3])&(~id_func[2])&(id_func[1])&(~id_func[0]);
    assign id_subu=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(id_func[5])&(~id_func[4])&(~id_func[3])&(~id_func[2])&(id_func[1])&(id_func[0]);
    assign id_and=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(id_func[5])&(~id_func[4])&(~id_func[3])&(id_func[2])&(~id_func[1])&(~id_func[0]);
    assign id_or=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(id_func[5])&(~id_func[4])&(~id_func[3])&(id_func[2])&(~id_func[1])&(id_func[0]);
    assign id_xor=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(id_func[5])&(~id_func[4])&(~id_func[3])&(id_func[2])&(id_func[1])&(~id_func[0]);
    assign id_nor=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(id_func[5])&(~id_func[4])&(~id_func[3])&(id_func[2])&(id_func[1])&(id_func[0]);
    assign id_slt=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(id_func[5])&(~id_func[4])&(id_func[3])&(~id_func[2])&(id_func[1])&(~id_func[0]);
    assign id_sltu=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(id_func[5])&(~id_func[4])&(id_func[3])&(~id_func[2])&(id_func[1])&(id_func[0]);
    
    assign id_sll=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(~id_func[5])&(~id_func[4])&(~id_func[3])&(~id_func[2])&(~id_func[1])&(~id_func[0]);
    assign id_srl=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(~id_func[5])&(~id_func[4])&(~id_func[3])&(~id_func[2])&(id_func[1])&(~id_func[0]);
    assign id_sra=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(~id_func[5])&(~id_func[4])&(~id_func[3])&(~id_func[2])&(id_func[1])&(id_func[0]);
    assign id_sllv=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(~id_func[5])&(~id_func[4])&(~id_func[3])&(id_func[2])&(~id_func[1])&(~id_func[0]);
    assign id_srlv=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(~id_func[5])&(~id_func[4])&(~id_func[3])&(id_func[2])&(id_func[1])&(~id_func[0]);
    assign id_srav=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(~id_func[5])&(~id_func[4])&(~id_func[3])&(id_func[2])&(id_func[1])&(id_func[0]);
    assign id_jr=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0])&(~id_func[5])&(~id_func[4])&(id_func[3])&(~id_func[2])&(~id_func[1])&(~id_func[0]);
    
    //I-TYPE
    assign id_addi=(~id_op[5])&(~id_op[4])&(id_op[3])&(~id_op[2])&(~id_op[1])&(~id_op[0]);
    assign id_addiu=(~id_op[5])&(~id_op[4])&(id_op[3])&(~id_op[2])&(~id_op[1])&(id_op[0]);
    assign id_andi=(~id_op[5])&(~id_op[4])&(id_op[3])&(id_op[2])&(~id_op[1])&(~id_op[0]);
    assign id_ori=(~id_op[5])&(~id_op[4])&(id_op[3])&(id_op[2])&(~id_op[1])&(id_op[0]);
    assign id_xori=(~id_op[5])&(~id_op[4])&(id_op[3])&(id_op[2])&(id_op[1])&(~id_op[0]);
    assign id_lui=(~id_op[5])&(~id_op[4])&(id_op[3])&(id_op[2])&(id_op[1])&(id_op[0]);
    assign id_lw=(id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(id_op[1])&(id_op[0]);
    assign id_sw=(id_op[5])&(~id_op[4])&(id_op[3])&(~id_op[2])&(id_op[1])&(id_op[0]);
    assign id_beq=(~id_op[5])&(~id_op[4])&(~id_op[3])&(id_op[2])&(~id_op[1])&(~id_op[0]);
    assign id_bne=(~id_op[5])&(~id_op[4])&(~id_op[3])&(id_op[2])&(~id_op[1])&(id_op[0]);    
    assign id_slti=(~id_op[5])&(~id_op[4])&(id_op[3])&(~id_op[2])&(id_op[1])&(~id_op[0]);
    assign id_sltiu=(~id_op[5])&(~id_op[4])&(id_op[3])&(~id_op[2])&(id_op[1])&(id_op[0]);
    
    //J-TYPE
    assign id_j=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(id_op[1])&(~id_op[0]);
    assign id_jal=(~id_op[5])&(~id_op[4])&(~id_op[3])&(~id_op[2])&(id_op[1])&(id_op[0]);
    
    //stall-TYPE
    wire id_extra_stall;
    assign id_extra_stall=(id_op[5])&(id_op[4])&(id_op[3])&(id_op[2])&(id_op[1])&(id_op[0]);
    
    //定义ex分段的指令译码
    wire [5:0] ex_op = ex_Instr[31:26];
    wire [5:0] ex_func = ex_Instr[5:0];    
    //指令种类，组合逻辑构建
    wire ex_add,ex_addi,ex_addu,ex_addiu,ex_sub,ex_subu;
    wire ex_and,ex_andi,ex_or,ex_ori,ex_xor,ex_xori,ex_nor;
    wire ex_lui;
    wire ex_sll,ex_sllv,ex_sra,ex_srav,ex_srl,ex_srlv;
    wire ex_slt,ex_slti,ex_sltu,ex_sltiu;
    wire ex_beq,ex_bne;
    wire ex_j,ex_jal,ex_jr;
    wire ex_lw,ex_sw;
    
    //R-TYPE
    assign ex_add=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(ex_func[5])&(~ex_func[4])&(~ex_func[3])&(~ex_func[2])&(~ex_func[1])&(~ex_func[0]);
    assign ex_addu=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(ex_func[5])&(~ex_func[4])&(~ex_func[3])&(~ex_func[2])&(~ex_func[1])&(ex_func[0]);
    assign ex_sub=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(ex_func[5])&(~ex_func[4])&(~ex_func[3])&(~ex_func[2])&(ex_func[1])&(~ex_func[0]);
    assign ex_subu=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(ex_func[5])&(~ex_func[4])&(~ex_func[3])&(~ex_func[2])&(ex_func[1])&(ex_func[0]);
    assign ex_and=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(ex_func[5])&(~ex_func[4])&(~ex_func[3])&(ex_func[2])&(~ex_func[1])&(~ex_func[0]);
    assign ex_or=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(ex_func[5])&(~ex_func[4])&(~ex_func[3])&(ex_func[2])&(~ex_func[1])&(ex_func[0]);
    assign ex_xor=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(ex_func[5])&(~ex_func[4])&(~ex_func[3])&(ex_func[2])&(ex_func[1])&(~ex_func[0]);
    assign ex_nor=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(ex_func[5])&(~ex_func[4])&(~ex_func[3])&(ex_func[2])&(ex_func[1])&(ex_func[0]);
    assign ex_slt=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(ex_func[5])&(~ex_func[4])&(ex_func[3])&(~ex_func[2])&(ex_func[1])&(~ex_func[0]);
    assign ex_sltu=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(ex_func[5])&(~ex_func[4])&(ex_func[3])&(~ex_func[2])&(ex_func[1])&(ex_func[0]);
    
    assign ex_sll=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(~ex_func[5])&(~ex_func[4])&(~ex_func[3])&(~ex_func[2])&(~ex_func[1])&(~ex_func[0]);
    assign ex_srl=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(~ex_func[5])&(~ex_func[4])&(~ex_func[3])&(~ex_func[2])&(ex_func[1])&(~ex_func[0]);
    assign ex_sra=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(~ex_func[5])&(~ex_func[4])&(~ex_func[3])&(~ex_func[2])&(ex_func[1])&(ex_func[0]);
    assign ex_sllv=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(~ex_func[5])&(~ex_func[4])&(~ex_func[3])&(ex_func[2])&(~ex_func[1])&(~ex_func[0]);
    assign ex_srlv=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(~ex_func[5])&(~ex_func[4])&(~ex_func[3])&(ex_func[2])&(ex_func[1])&(~ex_func[0]);
    assign ex_srav=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(~ex_func[5])&(~ex_func[4])&(~ex_func[3])&(ex_func[2])&(ex_func[1])&(ex_func[0]);
    assign ex_jr=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0])&(~ex_func[5])&(~ex_func[4])&(ex_func[3])&(~ex_func[2])&(~ex_func[1])&(~ex_func[0]);
    
    //I-TYPE
    assign ex_addi=(~ex_op[5])&(~ex_op[4])&(ex_op[3])&(~ex_op[2])&(~ex_op[1])&(~ex_op[0]);
    assign ex_addiu=(~ex_op[5])&(~ex_op[4])&(ex_op[3])&(~ex_op[2])&(~ex_op[1])&(ex_op[0]);
    assign ex_andi=(~ex_op[5])&(~ex_op[4])&(ex_op[3])&(ex_op[2])&(~ex_op[1])&(~ex_op[0]);
    assign ex_ori=(~ex_op[5])&(~ex_op[4])&(ex_op[3])&(ex_op[2])&(~ex_op[1])&(ex_op[0]);
    assign ex_xori=(~ex_op[5])&(~ex_op[4])&(ex_op[3])&(ex_op[2])&(ex_op[1])&(~ex_op[0]);
    assign ex_lui=(~ex_op[5])&(~ex_op[4])&(ex_op[3])&(ex_op[2])&(ex_op[1])&(ex_op[0]);
    assign ex_lw=(ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(ex_op[1])&(ex_op[0]);
    assign ex_sw=(ex_op[5])&(~ex_op[4])&(ex_op[3])&(~ex_op[2])&(ex_op[1])&(ex_op[0]);
    assign ex_beq=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(ex_op[2])&(~ex_op[1])&(~ex_op[0]);
    assign ex_bne=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(ex_op[2])&(~ex_op[1])&(ex_op[0]);    
    assign ex_slti=(~ex_op[5])&(~ex_op[4])&(ex_op[3])&(~ex_op[2])&(ex_op[1])&(~ex_op[0]);
    assign ex_sltiu=(~ex_op[5])&(~ex_op[4])&(ex_op[3])&(~ex_op[2])&(ex_op[1])&(ex_op[0]);
    
    //J-TYPE
    assign ex_j=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(ex_op[1])&(~ex_op[0]);
    assign ex_jal=(~ex_op[5])&(~ex_op[4])&(~ex_op[3])&(~ex_op[2])&(ex_op[1])&(ex_op[0]);
    
    //stall-TYPE
    wire ex_extra_stall;
    assign ex_extra_stall=(ex_op[5])&(ex_op[4])&(ex_op[3])&(ex_op[2])&(ex_op[1])&(ex_op[0]);
    
    //定义me分段的指令译码
    wire [5:0] me_op = me_Instr[31:26];
    wire [5:0] me_func = me_Instr[5:0];
    //指令种类，组合逻辑构建
    wire me_add,me_addi,me_addu,me_addiu,me_sub,me_subu;
    wire me_and,me_andi,me_or,me_ori,me_xor,me_xori,me_nor;
    wire me_lui;
    wire me_sll,me_sllv,me_sra,me_srav,me_srl,me_srlv;
    wire me_slt,me_slti,me_sltu,me_sltiu;
    wire me_beq,me_bne;
    wire me_j,me_jal,me_jr;
    wire me_lw,me_sw;
    
    //R-TYPE
    assign me_add=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(me_func[5])&(~me_func[4])&(~me_func[3])&(~me_func[2])&(~me_func[1])&(~me_func[0]);
    assign me_addu=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(me_func[5])&(~me_func[4])&(~me_func[3])&(~me_func[2])&(~me_func[1])&(me_func[0]);
    assign me_sub=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(me_func[5])&(~me_func[4])&(~me_func[3])&(~me_func[2])&(me_func[1])&(~me_func[0]);
    assign me_subu=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(me_func[5])&(~me_func[4])&(~me_func[3])&(~me_func[2])&(me_func[1])&(me_func[0]);
    assign me_and=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(me_func[5])&(~me_func[4])&(~me_func[3])&(me_func[2])&(~me_func[1])&(~me_func[0]);
    assign me_or=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(me_func[5])&(~me_func[4])&(~me_func[3])&(me_func[2])&(~me_func[1])&(me_func[0]);
    assign me_xor=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(me_func[5])&(~me_func[4])&(~me_func[3])&(me_func[2])&(me_func[1])&(~me_func[0]);
    assign me_nor=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(me_func[5])&(~me_func[4])&(~me_func[3])&(me_func[2])&(me_func[1])&(me_func[0]);
    assign me_slt=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(me_func[5])&(~me_func[4])&(me_func[3])&(~me_func[2])&(me_func[1])&(~me_func[0]);
    assign me_sltu=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(me_func[5])&(~me_func[4])&(me_func[3])&(~me_func[2])&(me_func[1])&(me_func[0]);
    
    assign me_sll=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(~me_func[5])&(~me_func[4])&(~me_func[3])&(~me_func[2])&(~me_func[1])&(~me_func[0]);
    assign me_srl=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(~me_func[5])&(~me_func[4])&(~me_func[3])&(~me_func[2])&(me_func[1])&(~me_func[0]);
    assign me_sra=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(~me_func[5])&(~me_func[4])&(~me_func[3])&(~me_func[2])&(me_func[1])&(me_func[0]);
    assign me_sllv=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(~me_func[5])&(~me_func[4])&(~me_func[3])&(me_func[2])&(~me_func[1])&(~me_func[0]);
    assign me_srlv=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(~me_func[5])&(~me_func[4])&(~me_func[3])&(me_func[2])&(me_func[1])&(~me_func[0]);
    assign me_srav=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(~me_func[5])&(~me_func[4])&(~me_func[3])&(me_func[2])&(me_func[1])&(me_func[0]);
    assign me_jr=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0])&(~me_func[5])&(~me_func[4])&(me_func[3])&(~me_func[2])&(~me_func[1])&(~me_func[0]);
    
    //I-TYPE
    assign me_addi=(~me_op[5])&(~me_op[4])&(me_op[3])&(~me_op[2])&(~me_op[1])&(~me_op[0]);
    assign me_addiu=(~me_op[5])&(~me_op[4])&(me_op[3])&(~me_op[2])&(~me_op[1])&(me_op[0]);
    assign me_andi=(~me_op[5])&(~me_op[4])&(me_op[3])&(me_op[2])&(~me_op[1])&(~me_op[0]);
    assign me_ori=(~me_op[5])&(~me_op[4])&(me_op[3])&(me_op[2])&(~me_op[1])&(me_op[0]);
    assign me_xori=(~me_op[5])&(~me_op[4])&(me_op[3])&(me_op[2])&(me_op[1])&(~me_op[0]);
    assign me_lui=(~me_op[5])&(~me_op[4])&(me_op[3])&(me_op[2])&(me_op[1])&(me_op[0]);
    assign me_lw=(me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(me_op[1])&(me_op[0]);
    assign me_sw=(me_op[5])&(~me_op[4])&(me_op[3])&(~me_op[2])&(me_op[1])&(me_op[0]);
    assign me_beq=(~me_op[5])&(~me_op[4])&(~me_op[3])&(me_op[2])&(~me_op[1])&(~me_op[0]);
    assign me_bne=(~me_op[5])&(~me_op[4])&(~me_op[3])&(me_op[2])&(~me_op[1])&(me_op[0]);    
    assign me_slti=(~me_op[5])&(~me_op[4])&(me_op[3])&(~me_op[2])&(me_op[1])&(~me_op[0]);
    assign me_sltiu=(~me_op[5])&(~me_op[4])&(me_op[3])&(~me_op[2])&(me_op[1])&(me_op[0]);
    
    //J-TYPE
    assign me_j=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(me_op[1])&(~me_op[0]);
    assign me_jal=(~me_op[5])&(~me_op[4])&(~me_op[3])&(~me_op[2])&(me_op[1])&(me_op[0]);
    
    //stall-TYPE
    wire me_extra_stall;
    assign me_extra_stall=(me_op[5])&(me_op[4])&(me_op[3])&(me_op[2])&(me_op[1])&(me_op[0]);
    
    //定义ex分段的指令译码
    wire [5:0] wb_op = wb_Instr[31:26];
    wire [5:0] wb_func = wb_Instr[5:0];    
    //指令种类，组合逻辑构建
    wire wb_add,wb_addi,wb_addu,wb_addiu,wb_sub,wb_subu;
    wire wb_and,wb_andi,wb_or,wb_ori,wb_xor,wb_xori,wb_nor;
    wire wb_lui;
    wire wb_sll,wb_sllv,wb_sra,wb_srav,wb_srl,wb_srlv;
    wire wb_slt,wb_slti,wb_sltu,wb_sltiu;
    wire wb_beq,wb_bne;
    wire wb_j,wb_jal,wb_jr;
    wire wb_lw,wb_sw;
    
    //R-TYPE
    assign wb_add=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(wb_func[5])&(~wb_func[4])&(~wb_func[3])&(~wb_func[2])&(~wb_func[1])&(~wb_func[0]);
    assign wb_addu=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(wb_func[5])&(~wb_func[4])&(~wb_func[3])&(~wb_func[2])&(~wb_func[1])&(wb_func[0]);
    assign wb_sub=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(wb_func[5])&(~wb_func[4])&(~wb_func[3])&(~wb_func[2])&(wb_func[1])&(~wb_func[0]);
    assign wb_subu=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(wb_func[5])&(~wb_func[4])&(~wb_func[3])&(~wb_func[2])&(wb_func[1])&(wb_func[0]);
    assign wb_and=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(wb_func[5])&(~wb_func[4])&(~wb_func[3])&(wb_func[2])&(~wb_func[1])&(~wb_func[0]);
    assign wb_or=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(wb_func[5])&(~wb_func[4])&(~wb_func[3])&(wb_func[2])&(~wb_func[1])&(wb_func[0]);
    assign wb_xor=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(wb_func[5])&(~wb_func[4])&(~wb_func[3])&(wb_func[2])&(wb_func[1])&(~wb_func[0]);
    assign wb_nor=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(wb_func[5])&(~wb_func[4])&(~wb_func[3])&(wb_func[2])&(wb_func[1])&(wb_func[0]);
    assign wb_slt=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(wb_func[5])&(~wb_func[4])&(wb_func[3])&(~wb_func[2])&(wb_func[1])&(~wb_func[0]);
    assign wb_sltu=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(wb_func[5])&(~wb_func[4])&(wb_func[3])&(~wb_func[2])&(wb_func[1])&(wb_func[0]);
    
    assign wb_sll=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(~wb_func[5])&(~wb_func[4])&(~wb_func[3])&(~wb_func[2])&(~wb_func[1])&(~wb_func[0]);
    assign wb_srl=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(~wb_func[5])&(~wb_func[4])&(~wb_func[3])&(~wb_func[2])&(wb_func[1])&(~wb_func[0]);
    assign wb_sra=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(~wb_func[5])&(~wb_func[4])&(~wb_func[3])&(~wb_func[2])&(wb_func[1])&(wb_func[0]);
    assign wb_sllv=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(~wb_func[5])&(~wb_func[4])&(~wb_func[3])&(wb_func[2])&(~wb_func[1])&(~wb_func[0]);
    assign wb_srlv=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(~wb_func[5])&(~wb_func[4])&(~wb_func[3])&(wb_func[2])&(wb_func[1])&(~wb_func[0]);
    assign wb_srav=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(~wb_func[5])&(~wb_func[4])&(~wb_func[3])&(wb_func[2])&(wb_func[1])&(wb_func[0]);
    assign wb_jr=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0])&(~wb_func[5])&(~wb_func[4])&(wb_func[3])&(~wb_func[2])&(~wb_func[1])&(~wb_func[0]);
    
    //I-TYPE
    assign wb_addi=(~wb_op[5])&(~wb_op[4])&(wb_op[3])&(~wb_op[2])&(~wb_op[1])&(~wb_op[0]);
    assign wb_addiu=(~wb_op[5])&(~wb_op[4])&(wb_op[3])&(~wb_op[2])&(~wb_op[1])&(wb_op[0]);
    assign wb_andi=(~wb_op[5])&(~wb_op[4])&(wb_op[3])&(wb_op[2])&(~wb_op[1])&(~wb_op[0]);
    assign wb_ori=(~wb_op[5])&(~wb_op[4])&(wb_op[3])&(wb_op[2])&(~wb_op[1])&(wb_op[0]);
    assign wb_xori=(~wb_op[5])&(~wb_op[4])&(wb_op[3])&(wb_op[2])&(wb_op[1])&(~wb_op[0]);
    assign wb_lui=(~wb_op[5])&(~wb_op[4])&(wb_op[3])&(wb_op[2])&(wb_op[1])&(wb_op[0]);
    assign wb_lw=(wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(wb_op[1])&(wb_op[0]);
    assign wb_sw=(wb_op[5])&(~wb_op[4])&(wb_op[3])&(~wb_op[2])&(wb_op[1])&(wb_op[0]);
    assign wb_beq=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(wb_op[2])&(~wb_op[1])&(~wb_op[0]);
    assign wb_bne=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(wb_op[2])&(~wb_op[1])&(wb_op[0]);    
    assign wb_slti=(~wb_op[5])&(~wb_op[4])&(wb_op[3])&(~wb_op[2])&(wb_op[1])&(~wb_op[0]);
    assign wb_sltiu=(~wb_op[5])&(~wb_op[4])&(wb_op[3])&(~wb_op[2])&(wb_op[1])&(wb_op[0]);
    
    //J-TYPE
    assign wb_j=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(wb_op[1])&(~wb_op[0]);
    assign wb_jal=(~wb_op[5])&(~wb_op[4])&(~wb_op[3])&(~wb_op[2])&(wb_op[1])&(wb_op[0]);
    
    //stall-TYPE
    wire wb_extra_stall;
    assign wb_extra_stall=(wb_op[5])&(wb_op[4])&(wb_op[3])&(wb_op[2])&(wb_op[1])&(wb_op[0]);
    
    
    /*在初始的id段给出所有的控制信号，在后续过程中，使用段间流水寄存器传递段间的控制值*/
    /*本来为：((~O)&(i_add|i_addi|i_sub))，在后续流水线到达WB阶段时再处理*/
    assign RF_W=((id_add|id_addi|id_sub))|(id_addu)|(id_addiu)|(id_subu)|(id_and)|(id_andi)|(id_or)|(id_ori)|
    (id_xor)|(id_xori)|(id_nor)|(id_lui)|(id_sll)|(id_sllv)|(id_sra)|(id_srav)|(id_srl)|(id_srlv)|
    (id_slt)|(id_slti)|(id_sltu)|(id_sltiu)|(id_jal)|(id_lw);
    

    assign ALUC[3]=(id_lui)|(id_sll)|(id_sllv)|(id_sra)|(id_srav)|(id_srl)|(id_srlv)|(id_slt)|(id_slti)|(id_sltu)|(id_sltiu);  
    assign ALUC[2]=(id_and)|(id_andi)|(id_or)|(id_ori)|(id_xor)|(id_xori)|(id_nor)|(id_sll)|(id_sllv)|(id_sra)|(id_srav)|(id_srl)|(id_srlv);    
    assign ALUC[1]=(id_add)|(id_addi)|(id_sub)|(id_xor)|(id_xori)|(id_nor)|(id_sll)|(id_sllv)|(id_slt)|(id_slti)|(id_sltu)|(id_sltiu)|(id_lw)|(id_sw);  
    assign ALUC[0]=(id_sub)|(id_subu)|(id_or)|(id_ori)|(id_nor)|(id_srl)|(id_srlv)|(id_slt)|(id_slti);
    
    assign PCMux[1]=id_j|id_jal|id_jr; 
    assign PCMux[0]=(equal&id_beq)|((~equal)&id_bne)|id_jr;
    
    assign ALUaMux[0]=(id_add)|(id_addu)|(id_addi)|(id_addiu)|(id_sub)|(id_subu)|(id_and)|(id_andi)|(id_or)|(id_ori)|
    (id_xor)|(id_xori)|(id_nor)|(id_lui)|(id_sllv)|(id_srav)|(id_srlv)|
    (id_slt)|(id_slti)|(id_sltu)|(id_sltiu)|(id_beq)|(id_bne)|(id_j)|(id_jr)|(id_lw)|(id_sw);
    assign ALUaMux[1]=id_jal;//npc:10
    
    assign ALUbMux[1]=(id_addi)|(id_addiu)|(id_slti)|(id_sltiu)|(id_lw)|(id_sw)|id_jal; 
    assign ALUbMux[0]=(id_andi)|(id_ori)|(id_xori)|(id_lui)|id_jal;
    //id_jal:11,alub=0
    
    assign rdMux=id_lw;
    
    assign rdcMux[1]=id_jal;
    assign rdcMux[0]=(id_addi)|(id_addiu)|(id_andi)|(id_ori)|
    (id_xori)|(id_lui)|
    (id_slti)|(id_sltiu)|(id_beq)|(id_bne)|(id_j)|(id_jr)|(id_lw)|(id_sw);
    
    assign CS=(id_lw)|(id_sw);
    assign DM_R=(id_lw);
    assign DM_W=(id_sw);
    
    
    /*控制信号添加完毕，接下来检测流水线读写数据相关性
    由于是静态流水线，因此只有先写后读相关
    在wb周期向寄存器写入，同一周期，半段写，半段读，先写后读，所以不用考虑wb和id之间关系
    内存中，读写在同一个周期，没有问题
    只需要考虑id中读和ex，me中写，两个周期内会有冲突*/

    wire id_read_rs;//id段是否读rs
    wire id_read_rt;//id段是否读rt
    
    reg ex_write_rd;//ex段是否写rd
    reg [4:0] ex_write_rdc;//（如果是），ex段写rd的地址

    reg me_write_rd;
    reg [4:0] me_write_rdc;

    reg wb_write_rd;
    reg [4:0] wb_write_rdc;

    /*
    (id_add|id_addi|id_sub)|(id_addu)|(id_addiu)|(id_subu)|(id_and)|(id_andi)|(id_or)|(id_ori)|
            (id_xor)|(id_xori)|(id_nor)|(id_lui)|(id_sll)|(id_sllv)|(id_sra)|(id_srav)|(id_srl)|(id_srlv)|
            (id_slt)|(id_slti)|(id_sltu)|(id_sltiu)|(id_jal)|(id_lw)|(id_beq)|(id_bne)|(id_j)|(id_jr)|(id_sw);
            */
    
    assign id_read_rs=(id_add|id_addi|id_sub)|(id_addu)|(id_addiu)|(id_subu)|(id_and)|(id_andi)|(id_or)|(id_ori)|
        (id_xor)|(id_xori)|(id_nor)|(id_sllv)|(id_srav)|(id_srlv)|
        (id_slt)|(id_slti)|(id_sltu)|(id_sltiu)|(id_lw)|(id_beq)|(id_bne)|(id_jr)|(id_sw);

    assign id_read_rt=(id_add|id_sub)|(id_addu)|(id_subu)|(id_and)|(id_or)|
            (id_xor)|(id_nor)|(id_sll)|(id_sllv)|(id_sra)|(id_srav)|(id_srl)|(id_srlv)|
            (id_slt)|(id_sltu)|(id_beq)|(id_bne)|(id_sw);
    
    /*assign ex_write_rd=(ex_add|ex_sub)|(ex_addu)|(ex_subu)|(ex_and)|(ex_or)|
    (ex_xor)|(ex_nor)|(ex_sll)|(ex_sllv)|(ex_sra)|(ex_srav)|(ex_srl)|(ex_srlv)|
    (ex_slt)|(ex_sltu);*/
    
    wire [4:0] id_rs = id_Instr[25:21];
    wire [4:0] id_rt = id_Instr[20:16];
    wire [4:0] id_rd = id_Instr[15:11]; 
    wire [4:0] ex_rs = ex_Instr[25:21];
    wire [4:0] ex_rt = ex_Instr[20:16];
    wire [4:0] ex_rd = ex_Instr[15:11]; 
    wire [4:0] me_rs = me_Instr[25:21];
    wire [4:0] me_rt = me_Instr[20:16];
    wire [4:0] me_rd = me_Instr[15:11]; 
    wire [4:0] wb_rs = wb_Instr[25:21];
    wire [4:0] wb_rt = wb_Instr[20:16];
    wire [4:0] wb_rd = wb_Instr[15:11]; 
    
    always @ (*)
    begin
    if((ex_add|ex_sub)|(ex_addu)|(ex_subu)|(ex_and)|(ex_or)|(ex_xor)|(ex_nor)
    |(ex_sll)|(ex_sllv)|(ex_sra)|(ex_srav)|(ex_srl)|(ex_srlv)|(ex_slt)|(ex_sltu))
    begin
    ex_write_rd=1;
    ex_write_rdc=ex_rd;
    end
    else if((ex_addi)|(ex_addiu)|(ex_andi)|(ex_ori)|(ex_xori)|(ex_lui)|(ex_slti)|(ex_sltiu)|(ex_lw))
    begin
    ex_write_rd=1;
    ex_write_rdc=ex_rt;
    end
    else if(ex_jal)
    begin
    ex_write_rd=1;
    ex_write_rdc=5'b11111;
    end
    else
    begin
    ex_write_rd=0;
    ex_write_rdc=5'b00000;
    end
    end
    

    
    always @ (*)
    begin
    if((me_add|me_sub)|(me_addu)|(me_subu)|(me_and)|(me_or)|(me_xor)|(me_nor)
    |(me_sll)|(me_sllv)|(me_sra)|(me_srav)|(me_srl)|(me_srlv)|(me_slt)|(me_sltu))
    begin
    me_write_rd=1;
    me_write_rdc=me_rd;
    end
    else if((me_addi)|(me_addiu)|(me_andi)|(me_ori)|(me_xori)|(me_lui)|(me_slti)|(me_sltiu)|(me_lw))
    begin
    me_write_rd=1;
    me_write_rdc=me_rt;
    end
    else if(me_jal)
    begin
    me_write_rd=1;
    me_write_rdc=5'b11111;
    end
    else
    begin
    me_write_rd=0;
    me_write_rdc=5'b00000;
    end
    end
    
    always @ (*)
    begin
    if((wb_add|wb_sub)|(wb_addu)|(wb_subu)|(wb_and)|(wb_or)|(wb_xor)|(wb_nor)
    |(wb_sll)|(wb_sllv)|(wb_sra)|(wb_srav)|(wb_srl)|(wb_srlv)|(wb_slt)|(wb_sltu))
    begin
    wb_write_rd=1;
    wb_write_rdc=wb_rd;
    end
    else if((wb_addi)|(wb_addiu)|(wb_andi)|(wb_ori)|(wb_xori)|(wb_lui)|(wb_slti)|(wb_sltiu)|(wb_lw))
    begin
    wb_write_rd=1;
    wb_write_rdc=wb_rt;
    end
    else if(wb_jal)
    begin
    wb_write_rd=1;
    wb_write_rdc=5'b11111;
    end
    else
    begin
    wb_write_rd=0;
    wb_write_rdc=5'b00000;
    end
    end
    
      /*  wire id_read_rs;//id段是否读rs
    wire id_read_rt;//id段是否读rt
    
    reg ex_write_rd;//ex段是否写rd
    reg [4:0] ex_write_rdc;//（如果是），ex段写rd的地址

    reg me_write_rd;
    reg [4:0] me_write_rdc;*/
    
    /*读写相关检测完成，开始判断流水线是否暂停，在哪里暂停*/
    always @ (*)
    begin
    if(rst==1)
    stall=5'b00000;
    stall=5'b00000;
    
    if(ex_write_rd)
    begin
    if((id_read_rs==1 && ex_write_rdc==id_rs) || (id_read_rt==1 && ex_write_rdc==id_rt))
    stall=5'b00011;
    end
    
    if(me_write_rd)
    begin
    if((id_read_rs==1 && me_write_rdc==id_rs) || (id_read_rt==1 && me_write_rdc==id_rt))
    stall=5'b00011;
    end

    if(wb_write_rd)
    begin
    if((id_read_rs==1 && wb_write_rdc==id_rs) || (id_read_rt==1 && wb_write_rdc==id_rt))
    stall=5'b00011;
    end

    end
    
    
endmodule
