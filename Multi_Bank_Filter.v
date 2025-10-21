./dic29.v
//------------------------------------------------------//
//- Digital IC Design 2023                              //
//-                                                     //
//- Lab06: Logic Synthesis                              //
//------------------------------------------------------//
`timescale 1ns/10ps

module MBF(CLK, RESET, IN_VALID, IN_DATA, X_DATA, Y_DATA, OUT_VALID);

input   CLK;
input   RESET;
input   IN_VALID;

input       [12:0]  IN_DATA;
output  reg [12:0]  X_DATA;
output  reg [12:0]  Y_DATA;
output  reg         OUT_VALID;
//Write Your Design Here

reg [12:0] X [0:11];
wire [4:0] H [0:11];
other

wire [4:0] L [0:11];
reg [27:0] temp_H;
reg [27:0] temp_L;
reg [17:0]mul_product_H[0:11];
reg [17:0]mul_product_L[0:11];
integer i,l;

assign H[0]=5'b01110;      
assign H[1]=5'b00100;     
assign H[2] =5'b00011;  
assign H[3]=5'b00001;     
assign H[4]=5'b10000;      
assign H[5] =5'b01110;   
assign H[6]=5'b11100;     
assign H[7]=5'b10000;      
assign H[8] =5'b11111;
assign H[9]=5'b11100;     
assign H[10]=5'b11111;     
assign H[11]=5'b10001;
assign L[0]=5'b11011;
assign L[1] =5'b10011;
assign L[2] =5'b00101;
assign L[3]=5'b01001;
assign L[4] =5'b10101;
assign L[5] =5'b10001;
assign L[6]=5'b10000;
assign L[7] =5'b10011;
assign L[8] =5'b01011;
assign L[9]=5'b01100; 
assign L[10]=5'b10000;
assign L[11]=5'b11111;
always @(posedge CLK or posedge RESET)begin
  if(RESET) begin
other

    for(l=0;l<12;l=l+1)begin
     X[l] <= 13'd0;
    end
  end
  else if(IN_VALID)begin
    X[0] <= IN_DATA;
    X[1]  <= X[0] ;
    X[2]  <= X[1] ;
    X[3]  <= X[2] ;
    X[4]  <= X[3] ;
    X[5]  <= X[4] ;
    X[6]  <= X[5] ;
    X[7]  <= X[6] ;
    X[8]  <= X[7] ;
    X[9]  <= X[8] ;
other

    X[10] <= X[9] ;
    X[11] <= X[10] ;
  end
  else begin
    X[0] <= 13'd0;
    X[1]  <= X[0] ;
    X[2]  <= X[1] ;
    X[3]  <= X[2] ;
    X[4]  <= X[3] ;
    X[5]  <= X[4] ;
    X[6]  <= X[5] ;
    X[7]  <= X[6] ;
    X[8]  <= X[7] ;
    X[9]  <= X[8] ;
other

    X[10] <= X[9] ;
    X[11] <= X[10] ;

  end
end
always@(posedge CLK or posedge RESET)begin
  if(RESET)begin
other

    for(i=0;i<12;i=i+1)begin
      mul_product_H[i] <= 18'b0;
    end
  end
  else begin
 mul_product_H[0]  <= X[0] * H[0]; 
 mul_product_H[1]  <= X[1] * H[1];
 mul_product_H[2]  <= X[2] * H[2];
 mul_product_H[3]  <= X[3] * H[3];
 mul_product_H[4]  <= X[4] * H[4];
 mul_product_H[5]  <= X[5] * H[5];
 mul_product_H[6]  <= X[6] * H[6];
 mul_product_H[7]  <= X[7] * H[7];
 mul_product_H[8]  <= X[8] * H[8];
 mul_product_H[9]  <= X[9] * H[9];
 mul_product_H[10] <= X[10] * H[10];
 mul_product_H[11] <= X[11] * H[11];

 mul_product_L[0]  <= X[0] * L[0]; 
 mul_product_L[1]  <= X[1] * L[1];
 mul_product_L[2]  <= X[2] * L[2];
 mul_product_L[3]  <= X[3] * L[3];
 mul_product_L[4]  <= X[4] * L[4];
 mul_product_L[5]  <= X[5] * L[5];
 mul_product_L[6]  <= X[6] * L[6];
 mul_product_L[7]  <= X[7] * L[7];
 mul_product_L[8]  <= X[8] * L[8];
 mul_product_L[9]  <= X[9] * L[9];
 mul_product_L[10] <= X[10] * L[10];
 mul_product_L[11] <= X[11] * L[11];
 end
end

always @(posedge CLK or posedge RESET)begin
  if (RESET)begin
    temp_H <= 28'd0;
other

    temp_L <= 28'd0;
  end
  else  begin
    temp_H <= mul_product_H [0]+mul_product_H [1]+mul_product_H [2]+mul_product_H [3]+mul_product_H [4]+mul_product_H [5]+mul_product_H [6]+mul_product_H [7]+mul_product_H [8]+mul_product_H [9]+mul_product_H [10]+mul_product_H [11];
    temp_L <= mul_product_L [0]+mul_product_L [1]+mul_product_L [2]+mul_product_L [3]+mul_product_L [4]+mul_product_L [5]+mul_product_L [6]+mul_product_L [7]+mul_product_L [8]+mul_product_L [9]+mul_product_L [10]+mul_product_L [11];
  end
end
/*
always @(*)begin
  if (RESET)begin
    temp_H = 28'd0;
    temp_L = 28'd0;
  end
  else begin
    temp_H = X[0]*H[0]+ X[1]*H[1]+X[2]*H[2]+X[3]*H[3]+X[4]*H[4]+X[5]*H[5]
        +X[6]*H[6]+X[7]*H[7]+X[8]*H[8]+X[9]*H[9]+X[10]*H[10]+X[11]*H[11];
    temp_L = X[0]*L[0]+ X[1]*L[1]+X[2]*L[2]+X[3]*L[3]+X[4]*L[4]+X[5]*L[5]
        +X[6]*L[6]+X[7]*L[7]+X[8]*L[8]+X[9]*L[9]+X[10]*L[10]+X[11]*L[11];
  end
end
*/
always@(posedge CLK or posedge RESET)begin
  if(RESET)begin
    X_DATA <= 13'b0;
   Y_DATA <= 13'b0;
  end
  else begin
    X_DATA <= temp_H[21:9] +temp_H[8];
    Y_DATA <= temp_L[21:9] +temp_L[8];
  end
end

always@(posedge CLK or posedge RESET)begin
  if(RESET) begin
    OUT_VALID <= 1'b0;
  end
  else if(temp_H != 28'b0 || temp_L != 28'b0)begin
    OUT_VALID <= 1'b1;
  end
  else   
    OUT_VALID <= 1'b0;
  
end
endmodule
