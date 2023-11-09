function sprint(S, Sname)
    Sname = [Sname ' ='];
    Sname = pad(Sname,9);
    numPhase = length(S);
    P = real(S);
    Q = imag(S);


    if numPhase == 1
        if sign(Q(1)) >= 0
            fprintf('%s\t%.1f + j%.1f   kVA\n\n',Sname,P(1),Q(1))
        else
            fprintf('%s\t%.1f - j%.1f   kVA\n\n',Sname,P(1),abs(Q(1)))
        end
    elseif numPhase == 2
         if sign(Q(1)) >= 0
            fprintf('\t\t%.1f + j%.1f\n', P(1),Q(1))
         else
            fprintf('\t\t%.1f - j%.1f\n', P(1),abs(Q(1)))
         end

         if sign(Q(2)) >= 0
            fprintf('%s\t%.1f + j%.1f   kVA\n\n',Sname,P(2),Q(2))
         else
            fprintf('%s\t%.1f - j%.1f   kVA\n\n',Sname,P(2),abs(Q(2))) 
         end

    elseif numPhase ==3
         if sign(Q(1)) >= 0
            fprintf('\t\t%.1f + j%.1f\n', P(1),Q(1))
         else
            fprintf('\t\t%.1f - j%.1f\n', P(1),abs(Q(1)))
         end

         if sign(Q(2)) >= 0
            fprintf('%s\t%.1f + j%.1f   kVA\n',Sname,P(2),Q(2))
         else
            fprintf('%s\t%.1f - j%.1f   kVA\n',Sname,P(2),abs(Q(2))) 
         end

         if sign(Q(3)) >= 0
            fprintf('\t\t%.1f + j%.1f\n\n', P(3),Q(3))
         else
            fprintf('\t\t%.1f - j%.1f\n\n', P(3),abs(Q(3)))
         end
    end
end