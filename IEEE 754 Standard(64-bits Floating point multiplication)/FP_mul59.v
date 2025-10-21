//------------------------------------------------------//
//- Digital IC Design 2023                              //
//-                                                     //
//- Final Project: FP_MUL                               //
//------------------------------------------------------//
`timescale 1ns/10ps

//cadence translate_off
`include "/usr/chipware/CW_mult_n_stage.v"
`include "/usr/chipware/CW_mult.v"
`include "/usr/chipware/CW_pipe_reg.v"
//cadence translate_on

module FP_MUL(CLK, RESET, ENABLE, DATA_IN, DATA_OUT, READY);


// I/O Ports
input         CLK; //clock signal
input         RESET; //sync. RESET=1
input         ENABLE; //input data sequence when ENABLE =1
input   [7:0] DATA_IN; //input data sequence
output  [7:0] DATA_OUT; //ouput data sequence
output        READY; //output data is READY when READY=1
//my code
//input
reg           READY;
reg     [4:0] counter_in;//數目前input的進度
reg     [7:0] input_A [0:7];
reg     [7:0] input_B [0:7];
reg           in_data_rdy; //input完成確認線
//output
wire    [7:0] output_Z [0:7];//合併signed exponent fraction 最終要輸出的output
reg     [7:0] DATA_OUT;
reg     [3:0] counter_out;//數目前output的進度
integer       i,j;
reg     [11:0] exponent_add;
//fraction
reg     [52:0] inpA,inpB;//將inputA inputB取下fraction part
wire    [105:0] fraction_temp;//inpA 與 inpB相乘後得結果
//signal
reg     [3:0]mul_count;
reg     mulrdy ;
reg     mul_done;  // done rise was 0  after mul 1 
////////////////input///////////////////////
//此部分將用counter計算輸入的次數，每個clk輸入8bit，並把計算當中的值當作Index給input_A 與 input_B 用
//當input 完成後in_data_rdy訊號拉高，當乘法完成後再把訊號拉低。
always@(posedge CLK)begin
  if(RESET)begin
    in_data_rdy <= 1'd0;
  end
  else if(mul_done)begin
    in_data_rdy <= 1'd0;
  end
  else if (counter_in==5'd15) begin
    in_data_rdy <= 1'b1;    
  end
end
always@(posedge CLK)begin
  if(RESET) begin
     counter_in <= 5'd0;
  end else if(mul_done)begin
     counter_in <= 5'd0;
  end else if (ENABLE && (counter_in < 5'd15) ) begin
     counter_in <= counter_in + 5'd1;
  end
end
always@(posedge CLK)begin
  if(RESET) begin
     for(i=0; i <= 7; i=i+1) input_A[i] <= 8'd0;
     for(j=0; j <= 7; j=j+1) input_B[j] <= 8'd0;
  end else if(counter_out==4'd7)begin  //output already catched data
     for(i=0; i <= 7; i=i+1) input_A[i] <= 8'd0;
     for(j=0; j <= 7; j=j+1) input_B[j] <= 8'd0;
  end else if (ENABLE && (counter_in < 5'd8) ) begin
     input_A[counter_in] <= DATA_IN;
  end else if (ENABLE && (counter_in <= 5'd15) ) begin
     input_B[counter_in-8'd8] <= DATA_IN;
  end
end
//exponent 相加後存入站存器add
always@(posedge CLK)begin
  if(RESET)begin
    exponent_add <= 12'd0;
  end
  else if(counter_out==4'd7)begin
    exponent_add <= 12'd0;
  end
  else if(in_data_rdy)begin
    exponent_add <= {input_A[7][6:0],input_A[6][7:4]} + {input_B[7][6:0],input_B[6][7:4]} - 12'b0001111111111;
  end
end
//這邊事先將input_A與input_B的fraction取下，並放入inpA與inpB
//放入完成拉高 mulrdy線，當成法結束 reset 線，由於此reg全部的值都會因Input更新，故這裡不再reset減少cost
always@(posedge CLK)begin
  if(RESET)begin
    inpA <= 52'd0;
    inpB <= 52'd0;
    mulrdy <= 1'd0;
   end else if(mul_done)begin
    mulrdy <= 1'd0;
   end else if(in_data_rdy)begin
      inpA <= {1'b1,input_A[6][3:0],input_A[5][7:0],input_A[4][7:0],input_A[3][7:0],
                    input_A[2][7:0],input_A[1][7:0],input_A[0][7:0]};
      inpB <= {1'b1,input_B[6][3:0],input_B[5][7:0],input_B[4][7:0],input_B[3][7:0],
                    input_B[2][7:0],input_B[1][7:0],input_B[0][7:0]};
      mulrdy <= 1'd1;
  end
end
//然後運用chipware 相乘 fraction part，且設定為5個週期，避免timeingviolation
//運用 mul_count計算週期，並等待抓值
//最後將mul_done拉高，在全部輸出完後再拉低。
//mul  part and control stage
CW_mult_n_stage #(53,53,5) mul_fraction(.A(inpA),.B(inpB),.TC(1'b0),.CLK(CLK),.Z(fraction_temp));
always@(posedge CLK)begin
  if(RESET)begin
    mul_count <= 4'd0;
    mul_done <= 1'd0;
  end else if(counter_out==4'd7)begin
    mul_count <= 4'd0;
    mul_done <= 1'd0;
  end else if(mul_count==4)begin
    mul_done <= 1'd1;
  end
  else if(mulrdy)begin
    mul_count <= mul_count +1;
  end
end

//prepare output data 
//這部分直接用combinational 電路，並準備輸出
//直接將第一位元做XOR 算出正負號
//進入四捨五入部分，check 相乘後的最高位是否為1，若為1要shift取104:53 的fraction並check看最後一位的後一位是否進位
//若不為1則直接取103:52，再度check最後一位的後一位是否進位
assign output_Z[7][7] = input_A[7][7] ^ input_B[7][7];
assign {output_Z[7][6:0],output_Z[6][7:4]} = (fraction_temp[105])?
       exponent_add[10:0] + 11'd1 : exponent_add[10:0];
assign  {output_Z[6][3:0],output_Z[5][7:0],output_Z[4][7:0],output_Z[3][7:0],
       output_Z[2][7:0],output_Z[1][7:0],output_Z[0][7:0]} 
       = (fraction_temp[105])?
        fraction_temp[104:53] + {51'd0,fraction_temp[52]}:
        fraction_temp[103:52] + {51'd0,fraction_temp[51]};
//////////////////output  part////////////////////
//當收到mul_done訊號後，拉高READY並開始輸出Data，且使用conuter_out準確計算輸出次數及時間，當輸出完成後，將訊號READY 訊號拉下
//output
always@(posedge CLK)begin
  if(RESET)begin
    counter_out <= 4'd0;
  end
  else if(mul_done&&counter_out < 4'd8) begin
    counter_out <= counter_out + 1'b1;
  end
  else begin	
     counter_out<=4'd0;
  end
end
always@(posedge CLK)begin
  if(RESET)begin
    READY <= 1'd0;
  end
  else if(mul_done&&counter_out < 4'd7) begin
    READY <= 1'b1;
  end
  else if(counter_out==4'd7) begin	
    READY <= 1'b0;
  end
end
always@(posedge CLK)begin
  if(RESET)begin
    DATA_OUT <=8'd0;
  end else if(mul_done&&counter_out < 4'd8) begin
    DATA_OUT <= output_Z[counter_out];
  end  
end
endmodule