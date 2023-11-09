function pprint(P, Pname)
    Pname = [Pname ' ='];
    Pname = pad(Pname,9);
    numPhase = length(P);



    if numPhase == 1

            fprintf('%s\t%.1f   kW\n\n',Pname,P(1))

    elseif numPhase == 2

            
            fprintf('%s\t%.1f\n',Pname,P(1))
            fprintf('%s\t%.1f   kW\n\n',Pname,P(2))
       

    elseif numPhase ==3

            fprintf('%s\t%.1f\n',Pname,P(1))
            fprintf('%s\t%.1f   kW\n',Pname,P(2))
            fprintf('%s\t%.1f\n\n',Pname,P(1))
    end

end