//-------------------------------------------------------------------------//
//-- Digital IC Design 2023                                              --//
//-- Lab03b: Verilog Gate Level                                          --//
//-------------------------------------------------------------------------//

`timescale 1ns/10ps

module lab03b(a, b, c, out);
  input [7:0] a, b, c;
  output [15:0] out;

//Examples to instantiate the cells from cell library
//AND2X1 u1(output1,a,b);

//** Add your code below this line **//
  //ADDFX4 ADDf1(w11, c3, w9, w10, c1);
  wire [7:0] S;
  wire [15:0] t;
  wire co;

//a+b
ADDHX4 top(S, co, a, b);
//(a+b)*c
//out[0]
AND2X4 and1(t[0], S[0], c[0]);
//temp[1]
AND2X4 and2 (w1, S[1], c[0]);
AND2X4 and3 (w2, S[0], c[1]); 
ADDHX4 ADDh1(t[1], co, wl, w2); 
//temp[2]
AND2X4 and4 (w3, S[2], c[0]); 
AND2X4 and5 (w4, S[1], c[1]); 
ADDHX4 ADDh2 (w5, c1, w4, w3); 
AND2X4 and6 (w6, S[0], c[2]);
ADDFX4 ADDf1(t[2], c2, w5, w6, c0);
//temp[3]
AND2X4 and7 (w7, S[3], c[0]);
AND2X4 and8 (w8, S[2], c[1]);
ADDHX4 ADDh3 (w9, c3, w4, w3);
AND2X4 and9 (w10, S[1], c[2]);
ADDFX4 ADDf2 (w11, c4, w9, w10, c1); 
AND2X4 and10 (w12, S[0], c[3]);
ADDFX4 ADDf3 (t[3], c5, w11, w12, c2); 
//temp[4]
AND2X4 and11 (w13, S[4], c[0]); 
AND2X4 and12 (w14, S[3], c[1]); 
ADDHX4 ADDh4 (w15, c6, w14, w13); 
AND2X4 and13 (w16, S[2], c[2]); 
ADDFX4 ADDf4 (w17, c7, w15, w16, c3); 
AND2X4 and14 (w18, S[1], c[3]);
ADDFX4 ADDf5 (w19, c8, w11, w12, c4); 
AND2X4 and15 (w20, S[0], c[4]);
ADDFX4 ADDf6(t [4], c9, w11, w12, c5); 
//temp[5]
AND2X4 and16 (w21, S[5], c[0]); 
AND2X4 and17 (w22, S[4], c[1]); 
ADDHX4 ADDh5 (w23, c6, w21, w22); 
AND2X4 and18 (w24, S[3], c[2]); 
ADDFX4 ADDf7 (w25, c11, w23, w24, c6); 
AND2X4 and19 (w26, S[2], c[3]);
ADDFX4 ADDf8 (w27, c12, w25, w26, c7); 
AND2X4 and20 (w28, S[1], c[4]);
ADDFX4 ADDf9 (w29, c13, w27, w28, c8); 
AND2X4 and21 (w30, S[0], c[5]);
ADDFX4 ADDf10 (t[5], c14, w29, w30, c9);
//temp [6]
AND2X4 and22 (w31, S[6], c[0]);
AND2X4 and23 (w32, S[5], c[1]);
ADDHX4 ADDh6 (w33, c15, w31, w32); 
AND2X4 and24 (w34, S[4], c[2]);
ADDFX4 ADDf11 (w35, c16, w33, w34, c10);
AND2X4 and25 (w36, S[3], c[3]);
ADDFX4 ADDf12 (w37, c17, w35, w36, c11); 
AND2X4 and26 (w38, S[2], c[4]);
ADDFX4 ADDf13 (w39, c18, w37, w38, c12); 
AND2X4 and27 (w40, S[1], c[5]);
ADDFX4 ADDf14 (w41, c19, w39, w40, c13); 
AND2X4 and28 (w42, S[0], c[6]);
ADDFX4 ADDf15 (t[6], c20, w41, w42, c14); 
//temp [7]
AND2X4 and29 (w43, [7], c[0]);
AND2X4 and30 (w44, S[6], c[1]); 
ADDHX4 ADDh7 (w45, c21, w43, w44); 
AND2X4 and31 (w46, S[5], c[2]);
ADDFX4 ADDf16 (w47, c22, w45, w46, c15); 
AND2X4 and32 (w48, S[4], c[3]);
ADDFX4 ADDf17 (w49, c23, w47, w48, c16); 
AND2X4 and33 (w50, S[3], c[4]);
ADDFX4 ADDf18 (w51, c24, w49, w50, c17); 
AND2X4 and34 (w52, S[2], c[5]);
ADDFX4 ADDf19 (w53, c25, w51, w52, c18); 
AND2X4 and35 (w54, S[1], c[6]);
ADDFX4 ADDf20 (w55, c26, w53, w54, c19); 
AND2X4 and36 (w56, S[0], c[7]);
ADDFX4 ADDf21(t [7], c27, w55, w56, c20); 
//temp[8]
AND2X4 and37 (w57, S[7], c[1]);
AND2X4 and38 (w58, S[6], c[2]);
ADDFX4 ADDf22 (w59, c28, w57, w58, c21); 
AND2X4 and39 (w60, S[5], c[3]);
ADDFX4 ADDf23 (w61, c29, w59, w60, c22); 
AND2X4 and40 (w62, S[4], c[4]);
ADDFX4 ADDf24 (w63, c30, w61, w62, c23); 
AND2X4 and41 (w64, S[3], c[5]);
ADDFX4 ADDf25 (w65, c31, w63, w64, c24); 
AND2X4 and42 (w66, S[2], c[6]);
ADDFX4 ADDf26 (w67, c32, w65, w66, c25); 
AND2X4 and43 (w68, S[1], c[7]);
ADDFX4 ADDf27 (w69, c33, w67, w68, c26);
ADDHX4 ADDh8 (t [8], c34,w69, c27);
//temp[9]
AND2X4 and44 (w70, S[7],c[2]);
AND2X4 and45 (w71, S[6], c[3]);
ADDFX4 ADDf28 (w72, c35, w70, w71, c28);
AND2X4 and46 (w73, S[5], c[4]);
ADDFX4 ADDf29 (w74, c36, w72, w73, c29);
AND2X4 and47 (w75, S[4], c[5]);
ADDFX4 ADDf30 (w76, c37,w74, w75, c30);
AND2X4 and48 (w77, S[3], c[6]);
ADDFX4 ADDf31 (w78, c38, w76, w77, c31); 
AND2X4 and49 (w79, S[2], c[7]);
ADDFX4 ADDf32 (w80, c39, w78, w79, c32); 
ADDFX4 ADDf33 (t[9], c40, w80, c33, c34); 
//temp[10]
//temp[10]|
AND2X4 and50 (w81, S[7], c[3]); 
AND2X4 and51 (w82, S[6], c[4]);
ADDFX4 ADDf34 (w83, c41, w81, w82, c35); 
AND2X4 and52 (w84, S[5], c[5]);
ADDFX4 ADDf35 (w85, c42, w83, w84, c36); 
AND2X4 and53 (w86, S[4], c[6]);
ADDFX4 ADDf36 (w87, c43, w85, w86, c37); 
AND2X4 and54 (w88, S[3], c[7]);
ADDFX4 ADDf37 (w89, c44, w87, w88, c38); 
ADDFX4 ADDf38(t [10], c45, w89, c39, c40); 
//temp[11]
AND2X4 and55 (w90, S[7], c[4]);
AND2X4 and56 (w91, S[6], c[5]);
ADDFX4 ADDf39 (w92, c46, w90, w91, c41); 
AND2X4 and57 (w93, S[5], c[6]);
ADDFX4 ADDf40 (w94, c47, w92, w93, c42); 
AND2X4 and58 (w95, S[4], c[7]);
ADDFX4 ADDf41 (w96, c48, w94, w95, c43); 
ADDFX4 ADDf42 (t [11], c49, w96, c44, c45); 
//temp[12]
AND2X4 and59 (w97, S[7], c[5]);
AND2X4 and60 (w98, S[6], c[6]);
ADDFX4 ADDf43 (w99, c50, w97, w98, c46); 
AND2X4 and61 (w100, S[5], c[7]);
ADDFX4 ADDf44 (w101, c51, w99, w100, c47); 
ADDFX4 ADDf45 (t [12], c52, w101, c48, c49); 
//temp[13]
AND2X4 and62 (w102, S[7], c[7]);
AND2X4 and63 (w103, S[6], c[6]);
ADDFX4 ADDf46 (w104, c53, w102, w103, c50); 
ADDFX4 ADDf47 (t [13], c54, w104, c51, c52); 
//temp[14], t[15]
AND2X4 and64 (w105, S[7], c[7]);
ADDFX4 ADDf48 (t [14], t[15], w105, c53, c54); 
//((a+b) *c)/2
//((a+b)*c)/2
AND2X4 and00 (out[0], t[2], 1); 
AND2X4 and01 (out [1], t[3], 1); 
AND2X4 and02 (out [2], [4], 1); 
AND2X4 and03 (out [3], t[5], 1); 
AND2X4 and04 (out [4], t[6], 1); 
AND2X4 and05 (out [5], t[7], 1); 
AND2X4 and06 (out [6], [8], 1); 
AND2X4 and07 (out [7], t[9], 1); 
AND2X4 and08 (out [8], t[10],1); 
AND2X4 and09 (out [9], t[11], 1); 
AND2X4 and010 (out [10], t[12],1); 
AND2X4 and011 (out [11], t[13], 1); 
AND2X4 and012 (out [12], t[14], 1); 
AND2X4 and013 (out [13], t[15], 1); 
AND2X4 and014 (out [14], t[1],0); 
AND2X4 and015 (out [15], t[0],0);
endmodule