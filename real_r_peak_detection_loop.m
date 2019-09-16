function peak_locs_final = real_r_peak_detection_loop(signal,fs, peak_locs_temp, thresh)
    peak_locs_final = real_r_peak_detection(signal,fs, peak_locs_temp,thresh);
    last_peak_locs = [];
    while isequal(peak_locs_final,last_peak_locs) == 0
        last_peak_locs = peak_locs_final;
        peak_locs_final = real_r_peak_detection(signal,fs, peak_locs_final,thresh);
    end