function class = boundary_class(Neural_Net)
    a = size(Neural_Net);
    class = zeros(a(1),1);
    for i = 1:a(1)
       if Neural_Net(i,2) > 0.5
           class(i) = 1;
       end
    end

end