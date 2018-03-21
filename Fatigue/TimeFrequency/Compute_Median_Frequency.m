function MedianFreq = Compute_Median_Frequency(norm2_s1, Wave_FreqS)

MedianFreq = nan(size(norm2_s1,2),1) ;

for iTime = 1:size(norm2_s1,2)
    totinteg = trapz(norm2_s1(:,iTime)) ;
    Fmedsup = find(cumtrapz(norm2_s1(:,iTime))>0.5*totinteg) ;
    MedianFreq(iTime,1) = Wave_FreqS(Fmedsup(1)) ;
end

