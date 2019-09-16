function peak_locs_temp = join_r_peaks(signal,fs, peak_locs_temp, thresh)
    % join the peaks that are too close
    i = 2;
    [r,c] = size(peak_locs_temp);
    if c == 1
        peak_locs_temp = peak_locs_temp';
    end
    while i<=length(peak_locs_temp)
        if abs(peak_locs_temp(i)-peak_locs_temp(i-1))<thresh
            if signal(peak_locs_temp(i)) >= signal(peak_locs_temp(i-1))
                peak_locs_temp(i-1) = [];
            else
                peak_locs_temp(i) = [];
            end
        end
        i = i + 1;
    end