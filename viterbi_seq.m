clear
T = [0.7,0.3;0.4,0.6];
Z = [0.9,0.1;0.3,0.7];
Z_i = [0,0,0,1,1,1,1,0,0,0];
P = [0.5,0.5];
filtering = zeros(10,2);
filtering(1,1:2) = filtering(1,1:2) + [0.125,0.875];
P = filtering(1,1:2);
seq = zeros(1,10);
for i=2:10
    if(Z_i(i) == 1)
        t = [0,0];
        t1 = [T(1,1)*P(1),T(1,2)*P(2)];
        t2 = [T(2,1)*P(1),T(2,2)*P(2)];
        if(i==1)
            t(1) = t(1) + t1(1) + t1(2);
            t(2) = t(2) + t2(1) + t2(2);
        end
        if(i~=1)
            n1 = find(t1==max(t1));
            n2 = find(t2==max(t2));
            t(1) = t(1) + t1(n1);
            t(2) = t(2) + t2(n2);
        end
        a = Z(1,1)*t(1);
        b = Z(2,1)*t(2);
        c = 1/(a + b);
        filtering(i,1:2) = filtering(i,1:2) + [c*a,c*b];
        P = filtering(i,1:2);
        d = Z(1,1)*1*T(1:2,1) + Z(2,1)*1*T(1:2,2);
    end
    if(Z_i(i) == 0)
        t = [0,0];
        t1 = [T(1,1)*P(1),T(1,2)*P(2)];
        t2 = [T(2,1)*P(1),T(2,2)*P(2)];
        if(i==1)
            t(1) = t1(1) + t1(2);
            t(2) = t2(1) + t2(2);
        end
        if(i~=1)
            n1 = find(t1==max(t1));
            n2 = find(t2==max(t2));
            t(1) = t(1) + t1(n1);
            t(2) = t(2) + t2(n2);
        end
        a = Z(1,2)*t(1);
        b = Z(2,2)*t(2);
        c = 1/(a + b);
        filtering(i,1:2) = filtering(i,1:2) + [c*a,c*b];
        P = filtering(i,1:2);
    end
end
for i=1:10
    x = find(filtering(i,1:2)==max(filtering(i,1:2)));
    if(x==1)
        seq(1,i) = 1;
    end
    if(x==2)
        seq(1,i) = 0;
    end
end
seq