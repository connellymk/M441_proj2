function words = fileToArray(filename)
%% Returns cleaned array of words in song specified by "string"

fid=fopen(filename); % open file
words=textscan(fid, '%s'); % read words into cell array
fclose(fid); % close file
words=words{:}; % create string array from cell array
words=lower(words); % convert all characters to lowercase
words=erasePunctuation(words); % remove punctuation characters from strings
words=rmmissing(words); % remove empty elements

ignore=[
  "the";
  "i";
  "you";
  "and";
  "to";
  "a";
  "of";
  "in";
  "on";
  "it";
  "that";
  "for";
  "is";
  "its";
  "this";
  "im";
  "as"
];


for i=1:length(ignore) % remove words specified in ignore array
    words(strcmp(words,ignore(i)))=[];
end

end