function [xc, yc] = block_centre(row, col, block_size)
    % Calculate the center of a block in the image
    % row, col - block's row and column indices
    % block_size - the size of each block [block_height, block_width]
    
    block_height = block_size(1);
    block_width = block_size(2);
    
    % The top-left corner of the block
    x_top_left = (row - 1) * block_height + 1;
    y_top_left = (col - 1) * block_width + 1;
    
    % The center of the block
    xc = x_top_left + floor(block_height / 2);
    yc = y_top_left + floor(block_width / 2);
end
