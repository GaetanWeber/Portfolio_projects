#!/usr/bin/env python
# coding: utf-8

# In[ ]:


from bs4 import BeautifulSoup
import requests

import os
import pandas as pd

from datetime import datetime
import time

def automated_crypto():
    
    url ='https://coinmarketcap.com/currencies/bitcoin/'
    page = requests.get(url)
    soup = BeautifulSoup(page.text,'html')

    currency_name = soup.find('span',class_="sc-65e7f566-0 lsTl", title="Bitcoin").text
    crypto_name = currency_name.split(" ")[0]


    crypto_price = soup.find('span',class_='sc-65e7f566-0 clvjgF base-text').text
    final_price = crypto_price.replace('$','')


    date_time = datetime.now()


    dict = {'Crypto_name': crypto_name,
             'Price': final_price,
            'TimeStamp':date_time}
    
    df = pd.DataFrame (dict, index = [0])
   

    if os.path.exists(r'C:\Users\Gaetan.WEBER\Desktop\Portfolio project\Python\Crypto Web Scrapper'):
        df.to_csv(r'C:\Users\Gaetan.WEBER\Desktop\Portfolio project\Python\Crypto Web Scrapper/Crypto_Automated_scrapper.csv', mode ='a', header = False, index = False)
    else:
        df.to_csv(r'C:\Users\Gaetan.WEBER\Desktop\Portfolio project\Python\Crypto Web Scrapper/Crypto_Automated_scrapper.csv')
 
    print(df)
    
    


# In[ ]:


automated_crypto()


# In[ ]:


while True:
    automated_crypto()
    time.sleep(10)

