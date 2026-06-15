function Rf = myFilter(R,w,L,type)

[n,m] = size(R);
Rf = zeros(size(R));

for i = 1:m
    
    proj = R(:,i);
    P = fftshift(fft(proj));
    
    H = abs(w);  % Ram-Lak base
    
    switch lower(type)
        case 'ramlak'
            % H already defined
            
        case 'shepp-logan'
            H = abs(w) .* (sin(w/(2*L))./(w/(2*L)+eps));
            
        case 'cosine'
            H = abs(w).*cos(w/(2*L));
    end
    
    H(abs(w)>L) = 0;   % cutoff frequency
    
    Pf = P .* H;
    Rf(:,i) = real(ifft(ifftshift(Pf)));
end

end
