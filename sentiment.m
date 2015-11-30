#!/usr/local/bin/math -script

rootdir="/home/rigsby/srigsby.github.io/"
articleFiles=Import[StringJoin[rootdir, "article_files"]]
cleanArticles={};
For[i=1, i<Length[articleFiles]+1,i++,
    AppendTo[cleanArticles,
        StringJoin[articleFiles[[i]][[1]],"_clean"]]]
Length[cleanArticles]==Length[articleFiles];

textdir=StringJoin[rootdir,"articles/"];
sentiment={};
For[i=1, i<=Length[cleanArticles],i++,
    currentText= Import[StringJoin[textdir,cleanArticles[[i]],".txt"]];
    sentences= StringSplit[currentText, {".","?","!"}];
    AppendTo[sentiment,
        {articleFiles[[i]][[1]],
        Tally[Classify["Sentiment",sentences]]}];
        ];
Export["article_sentiments.txt",sentiment]
