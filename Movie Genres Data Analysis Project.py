#!/usr/bin/env python
# coding: utf-8

# ### Research Questions :
# 
# 1. Which genres are the most common (number of movies made)?
# 2. Which genres have high avg. budget and revenue ?
# 3. Which genres have high avg. profit ?
# 4. Which genres have high avg. popularity ?
# 5. Which genres have highest number of movies with an voting avg. >= 8 ?
# 
# ### Research Hypotesis (H)
# 
# 1. The best movies according to vote avg. return high profit and revenue
# 2. The best movie according to popularity,return high profit and revenue
# 3. Highly budgeted movies return high profit
# 4. Highly budgeted movies have a high popularity
# 5. Check how the Profit varies per genre and per year
# 

# In[2]:


import pandas as pd


# In[3]:


movies = pd.read_csv(r'C:\Users\Gaetan.WEBER\Desktop\Portfolio project\Python\Pandas\imdb_movies.csv')


# In[5]:





# In[6]:


pd.set_option('display.max.rows', 11000)
pd.set_option('display.max.columns', 22)


# In[7]:


movies.head()


# In[8]:


movies.info()


# ### Checking for the duplicates

# In[19]:


movies[movies.duplicated() == True]


# In[4]:


movies.drop_duplicates(inplace = True)


# ### Removing the null value for the genres column

# In[5]:


movies.dropna(subset = ['genres'], inplace = True)


# ### Creation of a new column Profit

# In[6]:


movies['Profit'] = movies['revenue'] - movies['budget']


# ###  Removing unnecessary columns for our analysis

# In[7]:


movies_genre =movies[['popularity','budget', 'revenue','original_title','runtime','genres','release_date','vote_count','vote_average','Profit']]


# In[27]:


movies_genre.head()


# In[8]:


from pandas import Series, DataFrame
split =movies_genre['genres'].str.split(pat = '|').apply(Series,1).stack()
split.index = split.index.droplevel(-1)
split.name = 'genres_split'
del movies_genre['genres']
movies_genre = movies_genre.join(split)


# In[13]:


movies_genre


# ## Q1. Which genres are the most common (number of movies made)?

# In[11]:


genres_count = pd.DataFrame(movies_genre.groupby('genres_split')['original_title'].nunique()).sort_values(by='original_title',ascending = True)


# In[ ]:





# In[27]:


genres_count['original_title'].plot.pie(title ='Movies Per Genres in %', autopct = '%1.1f%%',figsize = (10,10))


# In[31]:


genres_count['original_title'].plot.barh( title = 'Movies Per Genres', color = 'DarkBlue', figsize = (10,9))


# ## Q2. Which genres have high avg. budget and revenue ?

# In[13]:


genres_avg_budg_rev = movies_genre.groupby('genres_split')[['budget','revenue']].mean()

pd.options.display.float_format = '{:2f}'.format
genres_avg_sorted = genres_avg_budg_rev.sort_values(by = 'revenue', ascending = True)


# In[62]:


genres_avg_sorted.plot.barh(title = 'Budget and Revenue by Genre', color = ('DarkBlue','c'))


# ## Q3. Which genres have high avg. profit ?

# In[14]:


avg_profit = movies_genre.groupby('genres_split')['Profit'].mean().sort_values(ascending = True)


# In[73]:


avg_profit.plot.barh(title = 'Profit by Genre', color = 'DarkBlue')


# ## Q4 .Which genres have high avg. popularity ?

# In[15]:


avg_popularity = movies_genre.groupby('genres_split')['popularity'].mean().sort_values(ascending = True)


# In[77]:


avg_popularity.plot.barh(title = 'Popularity by Genre', color = 'DarkBlue')


# ## Q5. Which genres have highest number of movies with an voting avg. >= 8 ?

# In[78]:


movies_genre.head()


# In[16]:


vote_fifty=movies_genre[(movies_genre['vote_average'] >= 8 ) & (movies_genre['vote_count'] >= 50)]
vote_zero =movies_genre[movies_genre['vote_average'] >= 8]


# In[22]:


vote_grouped_zero = vote_zero.groupby('genres_split')['vote_average'].nunique().sort_values(ascending = True)
#to know how many distinct average ratings exist for each genre,
#which can be useful for seeing the diversity of ratings within each genre


# In[23]:


vote_grouped_zero.plot.barh(title  ='Vote average by Genre')


# ## H1. The best movies according to vote avg., return high profit and revenue

# In[27]:


movies_genre =movies[['popularity','budget', 'revenue','original_title','runtime','genres','release_date','vote_count','vote_average','Profit']]
movies_genre.head()


# In[31]:


# In order to increase the accuracy of the data, only movies with vote_count > 50 are taking account for the analysis
movies_counted = movies_genre[movies_genre['vote_count'] > 50]
# spearman is used to not take into account too much in consideration the outlires
movies_counted.corr(method = 'spearman', numeric_only= True)


# In[35]:


import seaborn as sns
sns.regplot(x = 'vote_average', y= 'Profit', data = movies_counted,  line_kws=dict(color="r"))
#Very tiny correlation between vote_avg and the Profit


# In[37]:


sns.regplot(x = 'vote_average', y= 'revenue', data = movies_counted,  line_kws=dict(color="r"))
#Similar correlation as with the Profit


# ##  H2. The best movie according to popularity,return high profit and revenue

# In[38]:


movies_counted.corr(method = 'spearman', numeric_only= True)
# Higher correlation between the popularity and the profit, corr = 0.499


# In[41]:


sns.regplot(x = 'popularity', y= 'Profit', data = movies_counted,  line_kws=dict(color="r"))


# ## H3. Highly budgeted movies return high profit

# In[42]:


movies_counted.head()


# In[45]:


import matplotlib.pyplot as plt
sns.regplot(x = 'budget', y= 'Profit', data = movies_counted,  line_kws=dict(color="r"))
plt.show()


# ## H4. Highly budgeted movies have a high popularity

# In[46]:


import matplotlib.pyplot as plt
sns.regplot(x = 'budget', y= 'popularity', data = movies_counted,  line_kws=dict(color="r"))
plt.show()
#It exists a correletion here 


# ## H5. Check how the Profit varies per genre and per year

# In[58]:


# Select relevant columns from the movies DataFrame
movies_genre_year = movies[['popularity', 'budget', 'revenue', 'original_title', 'runtime', 'genres', 'release_year', 'vote_count', 'vote_average', 'Profit']]
from pandas import DataFrame

# Split the 'genres' column on '|', expand into multiple columns, and stack to get a single column
split = movies_genre_year['genres'].str.split(pat='|').apply(lambda x: pd.Series(x)).stack()

# Reset the index to align with movies_genre_year
split.index = split.index.droplevel(-1)
split.name = 'genres_split'

# Remove the original 'genres' column
movies_genre_year = movies_genre_year.drop(columns='genres')

# Join the expanded genre data back to the original dataframe
movies_genre_year = movies_genre_year.join(split)
movies_genre_year.head()


# In[70]:


time_genre = pd.DataFrame(movies_genre_year.groupby(['release_year','genres_split'])['Profit'].mean())
time_genre


# In[72]:


finale_genre = pd.pivot_table(time_genre, values = 'Profit', index = 'genres_split', columns = 'release_year')


# In[80]:


sns.set(rc = {'figure.figsize' : (15,10)})
sns.heatmap(finale_genre, cmap = 'coolwarm', linewidths = .5)
plt.title('Genres by Profit Per Year')
plt.show()
# The profit tends to increase for the genre Adventure and Fantasy over the time


# In[ ]:




