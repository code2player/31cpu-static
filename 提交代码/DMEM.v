module DMEM(
input clk,
input ena,
input wena,//�ߵ�ƽд����Ч���͵�ƽ����Ч
input [10:0] addr,
input [31:0] data_in,
output reg [31:0] data_out
    );
    
    reg [31:0] memory [0:31];//reg����,ǰ��Ϊλ��������Ϊ����Ԫ�ظ���
    
    always @(*)
    begin
     if(ena==0)
       data_out=32'hzzzzzzzz;
       else
       begin
       
       if(wena==1)//д��Ч
       begin
      // memory[addr]=data_in;
       end
       else//����Ч
       begin
       data_out=memory[addr];
       end
       
       end
    
    
    
    end
    
    always @(posedge clk)
    begin
    if(ena==0)
    begin
    end
   // data_out=32'hzzzzzzzz;
    else
    begin
    
    if(wena==1)//д��Ч
    begin
    memory[addr]=data_in;
    end
    else//����Ч
    begin
  //  data_out=memory[addr];
    end
    
    end
    
    end
    
    
    
endmodule

