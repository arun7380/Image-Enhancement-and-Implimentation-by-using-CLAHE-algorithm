function histogram(image)
    % Function to manually calculate and plot the histogram of an image
    % Input:
    %   image: Grayscale image

    % Convert to grayscale if the image is RGB
    if size(image, 3) == 3
        image = rgb2gray(image);
    end

    % If the image is in floating-point format (0 to 1), scale it to [0, 255]
    if isfloat(image)
        image = uint8(image * 255);  % Scale to [0, 255] range
    end

    % Calculate histogram manually
    intensityCount = zeros(1, 256); % Initialize intensity count for 256 possible intensity values (0-255)
    
    % Loop through each pixel to calculate its intensity count
    for i = 1:size(image, 1)
        for j = 1:size(image, 2)
            intensity = image(i, j);  % Get the intensity value
            intensityCount(intensity + 1) = intensityCount(intensity + 1) + 1;  % Increment the corresponding intensity count
        end
    end

    % Normalize the histogram counts (optional, for better visualization)
    intensityCount = intensityCount / numel(image);

    % Plot the histogram
    figure;
    bar(0:255, intensityCount, 'FaceColor', [0.2, 0.2, 0.8], 'EdgeColor', 'none');
    xlim([0 255]);
    title('Histogram');
    xlabel('Intensity');
    ylabel('Frequency');
    grid on;
end
