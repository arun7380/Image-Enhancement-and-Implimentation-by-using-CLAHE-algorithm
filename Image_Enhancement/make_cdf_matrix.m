function [cdfMatrix] = make_cdf_matrix(padded_image, block_size, limit)
    total_rows = size(padded_image, 1);
    total_cols = size(padded_image, 2);
    block_height = block_size(1);
    block_width = block_size(2);
    Th = total_rows / block_height;
    Tv = total_cols / block_width;
    cdfMatrix = zeros(Th, Tv, 256);

    % Iterate through the tiles
    for i = 1:Th
        for j = 1:Tv
            % Extract block
            p = (i-1)*block_height + 1;
            q = i * block_height;
            r = (j-1)*block_width + 1;
            s = j * block_width;
            current_block = padded_image(p:q, r:s);

            % Normalize histogram
            h_normalized = imhist(current_block) ./ numel(current_block);

            % Clip normalized histogram if necessary
            x = 0;
            for k = 1:256
                if (h_normalized(k) > limit)
                    x = x + (h_normalized(k) - limit);
                    h_normalized(k) = limit;
                end
            end
            h_normalized = h_normalized + x / 256;
            cdf = cumsum(h_normalized);
            cdfMatrix(i, j, :) = cdf;
        end
    end
end
