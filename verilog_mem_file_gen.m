function verilog_mem_file_gen()

global w12;
global w23;
global b12;
global b23;

[w12_fix_float, w12_fix_int, err] = fixedpoint(w12, 16,8,1);
[w23_fix_float, w23_fix_int, err] = fixedpoint(w23, 16,8,1);
[b12_fix_float, b12_fix_int, err] = fixedpoint(b12, 16,8,1);
[b23_fix_float, b23_fix_int, err] = fixedpoint(b23, 16,8,1);

%w12
fprintf('\t Generating w12.mem.... \n');
fileID = fopen("w12.mem", "w");
for i=1:40
    for j=1:256
        file_wr = dec2bin(w12_fix_int(i,j), 16);
        fprintf(fileID, "%s \n", file_wr);
    end
end
fclose(fileID);


%w23
fprintf('\t Generating w23.mem.... \n');
fileID = fopen("w23.mem", "w");
for i=1:10
    for j=1:40
        file_wr = dec2bin(w23_fix_int(i,j), 16);
        fprintf(fileID, "%s \n", file_wr);
    end
end
fclose(fileID);

%b12
fprintf('\t Generating b12.mem.... \n');
fileID = fopen("b12.mem", "w");
for i=1:40
    for j=1:1
        file_wr = dec2bin(b12_fix_int(i,j), 16);
        fprintf(fileID, "%s \n", file_wr);
    end
end
fclose(fileID);

%b23
fprintf('\t Generating b23.mem.... \n');
fileID = fopen("b23.mem", "w");
for i=1:10
    for j=1:1
        file_wr = dec2bin(b23_fix_int(i,j), 16);
        fprintf(fileID, "%s \n", file_wr);
    end
end
fclose(fileID);




fprintf(' ***** Generating files DONE. ***** \n');

end

