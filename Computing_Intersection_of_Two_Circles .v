//------------------------------------------------------//
//- Digital IC Design 2023                              //
//-                                                     //
//- Lab08: Low-Power Syntheis                           //
//------------------------------------------------------//
`timescale 1ns/10ps

//cadence translate_off
`include "/usr/chipware/CW_mult_n_stage.v"
`include "/usr/chipware/CW_mult.v"
`include "/usr/chipware/CW_pipe_reg.v"
//cadence translate_on

module SET ( clk , rst, en, central, radius, busy, valid, candidate);

input         clk, rst;
input         en;
input  [15:0] central;
input   [7:0] radius;
output        busy;
output        valid;
output  [7:0] candidate;

//Write Your Design Here
//state control & assign can declare
reg [15:0] coord;
reg check[0:8][0:8];
reg check_done; 

//caculate can declare
wire [7:0]  square_temp_r1;
wire [7:0]  square_temp_r2;
wire [7:0]  square_r1;
wire [7:0]  square_r2;

wire [3:0] x [0:8];
wire [3:0] y [0:8];
wire [3:0] subx1[0:8];
wire [3:0] suby1[0:8];
wire [3:0] subx2[0:8];
wire [3:0] suby2[0:8];
wire [7:0] square_x1[0:8];
wire [7:0] square_y1[0:8];
wire [7:0] square_x2[0:8];
wire [7:0] square_y2[0:8];
wire [7:0] square_temp_x1[0:8];
wire [7:0] square_temp_y1[0:8];
wire [7:0] square_temp_x2[0:8];
wire [7:0] square_temp_y2[0:8];
wire [3:0] c1_range_x_min;
wire [3:0] c1_range_x_max;
wire [3:0] c1_range_y_min;
wire [3:0] c1_range_y_max;
integer i,j,k,l;


