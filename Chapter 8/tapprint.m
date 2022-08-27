function tapprint(Tap)
    Tapname = '[Tap]';
    Tapname = [Tapname ' ='];
    Tapname = pad(Tapname,9);
    numPhase = length(Tap);

    if numPhase == 1
        fprintf('%s\t%.0f \n\n',Tapname,Tap)
    elseif numPhase == 2
        fprintf('\t\t%.0f\n',Tap(1))
        fprintf('%s\t%.0f\n\n',Tapname,Tap(2))
    elseif numPhase ==3
        fprintf('\t\t%.0f\n',Tap(1))
        fprintf('%s\t%.0f\n',Tapname,Tap(2))
        fprintf('\t\t%.0f\n\n',Tap(3))
    end
end