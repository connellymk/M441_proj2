function cosDist = semanticAnalysis(A,query,words)

[m,n]=size(A); % number of words, number of songs

rank=2; % number of singular values to keep in reduced system

[U,S,V]=svd(A);

U1=U(:,[1,rank]);
S1=S([1,rank],[1,rank]);
V1=V(:,[1,rank]);

for i=1:m
    wordsProj(i,:)=U1(i,:)*S1;
end

for i=1:n
    docsProj(:,i)=S1*(V1(i,:))';
end


% Query

q_num=zeros(1,rank);

for i=1:length(query)
    index=find(strcmp(words,query(i)));
    q_num=q_num+wordsProj(index,:);
end

q=q_num/length(query);

for i=1:n
    cosDist(i) = (dot(q',docsProj(:,i)))/(norm(q)*norm(docsProj(:,i)));
end

end