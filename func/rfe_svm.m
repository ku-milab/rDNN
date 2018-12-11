function [Y, r] = rfe_svm(data, label, C);
% data is n*m matrix, n is number of training data, m is the dimensionality
% label is n*1 matrix, the label of the training data
% output r is feature ranked list


%% Start of svm-rfe

X0 = data;
[n, m] = size(X0);
s = [1:m];
r = [];
ls = length(s);
while ls > 0 % remember to change it back to 0
      
    opt = ['-t ' num2str(0) ' -c ' num2str(C)];
%     opt = ['-t 0 -h 0 -e 0.001 -w1 1.0 -c ', num2str(C)];
%     opt = ['-t 0 -h 0 -e 0.001 -w1 ', num2str(wp), ' -w2 ', num2str(wn), '-c ', num2str(C)];

    X = X0(:, s);
%     display 'svm train' 
%     model = svmtrain(label, X,  opt);  % libsvm package
    model = svmtrain_libsvm(label, X,  opt);  % libsvm package
%     display 'svm train done'
    sv_coef = model.sv_coef;                                   
    sv = model.SVs;
    w = sv_coef'*sv;
    w2 = w.^2;
    c_min = min(w2);
    c_max = max(w2);
 
    for f=1:ls
        if w2(f)== 0 | w2(f) == c_min
            r = [s(f), r];
            if f==1
                s = s(2:ls);
            elseif f == ls
                if ls == 1
                   s = [];
                else
                   s = s(1:ls-1);
                end
            else
               s = s([1:f-1, f+1:ls]);
            end % end of if
            
            ls = length(s);
            break;
        end % end of if
    end % end of for
    
end % end of while

Y = data(r);