function peak_locs_final = join_r_peaks_loop(signal,fs, peak_locs_temp, thresh)
    min_peak_locs_len = length(signal);
    peak_locs_final = join_r_peaks(signal,fs, peak_locs_temp, thresh);
    while length(peak_locs_final)<min_peak_locs_len
%         disp(min_peak_locs_len);
        min_peak_locs_len = length(peak_locs_final);
        peak_locs_final = join_r_peaks(signal,fs, peak_locs_final, thresh);
    end