%ap on the Glass Brain:

% Load EEG data and channel locations
load('your_data.mat');
load('channel_locations.mat');

% Set up Glass Brain figure
fig = figure;
set(fig, 'Color', 'white');
ax = axes('Parent', fig, 'XLim', [-100 100], 'YLim', [-100 100], 'ZLim', [-100 100]);

% Define colormap for heat map
cmap = jet(256);

% Loop through frequency bands (e.g., delta, theta, alpha, beta)
freq_bands = {'delta', 'theta', 'alpha', 'beta'};
for i = 1:length(freq_bands)
    % Extract power amplitude for current frequency band
    power_amp = mean(abs(fft(your_data, [], 3)), 2); % assuming 3rd dimension is frequency
    
    % Create 3D heat map
    [X, Y, Z] = meshgrid(-100:10:100, -100:10:100, -100:10:100);
    heatmap = reshape(power_amp, size(X, 1), size(Y, 2), size(Z, 3));
    heatmap = permute(heatmap, [2 1 3]); % reorder dimensions for Glass Brain projection
    
    % Project heat map onto Glass Brain
    [X_glass, Y_glass, Z_glass] = topoplot(heatmap, channel_locations, 'plottype', 'bubbles', ...
        'colormap', cmap, 'electrodes', 'off', 'smooth', 0.5);
    
    % Display heat map on Glass Brain
    imagesc(X_glass, Y_glass, Z_glass, cmap);
    axis off;
    title(freq_bands{i});
end