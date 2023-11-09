function vprint(V, Vname)
    Vname = [Vname ' ='];
    Vname = pad(Vname,9);
    numPhase = length(V);
    [Vmag,Vphase] = rec2pol(V);

    if numPhase == 1
        fprintf('%s\t%.1f < %.2f   V\n\n',Vname,Vmag,Vphase)
    elseif numPhase == 2
        fprintf('\t\t%.1f < %.2f\n',Vmag(1),Vphase(1))
        fprintf('%s\t%.1f < %.2f   V\n\n',Vname,Vmag(2),Vphase(2))
    elseif numPhase ==3
        fprintf('\t\t%.1f < %.2f\n',Vmag(1),Vphase(1))
        fprintf('%s\t%.1f < %.2f   V\n',Vname,Vmag(2),Vphase(2))
        fprintf('\t\t%.1f < %.2f\n\n',Vmag(3),Vphase(3))
    end
end