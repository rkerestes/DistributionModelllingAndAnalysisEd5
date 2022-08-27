function vmagprint(V, Vname)
    Vname = [Vname ' ='];
    Vname = pad(Vname,9);
    numPhase = length(V);

    if numPhase == 1
        fprintf('%s\t%.1f   V\n\n',Vname,V(1))
    elseif numPhase == 2
        fprintf('\t\t%.1f\n',V(1))
        fprintf('%s\t%.1f   V\n\n',Vname,V(2))
    elseif numPhase ==3
        fprintf('\t\t%.1f\n',V(1))
        fprintf('%s\t%.1f   V\n',Vname,V(2))
        fprintf('\t\t%.1f\n\n',V(3))
    end
end