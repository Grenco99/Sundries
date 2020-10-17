t=[0:10];
y=[75.995,91.972,105.711,123.203,131.669,150.697,179.323,203.212,226.505,249.633,281.422];
tt=linspace(0,10);
yy=[];
for t_want = tt
    [y_pred, dy] = ratint(t,y,t_want);
    yy = [yy,y_pred];
end
plot(1900+t*10,y,'+',1900+tt*10,yy);
title('Rational Function Interpolation');
xlabel('Year');
ylabel('Population');
for t_want = [11,12]
    [y_pred, dy] = ratint(t,y,t_want);
    fprintf("Predict population in 20%d:%f\n",(t_want-10)*10,y_pred);
end