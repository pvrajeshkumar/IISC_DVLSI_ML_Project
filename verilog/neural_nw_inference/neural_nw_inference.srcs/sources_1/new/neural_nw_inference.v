`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2024 00:00:43
// Design Name: 
// Module Name: neural_nw_inference
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module neural_nw_inference( clk, rst, start, test_img, done, prediction );
input clk;
input rst;
input start;
input [0:255] test_img;
output reg done;
output reg [0:3] prediction;

//Configuration parameters based on the trained data
parameter INP_IMG_PIXELS      =   8'd256;
parameter HIDDEN_NODES        =   8'd40;
parameter OUTP_NODES          =   8'd10;

//Weights, Biases Matrix sizes based on Hidden Nodes, Output Nodes
//				       [h x pix ]   [pix x 1]
//z2 = w12 x a1 ====== [40 x 256] * [256 x 1]   ===== [40 x 1]
//So, RELU(z2) is a2  ===== [40 x 1]
//				       [OP x h ]    [h x 1]
//z3 = w23 x a2 ====== [10 x 40]  * [40 x 1]   ===== [10 x 1]
//So, RELU(z3) is a3  ===== [10 x 1]


// States of the operations
parameter IDLE          =   4'b0000;
parameter W12_MUL       =   4'b0001;
parameter B12_ADD       =   4'b0010;
parameter RELU_STAGE1   =   4'b0011;
parameter W23_MUL       =   4'b0100;
parameter B23_ADD       =   4'b0101;
parameter RELU_STAGE2   =   4'b0110;
parameter PREDICTION    =   4'b0111;
parameter DONE          =   4'b1000;

reg [3:0] state;


always @(posedge clk, posedge rst) begin
    if( rst ) begin
        done = 0;
        state = IDLE;
    end
    else begin
        case (state)
                
            IDLE: begin
                if (start) begin
                    done = 0; //Set the done to ZERO upon begining
                    state = W12_MUL;
                end
            end
        
            W12_MUL: begin
            state = B12_ADD;
            end
        
            B12_ADD: begin
            state = RELU_STAGE1;
            end
        
            RELU_STAGE1: begin
            state = W23_MUL;
            end
        
            W23_MUL: begin
            state = B23_ADD;
            end
        
            B23_ADD: begin
            state = RELU_STAGE2;
            end
        
            RELU_STAGE2: begin
            state = PREDICTION;
            end
        
            PREDICTION: begin
            state = DONE;
            end
        
            DONE: begin
            done = 1;
            state = IDLE;
            prediction = 4'b111;
            end
                
        endcase
    end

end
endmodule
