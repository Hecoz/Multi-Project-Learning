%%sigmoid将一个real value映射到（0,1）的区间（当然也可以是（-1,1）），
%这样可以用来做二分类。 

function output = sigmoid(x)
output =1./(1+exp(-x));
end