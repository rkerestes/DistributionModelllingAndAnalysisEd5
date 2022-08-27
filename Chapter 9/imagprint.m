function imagprint(I, Iname)
    Iname = [Iname ' ='];
    Iname = pad(Iname,9);
    numPhase = length(I);

    if numPhase == 1
        fprintf('%s\t%.1f   A\n\n',Iname,I(1))
    elseif numPhase == 2
        fprintf('\t\t%.1f\n',I(1))
        fprintf('%s\t%.1f   A\n\n',Iname,I(2))
    elseif numPhase ==3
        fprintf('\t\t%.1f\n',I(1))
        fprintf('%s\t%.1f   A\n',Iname,I(2))
        fprintf('\t\t%.1f\n\n',I(3))
    end
end