function verilog_mem_file_gen()

global w12;
global w23;
global b12;
global b23;
global pixels_in_input_img;
global hidden_nodes;
global output_nodes;
global totalbits;
global fractionbits;

[w12_fix_float, w12_fix_int, err] = fixedpoint(w12, totalbits,fractionbits,1);
[w23_fix_float, w23_fix_int, err] = fixedpoint(w23, totalbits,fractionbits,1);
[b12_fix_float, b12_fix_int, err] = fixedpoint(b12, totalbits,fractionbits,1);
[b23_fix_float, b23_fix_int, err] = fixedpoint(b23, totalbits,fractionbits,1);

%First generate Weights & Biases Verilog files to be used in Verilog
%Generate Verilog files
%w12.v
fprintf('\t Generating w12.v.... \n');
fileID = fopen("w12.v", "w");
for i=1:hidden_nodes
    for j=1:pixels_in_input_img
        if( w12_fix_int(i,j) < 0 )
            fprintf(fileID, "assign w12[%d][%d] = -%d'd%d;\n", i-1, j-1, totalbits, abs(w12_fix_int(i,j)));
        else
            fprintf(fileID, "assign w12[%d][%d] = %d'd%d;\n", i-1, j-1, totalbits, w12_fix_int(i,j));
        end    
    end
end
fclose(fileID);

%b12.v
fprintf('\t Generating b12.v.... \n');
fileID = fopen("b12.v", "w");
loop_cnt = hidden_nodes;
for i=1:loop_cnt
    if( b12_fix_int(i) < 0 )
        fprintf(fileID, "assign b12[%d] = -%d'd%d;\n", i-1, totalbits, abs(b12_fix_int(i)));
    else
        fprintf(fileID, "assign b12[%d] = %d'd%d;\n", i-1, totalbits, b12_fix_int(i));
    end    
end
fclose(fileID);


%w23.v
fprintf('\t Generating w23.v.... \n');
fileID = fopen("w23.v", "w");
for i=1:output_nodes
    for j=1:hidden_nodes
        if( w23_fix_int(i,j) < 0 )
            fprintf(fileID, "assign w23[%d][%d] = -%d'd%d;\n", i-1, j-1, totalbits, abs(w23_fix_int(i,j)));
        else
            fprintf(fileID, "assign w23[%d][%d] = %d'd%d;\n", i-1, j-1, totalbits, w23_fix_int(i,j));
        end    
    end
end
fclose(fileID);

%b23.v
fprintf('\t Generating b23.v.... \n');
fileID = fopen("b23.v", "w");
loop_cnt = output_nodes;
for i=1:loop_cnt
    if( b23_fix_int(i) < 0 )
        fprintf(fileID, "assign b23[%d] = -%d'd%d;\n", i-1, totalbits, abs(b23_fix_int(i)));
    else
        fprintf(fileID, "assign b23[%d] = %d'd%d;\n", i-1, totalbits, b23_fix_int(i));
    end    
end
fclose(fileID);

%Generating TestBench Images Vectors
fprintf('\t Generating TestBench Images Vectors.... \n');
% 'semeion.data' unshuffled test data are arranged at 20 in a group
tb_imgs = [1, 21, 41, 61, 81, 101, 121, 141, 161, 181];
%Load the unshuffled data again for testing the images in "tb_imgs" above
tb_data = load('semeion.data');
fileID = fopen("tb_imgs.v", "w");
for i=1:length(tb_imgs)
    bitString = '';
    dat = tb_data(tb_imgs(i), 1:pixels_in_input_img);
    % Loop through each element in the array
    for j = 1:length(dat)
	    % Convert the number to binary and concatenate
	    bitString = strcat(bitString, dec2bin(dat(j)));
    end
    fprintf(fileID, "test_imgs[%d] <= 256'b%s;\n", i-1, bitString);
end
fclose(fileID);

fprintf(' ***** Generating files DONE. ***** \n');

end

