function [Accuracy, pred_map, score_map]=classify_svm_v3(image_structure, patches_structure)

%Read in the labels from the structural array and convert them into a list
%of numbers and corresponding names
labels=image_structure.Labels;
[labels_nums, ~] = grp2idx(labels);

%Find how many distinct labels there are
num_unique_labels=unique(labels_nums);

%Find the field names of the image and patches structure
field_names=fieldnames(image_structure);
patch_names=fieldnames(patches_structure);

% %Loop over the number of unique lables there are -1 (don't loop over the
% %negatives)
% for q=1:size(num_unique_labels)-1
q=1;
    %define a working version of the numbers representing the labels to
    %modify
    num_labels=labels_nums;
    
    %Call all labels which don't belong to the current class defined by q
    %as negative
    num_labels(labels_nums~=num_unique_labels(q))=max(labels_nums);
    
    Result_Array_Size=size(field_names,1)-1;
    TP=zeros(1,Result_Array_Size*4); TN=zeros(1,Result_Array_Size*4); FP=zeros(1,Result_Array_Size*4); FN=zeros(1,Result_Array_Size*4);
    Accuracy=zeros(1,Result_Array_Size*4);
%Loop over the number of field_names in the image strucutre which
% represents the number of sets of features that can be used -1 (because
% the last set of "features" in the image structure is the set of labels)
for r=1:4;
    for p=1:size(field_names,1)-1;
        if r==1
        %descripe the current field name or feature set as described by p
        %as a matrix
            current_field_1=cell2mat(field_names(p));
            patch_field_1=cell2mat(patch_names(p));
            images=image_structure.(current_field_1);
            images=zscore(images);
            pat=patches_structure.(patch_field_1);
        elseif r==2 || r==3 && r~=p
            current_field_1=cell2mat(field_names(p));
            current_field_2=cell2mat(field_names(r));
            patch_field_1=cell2mat(patch_names(p));
            patch_field_2=cell2mat(patch_names(r));
            images=cat(2,image_structure.(current_field_1),image_structure.(current_field_2));
            images=zscore(images);
            pat=cat(2,patches_structure.(patch_field_1),patches_structure.(patch_field_2));
        elseif r==4
            current_field_1=cell2mat(field_names(1));
            current_field_2=cell2mat(field_names(2));
            current_field_3=cell2mat(field_names(3));
            patch_field_1=cell2mat(patch_names(1));
            patch_field_2=cell2mat(patch_names(2));            
            patch_field_3=cell2mat(patch_names(3));
            images=cat(2,image_structure.(current_field_1),image_structure.(current_field_2),image_structure.(current_field_3));
            images=zscore(images);
            pat=cat(2,patches_structure.(patch_field_1),patches_structure.(patch_field_2),patches_structure.(patch_field_3));
        end
        if iscell(images)==1
            images=cell2mat(images);
        end
        if iscell(pat)==1
            pat=cell2mat(pat);
        end
            
            train_perc=.9;
            subset = train_perc*size(images,1);
            [trainLabels, idx] = datasample(num_labels, subset, 'Replace', false);
            trainData = images(idx,:);
            testData=images;
            testData(idx,:)=[];
            testLabels=num_labels;
            testLabels(idx,:)=[];
            
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
            for j=1:m

                %Find the minimum z value (under searchmin) and the value of the
                %kfoldloss using fminsearch on the function given, starting with
                %two random numbers and the optimums given        
                [searchmin, fval(j)]=fminsearch(minfn,randn(2,1),opts);

                %Call the new z the exponent of the number that gives the minimum        
                z=exp(searchmin);
                %%                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

                %Add this z to the appropriate slot in the z matrix        
                z_mat(j,:)=z;
            end

            %Find the z value that gives the global minimum    
            z=z_mat(fval == min(fval),:);
            
            SVMModel=fitcsvm(trainData,trainLabels,'KFold', 10, 'KernelFunction','rbf','Standardize',true, 'BoxConstraint', exp(z(1)), 'KernelScale', exp(z(2)));
               
            %Retrain the SVM with the z values found through the kfoldloss exercise    
            SVMModel_2=fitcsvm(trainData,trainLabels, 'KernelFunction','rbf','Standardize',true, 'BoxConstraint', exp(z(1)), 'KernelScale', exp(z(2)));
%
    %% Predict the results
            [pred_acc,score_acc]=predict(SVMModel_2,testData);
            Pred_acc_mat=[testLabels, pred_acc];
            idx=p*r;
            TP(idx)=0;TN(idx)=0;FP(idx)=0;FN(idx)=0;
            for i=1:size(Pred_acc_mat,1)
                if Pred_acc_mat(i,1)==1 && Pred_acc_mat(i,2)==1
                    TP(idx)=TP(idx)+1;
                elseif Pred_acc_mat(i,1)==2 && Pred_acc_mat(i,2)==1
                    FP(idx)=FP(idx)+1;
                elseif Pred_acc_mat(i,1)==2 && Pred_acc_mat(i,2)==2
                    TN(idx)=TN(idx)+1;
                elseif Pred_acc_mat(i,1)==1 && Pred_acc_mat(i,2)==2
                    FN(idx)=FN(idx)+1;
                end
            end
            
            Accuracy(idx)=(TP(idx)+TN(idx))/(TP(idx)+TN(idx)+FP(idx)+FN(idx));
            
            [pred_map,score_map]=predict(SVMModel_2,pat);

        %     generate_image(config, upper_x, upper_y, pred')

    end
end