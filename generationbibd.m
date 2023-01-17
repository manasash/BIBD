function [ubd] = gen_bibd;
            v = 9;
            k = 3;
            bsz = 12;

%           r = 4;
           %n=(v-k)+1;
            
%          r4 = randperm(100,v);
%           C=nchoosek(r4,k);
           
          rng('shuffle');
          A = randperm(2^52,v)+(2^52 -1);
          r4= A* 2^75;
          C=nchoosek(r4,k);
          
          A=cell(length(C),1);
          for q=1:length(C)
               A{q} = C(q,:);
          end
            
          result = cell(length(C),length(C));
            
          for w=1:length(C)
              for l=1:length(C)
                  result{w,l}= A{l,:};
              end
          end
            
            for ww=1:length(C)
                for j=1:length(A)
                    for m=1:size(C, 1)
                        
                        no_two_common_elements = true;
                        
                        if no_two_common_elements == true && nnz(ismember(result{ww,j}(1,:), A{m})) >= 2
                            no_two_common_elements = false;
                        end
                        
                        if no_two_common_elements == true
                            result{ww,j}= vertcat(result{ww,j}, A{m});
                        end
                    end
                end
            end
            
            r2=cell(length(result{1})-1,length(result{1}));
            
            for e=1:length(result)
                for ee=1:length(result{e})-1
                    r2{ee,e}(1,:)=result{ee,e}(1,:);
                    r2{ee,e}(2,:)=result{ee,e}(ee+1,:);
                end
            end
            
            for dd=1:size(result,1)
                for d=1:size(result{1,1},1)-1
                    for b=1:length(result{d,dd})-1
                        
                        no_two_common_elements = true;
                        for c=1:2
                            if no_two_common_elements == true && nnz(ismember(r2{d,dd}(c,:), result{d,dd}(b,:))) >= 2
                                no_two_common_elements = false;
                                break;
                            end
                        end
                        
                        if no_two_common_elements == true
                            r2{d,dd}= vertcat(r2{d,dd}, result{d,dd}(b,:));
                        end
                    end
                end
            end
            
            r3=cell(size(r2,1),length(result));
            
            for a=1:length(result)
                for aa=1:size(r2,1)
                    for k=1:3
                        r3{aa,a}(k,:)=r2{aa,a}(k,:);
                    end
                end
            end
            
            no_of_values=3;
            
            for ff=1:size(r2,1)
                for fff=1:size(r2,2)
                    for gg=1:size(r2{ff,fff},1)
                        
                        no_two_common_elements = true;
                        for cc=1:no_of_values
                            if no_two_common_elements == true && nnz(ismember(r3{ff,fff}(cc,:), r2{ff,fff}(gg,:))) >= 2
                                no_two_common_elements = false;
                                break;
                            end
                        end
                        
                        if no_two_common_elements == true
                            r3{ff,fff}= vertcat(r3{ff,fff}, r2{ff,fff}(gg,:));
                            no_of_values=no_of_values+1;
                        end
                        
                    end
                    no_of_values=3;
                end
            end
            
            no_of_sets_in_final_result=1;
            final_result=cell(no_of_sets_in_final_result,1);
            
            for ii=1:size(r3,1)
                for jj=1:size(r3,2)
                    if( size(r3{ii,jj},1)== bsz)
                        final_result{no_of_sets_in_final_result,1}=r3{ii,jj};
                        no_of_sets_in_final_result=no_of_sets_in_final_result+1;
                    end
                end
            end
            
            no_of_unital_bibd=1;
            unital_bibd=cell(no_of_unital_bibd,1);
            
            for s=1:size(final_result,1)
                if (all(histc(final_result{s,1}(:), unique(final_result{s,1}))))==1
                    unital_bibd{no_of_unital_bibd,1}=final_result{s,1};
                    no_of_unital_bibd=no_of_unital_bibd+1;
                end
            end
            qt = randi(382,1);
            ubd = unital_bibd{qt};
end           

