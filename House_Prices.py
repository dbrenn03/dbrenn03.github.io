#!/usr/bin/env python
# coding: utf-8

# In[67]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score

sns.set()
get_ipython().run_line_magic('matplotlib', 'inline')

import statsmodels.formula.api as smf


# In[68]:


df = pd.read_csv("C:/Users/domin/OneDrive/Desktop/Advanced Programming/canada_per_capita_income.csv")


# In[69]:


df.head()


# In[70]:


df.shape


# In[71]:


df.isnull().values.any()


# In[72]:


train_set, test_set = train_test_split(df, test_size=0.2, random_state=42)


# In[73]:


df_copy = train_set.copy()


# In[74]:


df_copy.shape


# In[75]:


df_copy.head()


# In[76]:


df_copy.describe()


# In[77]:


df_copy.corr()


# In[78]:


sns.regplot(x='year', y='per_capita_income_USDollars',data=df_copy)


# In[79]:


test_set_full = test_set.copy()

test_set = test_set.drop(["per_capita_income_USDollars"], axis=1)


# In[80]:


test_set.head()


# In[81]:


train_labels = train_set["per_capita_income_USDollars"]


# In[82]:


train_labels.head()


# In[83]:


train_set_full = train_set.copy()

train_set = train_set.drop(["per_capita_income_USDollars"], axis=1)


# In[84]:


train_set.head()


# In[85]:


lin_reg = LinearRegression()

lin_reg.fit(train_set, train_labels)


# In[86]:


print(lin_reg)


# In[87]:


salary_pred = lin_reg.predict(test_set)

salary_pred


# In[88]:


print("Coefficients: ", lin_reg.coef_)
print("Intercept: ", lin_reg.intercept_)


# In[89]:


print(salary_pred)
print(test_set_full["per_capita_income_USDollars"])


# In[90]:


815.1425*20


# In[91]:


16302.85 + 25321.58


# In[92]:


lin_reg.predict([[2020]])


# In[94]:


# Create a fitted model 
lm = smf.ols(formula="per_capita_income_USDollars~year", data=df_copy).fit()


# In[98]:


ypred = lm.predict({'year':[2020]})
print(ypred)


# In[99]:


import statsmodels.formula.api as smf


# In[100]:


print(lm.summary())


# In[ ]:




