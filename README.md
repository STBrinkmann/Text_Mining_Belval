# Work in progress!!

# Text Mining Belval Campus
In 2001 a project has been created to transform the former steel production site in Belval,
Luxembourg into the [Cité des Sciences](https://wwwde.uni.lu/fhse/belval_campus). 
In [2015](https://lequotidien.lu/luxembourg/le-campus-de-belval-en-un-clin-doeil/) the new campus has been opened.
![Campus Belval](https://wwwde.uni.lu/var/storage/images/media/images/campus_belval_final_1/1014043-1-fre-FR/campus_belval_final_1.jpg)

In this analysis I want to explore how this topic is being represented in the news.

Therefore I first collected the top 58 news articles from [Google News](https://www.google.com/search?q=belval+campus+esch-sur-alzette&client=firefox-b-d&sxsrf=ALeKk0080OxF6oOpC3lb6hNxafFccNgYjA:1590592264605&source=lnms&tbm=nws&sa=X&ved=2ahUKEwi57Kf3qdTpAhU7ThUIHSw_CG0Q_AUoAXoECCwQAw&biw=1920&bih=966).
The texts have been translated to english with [DeepL](https://www.deepl.com/en/translator) and structured 
in a .txt document like so:
```
Title: Title_Name
DATE: dd.mm.yyyy
.
. Text
.
Title: Title_Name
DATE: dd.mm.yyyy
.
. Text
.
```

### Wordcloud
Next a Wordcloud with the word frequency of the whole corpus has been created:
![Wordcloud](https://github.com/Weemaan/Text_Mining_Belval/blob/master/Plots/wordcloud.svg)
We can already see that the new campus is of high importance. But also, the look into the future ("2022", "future"),
but also the acknowledgement of its history ("furnace", "steel", "industrial"...) are often thematised.

### Term Frequency-Inverse Document Frequency
At this point the corpus does not contain many articles for 2014 and 2015. 
Therefore these articles have been combined for the further analysis. The next figure shows the number of articles per year:
![Article count](https://github.com/Weemaan/Text_Mining_Belval/blob/master/Plots/Articles_Count.svg)

With the wordcloud we explored the word frequency of the whole corpus. To analyse the keywords of each year, a [term frequency-inverse document frequency](http://www.tfidf.com/) has been conducted: 
![TF/IDF](https://github.com/Weemaan/Text_Mining_Belval/blob/master/Plots/tf_idf.svg)

### Structural Topic Model
Next a [Structural Topic Model (STM)](https://www.structuraltopicmodel.com/) has been applied on the data set with K = 6. These 6 topics have been labeled manually.
![STM](https://github.com/Weemaan/Text_Mining_Belval/blob/master/Plots/stm.svg)






