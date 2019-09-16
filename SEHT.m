%An R-peak detection method based on peaks of Shannon energy envelope
function [out_sig, peak_locs_final] = SEHT(signal,fs)
    % the output: detected peak locations
    % filter the noise and baseline wander with bandpass filter
    BP_filter = chebyshevI_bandpass(4,fs,6,18);
    % forward filtering
    f_signal = filter(BP_filter,signal);
    % backward filtering
    f_signal = fliplr(f_signal);
    f_signal = filter(BP_filter,f_signal);
    f_signal = fliplr(f_signal);
    % first order differentiation
    d_n = f_signal(2:end)-f_signal(1:end-1);
    % normalize the signal
    norm_dn = abs(d_n)/max(abs(d_n));
    % implementation from shannon energy envelope
    se_n = (-1)*(norm_dn.^2).*log(norm_dn.^2);
    % apply triangle filter: implementation from An R-peak detection method
    % based on peaks of Shannon energy envelope
    N = 55;
    rect_filter = rectwin(N);

    see = conv(se_n,rect_filter,'same');
    see = fliplr(see);
    see = conv(see,rect_filter,'same');
    see = fliplr(see);

   
    % Hilbert transform-based
    ht = imag(hilbert(see));
    % apply moving average filter to remove low frequency drift
    N = 900;
    ma_filter = (1/N)*ones(1,N);
    ma_out = conv(ht,ma_filter,'same');
%     ma_out = filter(ma_filter,1,ht);
    zn = ht - ma_out;
    % odd-symmetry function, find the zero cross points
    peak_locs_temp = [];
    for t = 2:length(zn)-1
        if zn(t-1) <= 0 && zn(t+1) >= 0
            if ismember(zn(t-1),peak_locs_temp) == 0
                peak_locs_temp = [peak_locs_temp, t];
            end
        end
    end
    peak_locs_final = real_r_peak_detection_loop(f_signal,fs,peak_locs_temp, 25);
    out_sig = zn;
%% plot for debug
%     figure,
%     subplot(7,1,1)
%     plot(signal)
%     subplot(7,1,2)
%     plot(f_signal)
%     subplot(7,1,3)
%     plot(norm_dn)
%     subplot(7,1,4)
%     plot(se_n)
%     subplot(7,1,5)
%     plot(see)
%     subplot(7,1,6)
%     plot(ht)
%     y = zeros(1,length(ht));
%     hold on
%     plot(y)
%     hold off
%     subplot(7,1,7)
%     plot(zn)
%     hold on
%     plot(y)
%     hold off