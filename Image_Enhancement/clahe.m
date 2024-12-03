function [outputImage] = clahe(image, varargin)
    %CLAHE Contrast-limited Adaptive Histogram Equalization 

    % Input processing
    defaultNumTiles = [8, 8];
    defaultLimit = 0.01;

    switch nargin
        case 1
            numTiles = defaultNumTiles;
            limit = defaultLimit;
        case 2
            numTiles = varargin{1};
            limit = defaultLimit;
        case 3
            numTiles = varargin{1};
            limit = varargin{2};
        otherwise
            disp('Input is invalid');
            outputImage = -1; % error_code
            return;
    end

    % Check that the input is valid
    if (size(image,3) ~= 1)
        disp('Input Image must be grayscale');
        outputImage = -2; % error_code
        return;
    end
    if (~isa(image, 'uint8'))
        disp('Input Image should be of uint8');
        outputImage = -3; % error_code
        return;
    end

    % Check whether the number of tiles is valid or not
    Th = numTiles(1);
    Tv = numTiles(2);
    if (Tv <= 0 || Th <= 0)
        disp('No. of vertical and horizontal tiles must be +ve');
        outputImage = -4; % error_code
        return;
    end

    % Check that the limit parameter is correct
    if (limit < 0 || limit > 1)
        disp('Invalid Limit. Limit should be in range of [0,1]');
        return;
    end

    % Padding to fit tile dimensions
    rows = size(image, 1);
    cols = size(image, 2);
    pad_rows = 0;
    pad_cols = 0;

    if (mod(rows, Th) ~= 0)
        pad_rows = Th - mod(rows, Th);
    end
    if (mod(cols, Tv) ~= 0)
        pad_cols = Tv - mod(cols, Tv);
    end

    padded_image = padarray(image, [pad_rows, pad_cols], 'replicate', 'post');

    % Tile size calculation
    total_rows = size(padded_image, 1);
    total_cols = size(padded_image, 2);
    block_height = total_rows / Th;
    block_width = total_cols / Tv;

    block_size = [block_height block_width];

    % CDF matrix calculation for every block
    cdfMatrix = make_cdf_matrix(padded_image, block_size, limit); 

    % Initialize output image
    outputImage = zeros(total_rows, total_cols);

    % Iterating through each pixel in the padded image and applying CLAHE
    for i = 1:total_rows
        for j = 1:total_cols
            % Indices of the current block
            [b_row, b_col] = block_index(i, j, block_size);
            % Calculate the center coordinates of the current block
            xc = (b_row - 1) * block_height + block_height / 2;
            yc = (b_col - 1) * block_width + block_width / 2;

            % Interpolation based on pixel location in the sub-block
            if (i < xc || i >= xc + block_height || j < yc || j >= yc + block_width)
                % Boundary conditions handling (out of block)
                if ((i < xc && j < yc) || (i >= xc + block_height && j < yc) || ...
                    (i < xc && j >= yc + block_width) || (i >= xc + block_height && j >= yc + block_width))
                    outputImage(i, j) = cdfMatrix(b_row, b_col, padded_image(i, j) + 1);
                else
                    if ((b_row == 1 || b_row == Th) && (j >= yc && j < yc + block_width))
                        if (j < yc)
                            a = j - (yc - block_width);
                            b = yc - j;
                            k = (a * cdfMatrix(b_row, b_col, padded_image(i, j) + 1) + ...
                                b * cdfMatrix(b_row, b_col - 1, padded_image(i, j) + 1)) / (a + b);
                            outputImage(i, j) = k;
                        else
                            a = j - yc;
                            b = (yc + block_width) - j;
                            k = (b * cdfMatrix(b_row, b_col, padded_image(i, j) + 1) + ...
                                a * cdfMatrix(b_row, min(b_col + 1, Tv), padded_image(i, j) + 1)) / (a + b);
                            outputImage(i, j) = k;
                        end
                    else
                        if (i < xc)
                            a = xc - i;
                            b = i - (xc - block_height);
                            k = (a * cdfMatrix(max(b_row - 1, 1), b_col, padded_image(i, j) + 1) + ...
                                b * cdfMatrix(b_row, b_col, padded_image(i, j) + 1)) / (a + b);
                            outputImage(i, j) = k;
                        else
                            a = (xc + block_height) - i;
                            b = i - xc;
                            k = (a * cdfMatrix(b_row, b_col, padded_image(i, j) + 1) + ...
                                b * cdfMatrix(min(b_row + 1, Th), b_col, padded_image(i, j) + 1)) / (a + b);
                            outputImage(i, j) = k;
                        end
                    end
                end
            else
                % Bilinear interpolation for inner sub-block
                if (i < xc && j < yc) % top-left sub-block
                    a = j - (yc - block_width);
                    b = yc - j;
                    c = i - (xc - block_height);
                    d = xc - i;
                    sh_a = (b * cdfMatrix(max(b_row - 1, 1), max(b_col - 1, 1), padded_image(i, j) + 1) + ...
                            a * cdfMatrix(max(b_row - 1, 1), b_col, padded_image(i, j) + 1)) / (a + b);
                    sh_b = (b * cdfMatrix(b_row, max(b_col - 1, 1), padded_image(i, j) + 1) + ...
                            a * cdfMatrix(b_row, b_col, padded_image(i, j) + 1)) / (a + b);
                    outputImage(i, j) = (d * sh_a + c * sh_b) / (c + d);
                elseif (i >= xc && j < yc) % bottom-left sub-block
                    a = j - (yc - block_width);
                    b = yc - j;
                    c = i - xc;
                    d = xc + block_height - i;
                    sh_a = (b * cdfMatrix(b_row, max(b_col - 1, 1), padded_image(i, j) + 1) + ...
                            a * cdfMatrix(b_row, b_col, padded_image(i, j) + 1)) / (a + b);
                    sh_b = (b * cdfMatrix(min(b_row + 1, Th), max(b_col - 1, 1), padded_image(i, j) + 1) + ...
                            a * cdfMatrix(min(b_row + 1, Th), b_col, padded_image(i, j) + 1)) / (a + b);
                    outputImage(i, j) = (d * sh_a + c * sh_b) / (c + d);
                elseif (i < xc && j >= yc) % top-right sub-block
                    a = j - yc;
                    b = (yc + block_width) - j;
                    c = i - (xc - block_height);
                    d = xc - i;
                    sh_a = (b * cdfMatrix(max(b_row - 1, 1), b_col, padded_image(i, j) + 1) + ...
                            a * cdfMatrix(max(b_row - 1, 1), min(b_col + 1, Tv), padded_image(i, j) + 1)) / (a + b);
                    sh_b = (b * cdfMatrix(b_row, b_col, padded_image(i, j) + 1) + ...
                            a * cdfMatrix(b_row, min(b_col + 1, Tv), padded_image(i, j) + 1)) / (a + b);
                    outputImage(i, j) = (d * sh_a + c * sh_b) / (c + d);
                else % bottom-right sub-block
                    a = j - yc;
                    b = (yc + block_width) - j;
                    c = (xc + block_height) - i;
                    d = i - xc;
                    sh_a = (b * cdfMatrix(b_row, b_col, padded_image(i, j) + 1) + ...
                            a * cdfMatrix(b_row, min(b_col + 1, Tv), padded_image(i, j) + 1)) / (a + b);
                    sh_b = (b * cdfMatrix(min(b_row + 1, Th), b_col, padded_image(i, j) + 1) + ...
                            a * cdfMatrix(min(b_row + 1, Th), min(b_col + 1, Tv), padded_image(i, j) + 1)) / (a + b);
                    outputImage(i, j) = (d * sh_a + c * sh_b) / (c + d);
                end
            end
        end
    end
end
