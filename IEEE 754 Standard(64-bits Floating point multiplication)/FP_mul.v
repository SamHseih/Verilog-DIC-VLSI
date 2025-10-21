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

//Parameter
//parameter fp_latency=3;

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
reg     [4:0] counter_in;    //數目前input的進度
reg     [7:0] input_A [0:7]; 
reg     [7:0] input_B [0:7];
reg           in_data_rdy;   //input完成確認線
//output
reg     [7:0] output_Z [0:7];//合併signed exponent fraction 最終要輸出的output
reg     [7:0] DATA_OUT;      
reg     [3:0] counter_out;   //數目前output的進度
integer       i,j;
//signed_part
reg     signed_part;         //運用XOR算此值
//exponent
reg     [11:0] exponent_add; //兩個exponent相加
reg     exponent_round;      //判斷是否進位
//fraction
reg     [51:0]fraction;      //抓取52bit
reg    [52:0] inpA,inpB;     //將inputA inputB取下fraction part
wire    [105:0] fraction_mul;//相乘後得結果
//signal
reg     add_done;  // done rise was 0  after add 1 
reg [3:0]mul_count;//計算相乘後的clk
reg     mulrdy ;   //相乘完畢的信號
reg     mul_done;  // done rise was 0  after mul 1 
reg     round_done;// done rise was 0  after round 1 
reg     done;      //total data ready 
////////////////input part///////////////////////
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
  if(RESET||add_done) begin
     counter_in <= 0;
  end else if (ENABLE && (counter_in < 5'd15) ) begin
     counter_in <= counter_in + 1'b1;
  end
end
always@(posedge CLK)begin
  if(RESET||done) begin
     for(i=0; i <= 7; i=i+1) input_A[i] <= 0;
     for(j=0; j <= 7; j=j+1) input_B[j] <= 0;
  end else if (ENABLE && (counter_in < 5'd8) ) begin
     input_A[counter_in] <= DATA_IN;
  end else if (ENABLE && (counter_in <= 5'd15) ) begin
     input_B[counter_in-8] <= DATA_IN;
  end
end
////////////////signed_part//////////////////////
//直接運用XOR計算 signed部分
always@(posedge CLK)begin
  if(RESET||done)begin
    signed_part <=1'd0;
  end else if(in_data_rdy)begin
    signed_part <= input_A[7][7] ^ input_B[7][7];
  end
end
////////////////exponent part ///////////////////
//指數部分當input data 準備好後，直接將Input_A與Input_B的部分相加並扣除bias部分存入exponent reg。
//相加完成後將add_done拉高，若相乘完成後並拉低。
//當輸出完成後再把 exonent reset
always@(posedge CLK)begin
  if(RESET||mul_done)begin
    add_done <= 1'd0;
  end
  else if(in_data_rdy)begin
    add_done <= 1'd1;
  end
end
always@(posedge CLK)begin
  if(RESET)begin
    exponent_add <= 12'd0;
  end
  else if(counter_out == 4'd8)begin
    exponent_add <= 12'd0;
  end
  else if(in_data_rdy)begin
    exponent_add <= {input_A[7][6:0],input_A[6][7:4]} + {input_B[7][6:0],input_B[6][7:4]} - 12'b0001111111111;
  end
end
////////////////fraction  part///////////////////
//這邊事先將input_A與input_B的fraction取下，並放入inpA與inpB
//放入完成拉高 mulrdy線，當成法結束 reset 線與暫存器
always@(posedge CLK)begin
  if(RESET||mul_done)begin
    inpA <= 52'd0;
    inpB <= 52'd0;
    mulrdy <= 1'd0;
  end else if(add_done)begin
      inpA[7:0]   <= input_A[0];
      inpA[15:8]  <= input_A[1];
      inpA[23:16] <= input_A[2];
      inpA[31:24] <= input_A[3];
      inpA[39:32] <= input_A[4];
      inpA[47:40] <= input_A[5];
      inpA[51:48] <= input_A[6][3:0];
      inpA[52]    <= 1'd1;
      inpB[7:0]   <= input_B[0];
      inpB[15:8]  <= input_B[1];
      inpB[23:16] <= input_B[2];
      inpB[31:24] <= input_B[3];
      inpB[39:32] <= input_B[4];
      inpB[47:40] <= input_B[5];
      inpB[51:48] <= input_B[6][3:0];
      inpB[52]    <= 1'd1;
      mulrdy <= 1'd1;
  end
end
//然後運用chipware 相乘 fraction part，且設定為5個週期，避免timeingviolation
//運用 mul_count計算週期，並等待抓值
//最後將mul_done拉高，在四捨五入後再拉低。
//mul  part and control stage
CW_mult_n_stage #(53,53,5) mulfraction(.A(inpA),.B(inpB),.TC(1'b0),.CLK(CLK),.Z(fraction_mul));
always@(posedge CLK)begin
  if(RESET||round_done)begin
    mul_count <= 4'd0;
    mul_done <= 1'd0;
  end
  else if(mul_count==4)begin
    mul_done <= 1'd1;
  end
  else if(mulrdy)begin
    mul_count <= mul_count +1;
  end
end
//////////////////round part/////////////////////
//當mul_done拉高後，進入四捨五入部分，check 相乘後的最高位是否為1，若為1要shift取104:53 的fraction並check看最後一位的後一位是否進位
//若不為1則直接取103:52，再度check最後一位的後一位是否進位
always@(posedge CLK)begin
  if(RESET||done)begin
    fraction <= 52'd0;
    round_done <= 1'd0;
    exponent_round <= 1'd0;
  end 
  else if(mul_done)begin 
    if(fraction_mul[105] == 1'd0)begin
      fraction <= fraction_mul[103:52] + {51'd0,fraction_mul[51]};
      exponent_round <= 1'd0;
      round_done <= 1'd1;
    end
    else begin
      fraction <= fraction_mul[104:53] + {51'd0,fraction_mul[52]};
      exponent_round <= 1'd1;
      round_done <= 1'd1;
    end
  end
end
//////////////////output  part///////////////////
//output前的一個clk合併所有的part，匯集成output_Z，並拉高done 訊號進行後續output，以及重製之前的data
//prepare output data when round_done ==1
always@(posedge CLK)begin
  if(RESET)begin
    for(i=0; i <= 7; i=i+1) output_Z[i] <= 0;
  end
  else if (counter_out == 4'd8) begin 
    for(i=0; i <= 7; i=i+1) output_Z[i] <= 0;
  end
  else if(round_done)begin
     output_Z[7][7] <= signed_part;
    {output_Z[7][6:0],output_Z[6][7:4]} <= exponent_add[10:0] + {10'd0,exponent_round};
    {output_Z[6][3:0],output_Z[5][7:0],output_Z[4][7:0],output_Z[3][7:0],output_Z[2][7:0],output_Z[1][7:0],output_Z[0][7:0]} <= fraction;
  end
end
//done rise when round_done == 1
always@(posedge CLK)begin
  if(RESET)begin
    done <= 1'd0;
  end
  else if(counter_out == 4'd7)begin
    done <= 1'd0;
  end
  else if(round_done)begin  
    done <= 1'd1;
  end
end
//當收到done訊號後，拉高READY並開始輸出Data，且使用conuter_out準確計算輸出次數及時間，當輸出完成後，將訊號READY 訊號拉下
//output
always@(posedge CLK)begin
  if(RESET)begin
    counter_out <= 4'd0;
  end
  else if(done&&counter_out < 4'd8) begin
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
  else if(done&&counter_out < 4'd7) begin
    READY <= 1'b1;
  end
  else if(counter_out==4'd7) begin	
    READY <= 1'b0;
  end
end
always@(posedge CLK)begin
  if(RESET)begin
    DATA_OUT <=8'd0;
  end
  else if(done&&counter_out < 4'd8) begin
    DATA_OUT <= output_Z[counter_out];
  end  
end
endmodule