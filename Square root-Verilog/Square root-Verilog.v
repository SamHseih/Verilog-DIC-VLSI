//------------------------------------------------------//
//- VLSI 2023                                           //
//-                                                     //
//- Exercise: Design a square root circuit              //
//------------------------------------------------------//
// Square Root

module SQRT(
	RST,
	CLK,
	IN_VALID,
	IN,
	OUT_VALID,
	OUT
);
input CLK;
input RST;
input [15:0] IN;
input IN_VALID;
output [11:0] OUT;
output OUT_VALID;

// Write your synthesizable code here
reg  [15:0] X; //catch input && will shift to 0
reg  [16:0] A; //accumulator
reg  [16:0] Q; //square root temp value
//iterator = (Q(12bit)**2=24bit) / 2 == 12 itrtation.
reg  [5:0]  count; 
reg  [11:0] output_value; //before round value
reg  [11:0] out_round; //after round vallue
reg invalid;
reg caculation; 
reg outvalid; //before round
reg done;  //after round
wire [15:0] X_next; //input 16bit
wire signed [16:0] T; //signed test 17bit == 1bit signed 16bit value
wire signed [16:0] A_next;//accumulater 17bit == 1bit signed 16bit value
wire signed [16:0] Q_temp; 
wire [16:0] Q_next; //output 12bit 8bit int ,4bit fixed-point

/////////combinational///////////////
assign A_next[16:2] = (caculation)?A[14:0]:15'd0;
assign A_next[1:0] = (caculation)?X[15:14]:2'd0;
assign X_next = (caculation)? X << 2:16'd0;
assign Q_temp = (Q<<2)+1'b1;
assign T = A_next - Q_temp ;
assign Q_next = (caculation)? (T>=0)?(Q << 1)+1'd1:(Q << 1) :12'd0; 
/////////output/////////
assign OUT_VALID = (done)?1'd1:1'd0;
assign OUT = (OUT_VALID)?out_round:12'd0;

/////////////sequential///////////////
////////signal control//////////
////////input/////////
always@(posedge CLK or posedge RST)begin
  if(RST)begin
    invalid<= 1'b0;
  end
  else if(IN_VALID)begin
    invalid<=1'd1;
  end
  else invalid <=1'd0;
end
/////caculation state////
always@(posedge CLK or posedge RST)begin
  if(RST||done)begin
    caculation <= 1'd0;
  end 
  else if(invalid)begin
    caculation <= 1'd1;
  end
end
////iterate 12 th/////
always@(posedge CLK or posedge RST)begin
  if(RST)begin
    outvalid <= 1'd0;
  end 
  else if(count==11)begin
    outvalid <= 1'd1;
  end
  else if(outvalid)begin
    outvalid <= 1'd0;
  end
end
///////counter///////////
always@(posedge CLK or posedge RST)begin
  if(RST)begin
    count <= 6'b000000;
  end
  else if(caculation)begin
    count <= count +6'd1;
  end
  else count <= 6'b000000;
end
///////round state///////
always@(posedge CLK or posedge RST)begin
  if(RST)begin
    done <= 1'b0;
  end
  else if(outvalid)begin
    done <= 1'd1;
  end
  else done <= 1'b0;
end
////////signal control end////////
/////catch outputvalue//////
always@(posedge CLK or posedge RST)begin
  if(RST||outvalid)begin
    output_value <= 12'd0;
  end
  else if(count==11)begin
    output_value <= Q_next[11:0];
  end 
end

///X = input & next round X///
always@(posedge CLK or posedge RST)begin
  if(RST||done)begin
    X <= 16'd0;
  end
  else if(invalid)begin
    X <= IN;
  end
  else X <= X_next;
end 
/////////Accumulator//////////
always@(posedge CLK or posedge RST)begin
  if(RST||outvalid)begin
    A <= 17'd0;
  end 
  else if(caculation)begin
    if(T>=0)begin
      A <= T;
    end
    else begin
      A <= A_next;
    end
  end
end
/////Square root value////////
always@(posedge CLK or posedge RST)begin
  if(RST||outvalid)begin
    Q <= 17'd0;
  end 
  else if(caculation)begin
    Q <= Q_next;
  end
end
////////////round////////////
///check iteratrion 13th/////
always@(posedge CLK or posedge RST)begin
  if(RST)begin
    out_round <= 12'd0;
  end
  else if(outvalid)begin
    if(Q_next[0]==1)begin
    out_round <= output_value + 12'd1 ;
    end
    else if(Q_next[0]!=1) begin 
    out_round <= output_value;
    end
  end
  else begin
    out_round <= 12'd0; 
  end
end
endmodule