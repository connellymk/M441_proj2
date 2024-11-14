% An exploration of themes of life, death and love in the Grateful Dead
% studio albums using latent semantic analysis


% Create table of songs and album info
song_info=readtable("GD_songs.csv");

% For each song create cell array of lyrics
% Create a vector of all words used in all songs

allwords=strings(0,1);
allLyrics={1,height(song_info)};
for i=1:height(song_info)
    %filename=;
    filepath=fullfile(strcat("lyrics\",song_info{i,"Filename"}));

    allLyrics{i} = fileToArray(filepath); % Add lyrics of song i to cell array of all lyrics
    allwords=[allwords;allLyrics{i}]; % cumulative vector of all words for all songs
end

uniqueWords=unique(allwords); % vector of unique words accross all songs

% Create Matrix A for LSM
for i=1:length(uniqueWords)
    word=uniqueWords(i);
    for j=1:height(song_info)
        song=allLyrics{j};
        A(i,j)=nnz(strcmp(song,word)); % number of times word(i) appears in song(j)   
    end
end

% Create table of word frequency per song from matrix A
words_Freq=array2table(A,"RowNames",uniqueWords,"VariableNames",song_info{:,"Title"});
words_Freq.sum=sum(A,2);
words_Freq=sortrows(words_Freq,"sum",'descend');


%%Query1 (life)
life=["live","lived","livin","living","life","lifetime","alive"];
cosDist_life = semanticAnalysis(A,life,uniqueWords)';
song_info.cosDist_life=cosDist_life; % Add results to table

%%Query2 (death)
death=["dead","drowned","murder","die","fatal","drown","dying","kill","killer","killing"];
cosDist_death = semanticAnalysis(A,death,uniqueWords)';
song_info.cosDist_death=cosDist_death; % Add results to table

%%Query3 (love)
love=["love","loved","lover","lovers","love","lovin","loving","baby","heart","romance","romancin","romantics"];
cosDist_love = semanticAnalysis(A,love,uniqueWords)';
song_info.cosDist_love=cosDist_love; % Add results to table

%%Query4 (Gambling)
gambling=["money","played","jack","lie","lies","whiskey","win","wine","fair","jail","shakedown","shots","fight","drink","drinkin","steal","gin","jailhouse","liquor","losing","pistol"];
cosDist_gambling = semanticAnalysis(A,gambling,uniqueWords)';
song_info.cosDist_gambling=cosDist_gambling; % Add results to table

%%Query5 (Darkness)
darkness=["moon","night","dark","black","cry","broken","darkness","devil","lonely","carrion","dungeon","forsaken","nightmare","nights","nighttime","poisoned","tears"];
cosDist_darkness = semanticAnalysis(A,darkness,uniqueWords)';
song_info.cosDist_darkness=cosDist_darkness; % Add results to table

%%Query6 (Light)
light=["mornin","morning","sun","light","dancing","dance","happy","sunshine","summer","dawn","miracle","laughter","dove","fun"];
cosDist_light = semanticAnalysis(A,light,uniqueWords)';
song_info.cosDist_light=cosDist_light; % Add results to table


% Calculate sum of cos Dist for each theme per album
% Rank albums per theme

albums=unique(song_info(:,"Album"));
albums.cd_life(:)=0;
albums.cd_death(:)=0;
albums.cd_love(:)=0;
albums.cd_gambling(:)=0;
albums.cd_darkness(:)=0;
albums.cd_light(:)=0;

for a = 1:height(albums)
    album_name=albums{a,"Album"}{:};

    songs_album_a=song_info(string(song_info.Album) == album_name,:);

    albums{a,"cd_life"}=sum(songs_album_a.cosDist_life);
    albums{a,"cd_death"}=sum(songs_album_a.cosDist_death);
    albums{a,"cd_love"}=sum(songs_album_a.cosDist_love);
    albums{a,"cd_gambling"}=sum(songs_album_a.cosDist_gambling);
    albums{a,"cd_darkness"}=sum(songs_album_a.cosDist_darkness);
    albums{a,"cd_light"}=sum(songs_album_a.cosDist_light);

end



% Remove common words?