function [Vmag, Vphase] = rec2pol(V)

    Vmag = abs(V);
    Vphase = angle(V)*180/pi;

end
