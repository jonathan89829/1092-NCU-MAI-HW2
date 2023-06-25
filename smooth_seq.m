clear
T = [0.7,0.3;0.4,0.6];
Z = [0.9,0.1;0.3,0.7];
Z_i = [0,0,0,1,1,1,1,0,0,0];
P = [0.5,0.5];
filtering = zeros(10,2);
backward = zeros(10,2);
smoothing = zeros(10,2);
recursive = zeros(10,2);
d1 = 1;
d2 = 1;
recursive(10,1:2) = [1,1];
backward(10,1:2) = [1,1];
filtering(1,1:2) = filtering(1,1:2) + [0.125,0.875];
P = filtering(1,1:2);
for i=2:10
    if(Z_i(i) == 1)
        t = P*T;
        a = Z(1,1)*t(1);
        b = Z(2,1)*t(2);
        c = 1/(a + b);
        filtering(i,1:2) = filtering(i,1:2) + [c*a,c*b];
        P = filtering(i,1:2);
    end
    if(Z_i(i) == 0)
        t = P*T;
        a = Z(1,2)*t(1);
        b = Z(2,2)*t(2);
        c = 1/(a + b);
        filtering(i,1:2) = filtering(i,1:2) + [c*a,c*b];
        P = filtering(i,1:2);
    end
end
for i=1:9
    if(Z_i(i) == 1)
        recursive(10 - i,1:2) = Z(1,1)*d1*T(1:2,1) + Z(2,1)*d2*T(1:2,2);
        d1 = recursive(10 - i,1);
        d2 = recursive(10 - i,2);
        backward(10 - i,1:2) = backward(10 - i,1:2) + recursive(10 - i,1:2);
    end
    if(Z_i(i) == 0)
        recursive(10 - i,1:2) = Z(1,2)*d1*T(1:2,1) + Z(2,2)*d2*T(1:2,2);
        d1 = recursive(10 - i,1);
        d2 = recursive(10 - i,2);
        backward(10 - i,1:2) = backward(10 - i,1:2) + recursive(10 - i,1:2);
    end
end
for i=1:10
    x = filtering(i,1)*backward(i,1);
    y = filtering(i,2)*backward(i,2);
    w = 1/(x + y);
    smoothing(i,1:2) = smoothing(i,1:2) + [w*x,w*y];
end
smoothing'