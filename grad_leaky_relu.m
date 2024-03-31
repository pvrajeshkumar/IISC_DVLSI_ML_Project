function fr = grad_leaky_relu(x)
    f = zeros(length(x),1);
    for i = 1:length(x)
    if x(i)>=0
        f(i) = 1;
    else
        f(i) = 0.02;
    end
    end
    fr = f;
end