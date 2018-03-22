%% Data for Neural Network

function to_neural = sampling(pos, neg, k_p, k_n)

    neg_0 = datasample(neg,k_n);
    pos_0 = datasample(pos,k_p);
    to_neural = vertcat(neg_0,pos_0);

end