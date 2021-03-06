function [SimpleSVMModel]=classify_svm_v4(image_structure)

%Read in the labels from the structural array and convert them into a list
%of numbers and corresponding names
labels=image_structure.Labels;
[labels_nums, labels_names] = grp2idx(labels);

num_unique_labels=unique(labels_nums);

field_names=fieldnames(image_structure);

% for q=1:size(num_unique_labels)-1
q=1;
    num_labels=labels_nums;
    num_labels(labels_nums~=num_unique_labels(q))=max(labels_nums);

%     for p=1:size(field_names,1)-1;
p=1;
        current_field=cell2mat(field_names(p));
        images=image_structure.(current_field);
        %images=zscore(images);
        if iscell(images)==1
            images=cell2mat(images);
        end
            
           
            
            train_perc=.9;
            subset = floor(train_perc*size(images,1));
            [trainLabels, idx] = datasample(num_labels, subset, 'Replace', false);
            trainData = images(idx,:);
            testData=images;
            testData(idx,:)=[];
            testLabels=num_labels;
            testLabels(idx,:)=[];
            tic
            disp 'Started Optimization';
            %Fit initial svm to the data and images using a Gaussian kernel,
            %standardized data, a box constraint of 1, and an automatic kernel
            %scale (standards)
            SVMModel=fitcsvm(trainData,trainLabels,'KernelFunction','rbf','Standardize',true,'BoxConstraint', 1,'KernelScale','auto');
            
            %Split the labels into 10 random folds of data with approximately the same
            %number of points from the labels. This will be used to cross-validate the
            %classifier
%             partitions=cvpartition(num_labels,'HoldOut',.1);
        
            %Minimize potential kfoldloss in this svm as further training
            %Designate a function to minimize (i.e., minimize the kfold loss of this
            %SVM by modifying the box constraint and kernel scale)
            minfn=@(z)kfoldLoss(fitcsvm(trainData,trainLabels,'KFold',10, 'KernelFunction','rbf','Standardize',true, 'BoxConstraint', exp(z(1)), 'KernelScale', exp(z(2))));
            
            %So that it doesn't take too much memory set the tolerances (for
            %difference in error) higher than they usually would be    
            opts=optimset('TolX',5e-2,'TolFun',5e-2);

            %Run through five random starting values for the box constraint and
            %kernel scale (so as not to settle on a local minimum)   
            m=1;

            %Define fval as an array of zeroes in which the kfold loss values for
            %any z value found will be placed    
            fval=zeros(m,1);

            %Initialize z as a row vector of two ones 
            z=ones(1,2);

            %Define the z matrix (in order to keep track) as just a collection of
            %all of the z's defined in the next step. Intialize as a vector of ones
            z_mat=ones(m,2);

            %Loop for all different starting numbers for z (5 loops in our case)
            toc
            
%             for j=1:m
%                 tic
%                 disp([num2str(j), 'of', num2str(m)])
% 
%                 %Find the minimum z value (under searchmin) and the value of the
%                 %kfoldloss using fminsearch on the function given, starting with
%                 %two random numbers and the optimums given        
%                 [searchmin, fval(j)]=fminsearch(minfn,10*randn(2,1),opts);
% 
%                 %Call the new z the exponent of the number that gives the minimum        
%                 z=exp(searchmin);
%                 z=searchmin;
%                 %%                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
% 
%                 %Add this z to the appropriate slot in the z matrix        
%                 z_mat(j,:)=z;
%                 toc
%             end

            %Find the z value that gives the global minimum    
            z=z_mat(fval == min(fval),:);
            SimpleSVMModel = fitcsvm(trainData,trainLabels,'KernelFunction','rbf','KernelScale', 'Auto');
            SVMModel=fitcsvm(trainData,trainLabels,'KFold', 10, 'KernelFunction','rbf','Standardize',true, 'BoxConstraint', exp(z(1)), 'KernelScale', exp(z(2)));
               
            %Retrain the SVM with the z values found through the kfoldloss exercise    
            %SimpleSVMModel=fitcsvm(trainData,trainLabels, 'KernelFunction','rbf','Standardize',true, 'BoxConstraint', exp(z(1)), 'KernelScale', exp(z(2)));
            toc
% 
%             %Train and cross-validate the SVM from above using the partition
%             %defined in line 73
%             CVSVM_Model=crossval(SVMModel_2,'CVPartition',partitions);
 
    %% Predict the results
            [pred_acc,score_acc]=predict(SimpleSVMModel,testData);
            Pred_acc_mat=[testLabels, pred_acc];
            TP=0;TN=0;FP=0;FN=0;
            for i=1:size(Pred_acc_mat,1)
                if Pred_acc_mat(i,1)==1 && Pred_acc_mat(i,2)==1
                    TP=TP+1;
                elseif Pred_acc_mat(i,1)==2 && Pred_acc_mat(i,2)==1
                    FP=FP+1;
                elseif Pred_acc_mat(i,1)==2 && Pred_acc_mat(i,2)==2
                    TN=TN+1;
                elseif Pred_acc_mat(i,1)==1 && Pred_acc_mat(i,2)==2
                    FN=FN+1;
                end
            end
            
            Accuracy=(TP+TN)/(TP+TN+FP+FN)
            
            %[pred_map,score_map]=predict(SVMModel_2,pat);

        %     generate_image(config, upper_x, upper_y, pred')

end