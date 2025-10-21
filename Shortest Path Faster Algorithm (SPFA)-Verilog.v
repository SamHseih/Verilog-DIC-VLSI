./vlsi33.v
//------------------------------------------------------//
//- VLSI 2023                                           //
//-                                                     //
//- Lab10c: Verilog Behavior-Level                      //
//------------------------------------------------------//

module  CHIP(
    CLK,
    RESET,
    IN_VALID,
    IN_DATA,
    OUT_VALID,
    OUT_DATA_X,
    OUT_DATA_Y,
    OUT_DATA_SUM
    );
//input port
input   CLK;
input   RESET;
input   IN_VALID;
input   [7:0]IN_DATA;
//output port
output  OUT_VALID;
output  [3:0]OUT_DATA_X;
output  [3:0]OUT_DATA_Y;
output  [15:0]OUT_DATA_SUM;
/////////////////////////////////
//design your code there/////////
/////////////////////////////////
reg [8:0] distance[0:4][0:4];   //宣告二維mem
reg [2:0] current_x;            //當前x的位置
reg [2:0] current_y;            //當前y的位置
reg outvalid;                   //當計算好時outvalid 拉高 可輸出
reg cal_done;                   //計算完成 calculation 拉高
reg [2:0]out_x;
reg [2:0]out_y;
reg [8:0]out_sum;
integer l,k;
//此作業大致分兩大塊state 分別是輸出、運算一塊，以及輸入distance一塊
//此作業運算及輸出會並行因此直接宣告二維mem，每個對應的x,y的reg都有值後續直接判斷後相加並求最短距離並輸出即可。
/////////////out put state///////////////
assign OUT_VALID = outvalid;  //當outvalid拉起同時將OUTVALID訊號拉起
assign OUT_DATA_X = out_x;  //同時由reg輸出x,y 與累加的distanece
assign OUT_DATA_Y = out_y;
assign OUT_DATA_SUM = out_sum;
always@(posedge CLK )begin 
  if(RESET)begin  //reset  reg
    outvalid<=1'd0;
    out_x <= 3'd0;
    out_y <= 3'd0;
    out_sum <= 8'd0;
  end
  else if(!IN_VALID)begin
    if(cal_done)begin  //判斷是否來在運算當中，若再運算當中，則進入判斷現在的x,y是否在終點。
//x=4,y=4 ; output --> reset 
      if((current_x == 3'd4 && current_y == 3'd4))begin //當x,y走到終點後，輸出最後一筆累加的值，並且同時reset所有值(x從1開始)
//output
        out_x <= current_x;
        out_y <= current_y;
//data reset
        for(l=0;l<5;l=l+1)begin //會寫i k 是因為怕同時用到兩個reg會rece condition的問題 (不知道會不會有)
          for(k=0;k<5;k=k+1)begin
            distance[l][k] <= 9'd0;
          end
        end
        //out_sum <= 9'd0;    //這裡原本想reset 輸出的reg但是會出錯，還不知道為什麼。
        current_x <= 3'd1;
        current_y <= 3'd0;
//signal reset
        outvalid <= 1'd0;
        cal_done <= 1'd0;
      end
//x=0~3 y=0~3; or x=4 y=0~3 or x=0~3 y=4  output
//若未在終點，直接先把當下的x,y，及累加的distance存入要輸出的reg中，並同時拉起outvalid的訊號，準備輸出。
//先灌入reg 是因為怕直接assign給 output 會不穩定，所以先輸入到reg中
      else if((current_x != 3'd4) || (current_y != 3'd4))begin  
        outvalid <= 1'd1;
        out_x <= current_x;
        out_y <= current_y;
        out_sum <= distance[current_x][current_y];
      end 
    end //cal_done
  end //else
end //always
/////////////input state///////////////////
//只要x<=4都會+1並直接橫向輸入到mem中，最後判斷+1後是否超過邊界，若超過則y+1，且x歸零繼續輸入。
//由於x=0,y=0 且 x=4,y=4都是0故從x=1地方開始輸入，且reset的直接是1
//當輸入最後一筆資料的同時，會把x與y歸零，進入求解計算階段。
always@(posedge CLK ) begin
  if(RESET) begin
    for(l=0;l<5;l=l+1)begin
      for(k=0;k<5;k=k+1)begin
        distance[l][k] <= 8'd0;
      end
    end
    current_x <= 3'd1; //x從1開始
    current_y <= 3'd0; 
  end
  else if(IN_VALID) begin
//x=3,y=4 input_done reset x,y
    if(current_x + 1 == 4 && current_y == 4)begin  //輸入最後一筆x=3,y=4同時，此時reset x,y座標以便於下一個clk做計算。
      distance[current_x][current_y] <= IN_DATA;  
      current_x <= 3'd0;  
      current_y <= 3'd0;
    end
    else begin
      distance[current_x][current_y] <= IN_DATA;   
//x=4 --> x=0
      if(current_x + 1 == 5)begin
        current_x <= 3'd0;
        current_y <= current_y + 1;
      end
//x=0,1,2,3,4;
      else
        current_x <= current_x + 1;
    end
  end
end
//此階段判斷x 是否在邊界，在邊界當下直接對同一個方向上或下做+1動作，並加總路徑的值。
//若不在邊界，則判斷y+1上或x+1右的distance哪一個小，小的直接更新mem的值，並同時更新x,y的座標值。
//distance 更新方式直接把現在x,y座標上的reg的值，加到下一個要走的x,y座標的reg的值，並一路加到底最終座標為止。
//cal_done 表示還在計算當中，在計算中不會output, 只會更新x , y座標在output的地方更新
//但應該要寫在同一個always block 不過這時候還不熟悉，這邊等到在輸出完成後才把cal_done拉低。
///////////////calulate////////////////////
always@(posedge CLK )begin
  if(RESET)begin
    cal_done <= 1'd0;
  end
  else if(!IN_VALID)begin 
//x=4,y=0,1,2,3;
    if(current_x==4 && current_y != 4)begin
      distance[current_x][current_y+1] <= distance[current_x][current_y+1] + distance[current_x][current_y];
      current_y <= current_y + 1;
      cal_done <= 1'd1;
    end
//x=0,1,2,3; ,y=4;
    else if(current_x!=4 && current_y == 4)begin
      distance[current_x+1][current_y] <= distance[current_x+1][current_y] + distance[current_x][current_y];
      current_x <= current_x + 1;
      cal_done <= 1'd1;
    end
//x=0,1,2,3; y=0,1,2,3;  right < up
    else if (current_x!=4 && current_y !=4) begin
      if(distance[current_x+1][current_y] > distance[current_x][current_y+1]) begin
        distance[current_x][current_y+1] <= distance[current_x][current_y+1] + distance[current_x][current_y];
        current_y <= current_y + 1;
        cal_done <= 1'd1;
      end
//x=0,1,2,3; y=0,1,2,3;  up < right
      else if(distance[current_x+1][current_y] < distance[current_x][current_y+1]) begin
        distance[current_x+1][current_y] <= distance[current_x+1][current_y] + distance[current_x][current_y];
        current_x <= current_x + 1;
        cal_done <= 1'd1;
      end
    end
  end
end

endmodule