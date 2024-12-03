function [b_row, b_col] = block_index(i, j, block_size)
    % Calculate the block row and column index for pixel (i, j)
    b_row = ceil(i / block_size(1));  % row index of the block
    b_col = ceil(j / block_size(2));  % column index of the block
end
