function iprint(I, Iname)
    Iname = [Iname ' ='];
    Iname = pad(Iname,9);
    numPhase = length(I);
    [Imag,Iphase] = rec2pol(I);

    if numPhase == 1
        fprintf('%s\t%.1f < %.2f   A\n\n',Iname,Imag(1),Iphase(1))
    elseif numPhase == 2
        fprintf('\t\t%.1f < %.2f\n',Imag(1),Iphase(1))
        fprintf('%s\t%.1f < %.2f   A\n\n',Iname,Imag(2),Iphase(2))
    elseif numPhase ==3
        fprintf('\t\t%.1f < %.2f\n',Imag(1),Iphase(1))
        fprintf('%s\t%.1f < %.2f   A\n',Iname,Imag(2),Iphase(2))
        fprintf('\t\t%.1f < %.2f\n\n',Imag(3),Iphase(3))
    end
end