//state control & assign candidate
assign busy = (check_done!=1'd1&&coord!=0)? 1'b1:1'b0; 
assign valid = (!busy&&check_done==1)? 1'b1:1'b0;
assign candidate = (valid)? 
check[1][1]+check[1][2]+check[1][3]+check[1][4]+check[1][5]+check[1][6]+check[1][7]+check[1][8]+ 
check[2][1]+check[2][2]+check[2][3]+check[2][4]+check[2][5]+check[2][6]+check[2][7]+check[2][8]+ 
check[3][1]+check[3][2]+check[3][3]+check[3][4]+check[3][5]+check[3][6]+check[3][7]+check[3][8]+ 
check[4][1]+check[4][2]+check[4][3]+check[4][4]+check[4][5]+check[4][6]+check[4][7]+check[4][8]+ 
check[5][1]+check[5][2]+check[5][3]+check[5][4]+check[5][5]+check[5][6]+check[5][7]+check[5][8]+ 
check[6][1]+check[6][2]+check[6][3]+check[6][4]+check[6][5]+check[6][6]+check[6][7]+check[6][8]+ 
check[7][1]+check[7][2]+check[7][3]+check[7][4]+check[7][5]+check[7][6]+check[7][7]+check[7][8]+ 
check[8][1]+check[8][2]+check[8][3]+check[8][4]+check[8][5]+check[8][6]+check[8][7]+check[8][8] :8'd0;
always@(posedge clk or posedge rst)begin
  if(rst) begin
    coord <= 16'd0;
  end
  else if(valid)begin
    coord <=16'd0;
  end
  else if(en)begin
      coord <= central;
  end
end
//caculate circle range of choice 
assign c1_range_x_min = (central[15:12] < radius[7:4])?4'b0:central[15:12] - radius[7:4];
assign c1_range_x_max = (central[15:12] + radius[7:4]>=4'b1000)?4'b1000:central[15:12] + radius[7:4];
assign c1_range_y_min = (central[11:8] < radius[7:4])?4'b0:central[11:8] - radius[7:4];
assign c1_range_y_max = (central[11:8] + radius[7:4]>=4'b1000)?4'b1000:central[11:8] + radius[7:4];

always@(posedge clk or posedge rst)begin
  if(rst)begin
    check_done <=1'd0;
   for(l=0;l<9;l=l+1)begin
    for(k=0;k<9;k=k+1)begin
    check[l][k]<=1'd0;
    end
   end
  end
  else if(valid)begin
    for(i=0;i<9;i=i+1)begin
      for(j=0;j<9;j=j+1)begin
      check[i][j]<=1'd0;
      end
     end
    check_done <= 1'd0;
  end
  else if(square_y2[8]!=0||square_x2[8]!=0) begin
   for(i=0;i<9;i=i+1)begin
    for(j=0;j<9;j=j+1)begin
       if(c1_range_y_min<=j && j<=c1_range_y_max && c1_range_x_min <= i && i<=c1_range_x_max)begin
         check[i][j] <=((square_x1[i] + square_y1[j]) <= square_r1)? ((square_x2[i] + square_y2[j]) <= square_r2)?1'b1:1'b0  :1'b0 ;
         check_done <= 1'd1;
        $display("check[%d][%d]=%d\nsquare_x1[%d]=%d square_y1[%d]=%d square_r1=%d\nsquare_x2[%d]=%d square_y2[%d]=%d square_r2 =%d",i,j,check[i][j],i,square_x1[i],j,square_y1[j],square_r1,i,square_x2[i],j,square_y2[j],square_r2);
       end
    end
   end
  end
end
//

//assign coordinate value
assign x[0] = (coord!=0)?4'd0:4'd0;
assign x[1] = (coord!=0)?4'd1:4'd0;
assign x[2] = (coord!=0)?4'd2:4'd0;
assign x[3] = (coord!=0)?4'd3:4'd0;
assign x[4] = (coord!=0)?4'd4:4'd0;
assign x[5] = (coord!=0)?4'd5:4'd0;
assign x[6] = (coord!=0)?4'd6:4'd0;
assign x[7] = (coord!=0)?4'd7:4'd0;
assign x[8] = (coord!=0)?4'd8:4'd0;
assign y[0] = (coord!=0)?4'd0:4'd0;
assign y[1] = (coord!=0)?4'd1:4'd0;
assign y[2] = (coord!=0)?4'd2:4'd0;
assign y[3] = (coord!=0)?4'd3:4'd0;
assign y[4] = (coord!=0)?4'd4:4'd0;
assign y[5] = (coord!=0)?4'd5:4'd0;
assign y[6] = (coord!=0)?4'd6:4'd0;
assign y[7] = (coord!=0)?4'd7:4'd0;
assign y[8] = (coord!=0)?4'd8:4'd0;
//caculate  (x-c1_x) (y-c1_y)
assign subx1[0]=$abs($signed(x[0])- $signed(coord[15:12]));
assign subx1[1]=$abs($signed(x[1])- $signed(coord[15:12]));
assign subx1[2]=$abs($signed(x[2])- $signed(coord[15:12]));
assign subx1[3]=$abs($signed(x[3])- $signed(coord[15:12]));
assign subx1[4]=$abs($signed(x[4])- $signed(coord[15:12]));
assign subx1[5]=$abs($signed(x[5])- $signed(coord[15:12]));
assign subx1[6]=$abs($signed(x[6])- $signed(coord[15:12]));
assign subx1[7]=$abs($signed(x[7])- $signed(coord[15:12]));
assign subx1[8]=$abs($signed(x[8])- $signed(coord[15:12]));

assign suby1[0]=$abs($signed(y[0])- $signed(coord[11:8]));
assign suby1[1]=$abs($signed(y[1])- $signed(coord[11:8]));
assign suby1[2]=$abs($signed(y[2])- $signed(coord[11:8]));
assign suby1[3]=$abs($signed(y[3])- $signed(coord[11:8]));
assign suby1[4]=$abs($signed(y[4])- $signed(coord[11:8]));
assign suby1[5]=$abs($signed(y[5])- $signed(coord[11:8]));
assign suby1[6]=$abs($signed(y[6])- $signed(coord[11:8]));
assign suby1[7]=$abs($signed(y[7])- $signed(coord[11:8]));
assign suby1[8]=$abs($signed(y[8])- $signed(coord[11:8]));

assign subx2[0]=$abs($signed(x[0])- $signed(coord[7:4]));
assign subx2[1]=$abs($signed(x[1])- $signed(coord[7:4]));
assign subx2[2]=$abs($signed(x[2])- $signed(coord[7:4]));
assign subx2[3]=$abs($signed(x[3])- $signed(coord[7:4]));
assign subx2[4]=$abs($signed(x[4])- $signed(coord[7:4]));
assign subx2[5]=$abs($signed(x[5])- $signed(coord[7:4]));
assign subx2[6]=$abs($signed(x[6])- $signed(coord[7:4]));
assign subx2[7]=$abs($signed(x[7])- $signed(coord[7:4]));
assign subx2[8]=$abs($signed(x[8])- $signed(coord[7:4]));

assign suby2[0]=$abs($signed(y[0])- $signed(coord[3:0]));
assign suby2[1]=$abs($signed(y[1])- $signed(coord[3:0]));
assign suby2[2]=$abs($signed(y[2])- $signed(coord[3:0]));
assign suby2[3]=$abs($signed(y[3])- $signed(coord[3:0]));
assign suby2[4]=$abs($signed(y[4])- $signed(coord[3:0]));
assign suby2[5]=$abs($signed(y[5])- $signed(coord[3:0]));
assign suby2[6]=$abs($signed(y[6])- $signed(coord[3:0]));
assign suby2[7]=$abs($signed(y[7])- $signed(coord[3:0]));
assign suby2[8]=$abs($signed(y[8])- $signed(coord[3:0]));
//square r
CW_mult_n_stage #(4,4,3) C1_square_r1(.A(radius[7:4]),.B(radius[7:4]),.TC(1'b0),.CLK(clk),.Z(square_temp_r1));
CW_mult_n_stage #(4,4,3) C2_square_r2(.A(radius[3:0]),.B(radius[3:0]),.TC(1'b0),.CLK(clk),.Z(square_temp_r2));
//square x,y
CW_mult_n_stage #(4,4,3) C1_square_x0(.A(subx1[0]),.B(subx1[0]),.TC(1'b0),.CLK(clk),.Z(square_temp_x1[0]));
CW_mult_n_stage #(4,4,3) C1_square_x1(.A(subx1[1]),.B(subx1[1]),.TC(1'b0),.CLK(clk),.Z(square_temp_x1[1]));
CW_mult_n_stage #(4,4,3) C1_square_x2(.A(subx1[2]),.B(subx1[2]),.TC(1'b0),.CLK(clk),.Z(square_temp_x1[2]));
CW_mult_n_stage #(4,4,3) C1_square_x3(.A(subx1[3]),.B(subx1[3]),.TC(1'b0),.CLK(clk),.Z(square_temp_x1[3]));
CW_mult_n_stage #(4,4,3) C1_square_x4(.A(subx1[4]),.B(subx1[4]),.TC(1'b0),.CLK(clk),.Z(square_temp_x1[4]));
CW_mult_n_stage #(4,4,3) C1_square_x5(.A(subx1[5]),.B(subx1[5]),.TC(1'b0),.CLK(clk),.Z(square_temp_x1[5]));
CW_mult_n_stage #(4,4,3) C1_square_x6(.A(subx1[6]),.B(subx1[6]),.TC(1'b0),.CLK(clk),.Z(square_temp_x1[6]));
CW_mult_n_stage #(4,4,3) C1_square_x7(.A(subx1[7]),.B(subx1[7]),.TC(1'b0),.CLK(clk),.Z(square_temp_x1[7]));
CW_mult_n_stage #(4,4,3) C1_square_x8(.A(subx1[8]),.B(subx1[8]),.TC(1'b0),.CLK(clk),.Z(square_temp_x1[8]));

CW_mult_n_stage #(4,4,3) C1_square_y0(.A(suby1[0]),.B(suby1[0]),.TC(1'b0),.CLK(clk),.Z(square_temp_y1[0]));
CW_mult_n_stage #(4,4,3) C1_square_y1(.A(suby1[1]),.B(suby1[1]),.TC(1'b0),.CLK(clk),.Z(square_temp_y1[1]));
CW_mult_n_stage #(4,4,3) C1_square_y2(.A(suby1[2]),.B(suby1[2]),.TC(1'b0),.CLK(clk),.Z(square_temp_y1[2]));
CW_mult_n_stage #(4,4,3) C1_square_y3(.A(suby1[3]),.B(suby1[3]),.TC(1'b0),.CLK(clk),.Z(square_temp_y1[3]));
CW_mult_n_stage #(4,4,3) C1_square_y4(.A(suby1[4]),.B(suby1[4]),.TC(1'b0),.CLK(clk),.Z(square_temp_y1[4]));
CW_mult_n_stage #(4,4,3) C1_square_y5(.A(suby1[5]),.B(suby1[5]),.TC(1'b0),.CLK(clk),.Z(square_temp_y1[5]));
CW_mult_n_stage #(4,4,3) C1_square_y6(.A(suby1[6]),.B(suby1[6]),.TC(1'b0),.CLK(clk),.Z(square_temp_y1[6]));
CW_mult_n_stage #(4,4,3) C1_square_y7(.A(suby1[7]),.B(suby1[7]),.TC(1'b0),.CLK(clk),.Z(square_temp_y1[7]));
CW_mult_n_stage #(4,4,3) C1_square_y8(.A(suby1[8]),.B(suby1[8]),.TC(1'b0),.CLK(clk),.Z(square_temp_y1[8]));

CW_mult_n_stage #(4,4,3) C2_square_x0(.A(subx2[0]),.B(subx2[0]),.TC(1'b0),.CLK(clk),.Z(square_temp_x2[0]));
CW_mult_n_stage #(4,4,3) C2_square_x1(.A(subx2[1]),.B(subx2[1]),.TC(1'b0),.CLK(clk),.Z(square_temp_x2[1]));
CW_mult_n_stage #(4,4,3) C2_square_x2(.A(subx2[2]),.B(subx2[2]),.TC(1'b0),.CLK(clk),.Z(square_temp_x2[2]));
CW_mult_n_stage #(4,4,3) C2_square_x3(.A(subx2[3]),.B(subx2[3]),.TC(1'b0),.CLK(clk),.Z(square_temp_x2[3]));
CW_mult_n_stage #(4,4,3) C2_square_x4(.A(subx2[4]),.B(subx2[4]),.TC(1'b0),.CLK(clk),.Z(square_temp_x2[4]));
CW_mult_n_stage #(4,4,3) C2_square_x5(.A(subx2[5]),.B(subx2[5]),.TC(1'b0),.CLK(clk),.Z(square_temp_x2[5]));
CW_mult_n_stage #(4,4,3) C2_square_x6(.A(subx2[6]),.B(subx2[6]),.TC(1'b0),.CLK(clk),.Z(square_temp_x2[6]));
CW_mult_n_stage #(4,4,3) C2_square_x7(.A(subx2[7]),.B(subx2[7]),.TC(1'b0),.CLK(clk),.Z(square_temp_x2[7]));
CW_mult_n_stage #(4,4,3) C2_square_x8(.A(subx2[8]),.B(subx2[8]),.TC(1'b0),.CLK(clk),.Z(square_temp_x2[8]));

CW_mult_n_stage #(4,4,3) C2_square_y0(.A(suby2[0]),.B(suby2[0]),.TC(1'b0),.CLK(clk),.Z(square_temp_y2[0]));
CW_mult_n_stage #(4,4,3) C2_square_y1(.A(suby2[1]),.B(suby2[1]),.TC(1'b0),.CLK(clk),.Z(square_temp_y2[1]));
CW_mult_n_stage #(4,4,3) C2_square_y2(.A(suby2[2]),.B(suby2[2]),.TC(1'b0),.CLK(clk),.Z(square_temp_y2[2]));
CW_mult_n_stage #(4,4,3) C2_square_y3(.A(suby2[3]),.B(suby2[3]),.TC(1'b0),.CLK(clk),.Z(square_temp_y2[3]));
CW_mult_n_stage #(4,4,3) C2_square_y4(.A(suby2[4]),.B(suby2[4]),.TC(1'b0),.CLK(clk),.Z(square_temp_y2[4]));
CW_mult_n_stage #(4,4,3) C2_square_y5(.A(suby2[5]),.B(suby2[5]),.TC(1'b0),.CLK(clk),.Z(square_temp_y2[5]));
CW_mult_n_stage #(4,4,3) C2_square_y6(.A(suby2[6]),.B(suby2[6]),.TC(1'b0),.CLK(clk),.Z(square_temp_y2[6]));
CW_mult_n_stage #(4,4,3) C2_square_y7(.A(suby2[7]),.B(suby2[7]),.TC(1'b0),.CLK(clk),.Z(square_temp_y2[7]));
CW_mult_n_stage #(4,4,3) C2_square_y8(.A(suby2[8]),.B(suby2[8]),.TC(1'b0),.CLK(clk),.Z(square_temp_y2[8]));
// valid vlean square x y
assign square_r1 = (valid ^ busy)?square_temp_r1:8'd0;
assign square_r2 = (valid ^ busy)?square_temp_r2:8'd0;


assign square_x1[0] = (valid ^ busy)?square_temp_x1[0]:8'd0;
assign square_x1[1] = (valid ^ busy)?square_temp_x1[1]:8'd0;
assign square_x1[2] = (valid ^ busy)?square_temp_x1[2]:8'd0;
assign square_x1[3] = (valid ^ busy)?square_temp_x1[3]:8'd0;
assign square_x1[4] = (valid ^ busy)?square_temp_x1[4]:8'd0;
assign square_x1[5] = (valid ^ busy)?square_temp_x1[5]:8'd0;
assign square_x1[6] = (valid ^ busy)?square_temp_x1[6]:8'd0;
assign square_x1[7] = (valid ^ busy)?square_temp_x1[7]:8'd0;
assign square_x1[8] = (valid ^ busy)?square_temp_x1[8]:8'd0;

assign square_y1[0] = (valid ^ busy)?square_temp_y1[0]:8'd0;
assign square_y1[1] = (valid ^ busy)?square_temp_y1[1]:8'd0;
assign square_y1[2] = (valid ^ busy)?square_temp_y1[2]:8'd0;
assign square_y1[3] = (valid ^ busy)?square_temp_y1[3]:8'd0;
assign square_y1[4] = (valid ^ busy)?square_temp_y1[4]:8'd0;
assign square_y1[5] = (valid ^ busy)?square_temp_y1[5]:8'd0;
assign square_y1[6] = (valid ^ busy)?square_temp_y1[6]:8'd0;
assign square_y1[7] = (valid ^ busy)?square_temp_y1[7]:8'd0;
assign square_y1[8] = (valid ^ busy)?square_temp_y1[8]:8'd0;

assign square_x2[0] = (valid ^ busy)?square_temp_x2[0]:8'd0;
assign square_x2[1] = (valid ^ busy)?square_temp_x2[1]:8'd0;
assign square_x2[2] = (valid ^ busy)?square_temp_x2[2]:8'd0;
assign square_x2[3] = (valid ^ busy)?square_temp_x2[3]:8'd0;
assign square_x2[4] = (valid ^ busy)?square_temp_x2[4]:8'd0;
assign square_x2[5] = (valid ^ busy)?square_temp_x2[5]:8'd0;
assign square_x2[6] = (valid ^ busy)?square_temp_x2[6]:8'd0;
assign square_x2[7] = (valid ^ busy)?square_temp_x2[7]:8'd0;
assign square_x2[8] = (valid ^ busy)?square_temp_x2[8]:8'd0;

assign square_y2[0] = (valid ^ busy)?square_temp_y2[0]:8'd0;
assign square_y2[1] = (valid ^ busy)?square_temp_y2[1]:8'd0;
assign square_y2[2] = (valid ^ busy)?square_temp_y2[2]:8'd0;
assign square_y2[3] = (valid ^ busy)?square_temp_y2[3]:8'd0;
assign square_y2[4] = (valid ^ busy)?square_temp_y2[4]:8'd0;
assign square_y2[5] = (valid ^ busy)?square_temp_y2[5]:8'd0;
assign square_y2[6] = (valid ^ busy)?square_temp_y2[6]:8'd0;
assign square_y2[7] = (valid ^ busy)?square_temp_y2[7]:8'd0;
assign square_y2[8] = (valid ^ busy)?square_temp_y2[8]:8'd0;

endmodule