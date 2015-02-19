function classified=classify_svm_v3(image_structure, patches)

%Read in the labels from the structural array and convert them into a list
%of numbers and corresponding names
labels=image_structure.Labels;
[labels_nums, labels_names] = grp2idx(labels);

num_unique_labels=unique(labels_nums);

field_names=fieldnames(image_structure);


for q=1:size(num_unique_labels)-1
    num_labels=labels_nums;
    num_labels(labels_nums~=num_unique_labels(q))=max(labels_nums);

    for p=1:size(field_names,1)-1;
        current_field=cell2mat(field_names(p));
        images=image_structure.(current_field);
        for i=1:max(labels_nums)-1
            %Fit initial svm to the data and images using a Gaussian kernel,
            %standardized data, a box constraint of 1, and an automatic kernel
            %scale (standards)
            SVMModel=fitcsvm(images,num_labels(:,i),'KernelFunction','RBF','Standardize',true,'BoxConstraint', 1,'KernelScale','auto');

            %Minimize potential kfoldloss in this svm as further training
            %Designate a function to minimize (i.e., minimize the kfold loss of this
            %SVM by modifying the box constraint and kernel scale)
            minfn=@(z)kfoldLoss(fitcsvm(images,num_labels(:,i),'CrossVal', 'on', 'KernelFunction','RBF','Standardize',true, 'BoxConstraint', exp(z(1)), 'KernelScale', exp(z(2))));

            %So that it doesn't take too much memory set the tolerances (for
            %difference in error) higher than they usually would be    
            opts=optimset('TolX',5,'TolFun',5);

            %Run through five random starting values for the box constraint and
            %kernel scale (so as not to settle on a local minimum)   
            m=5;

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

            %Retrain the SVM with the z values found through the kfoldloss exercise    
            SVMModel_2=fitcsvm(images,num_labels(:,i), 'KernelFunction','RBF','Standardize',true, 'BoxConstraint', z(1), 'KernelScale', z(2));

            %Split the labels into 10 random folds of data with approximately the same
            %number of points from the labels. This will be used to cross-validate the
            %classifier
            partitions=cvpartition(labels_nums,'k',5);

            %Train and cross-validate the SVM from above using the partition
            %defined in line 73
            CVSVM_Model=crossval(SVMModel_2);%,'CVPartition',partitions);

            %Predict the results
            [pred(i,:),score(:,i)]=kfoldPredict(CVSVM_Model,patches);
            pred(i,:)=pred(i,:)';
        %     generate_image(config, upper_x, upper_y, pred')
        end
    end
end
classified=pred;