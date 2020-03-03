## import pandas as pd

## import numpy as np


## path='./data/COVID-19/csse_covid_19_data/csse_covid_19_time_series/'

## confirmed = pd.read_csv(path+'time_series_19-covid-Confirmed.csv')

## recovered = pd.read_csv(path+'time_series_19-covid-Recovered.csv')

## deaths = pd.read_csv(path+'time_series_19-covid-Deaths.csv')


## print(confirmed.shape)

## print(recovered.shape)

## print(deaths.shape)

## confirmed.head()


## recovered.head()


## deaths.head()


## import matplotlib.pyplot as plt

## plt.rcParams['font.sans-serif']=['SimHei']#用来正常显示中文标签

## plt.rcParams['axes.unicode_minus']=False#用来正常显示负号


## countries = confirmed['Country/Region'].unique()

## print(countries)

## print(len(countries))


## all_confirmed=np.sum(confirmed.iloc[:,4:])

## all_recovered=np.sum(recovered.iloc[:,4:])

## all_deaths=np.sum(deaths.iloc[:,4:])

## all_confirmed.head()


## import matplotlib.ticker as tkr

## fig,ax = plt.subplots()

## ax.plot([i[:-3] for i in all_confirmed.index],all_confirmed.values,color='red',label='确诊',marker='o',markersize=2)

## ax.plot([i[:-3] for i in all_confirmed.index],all_recovered.values,color='blue',label='治愈',marker='x',markersize=2)

## ax.plot([i[:-3] for i in all_confirmed.index],all_deaths.values,color='lime',label='死亡',marker='*',markersize=2)

## ax.xaxis.set_major_locator(tkr.MultipleLocator(2.0))

## ax.xaxis.set_minor_locator(tkr.MultipleLocator(1.0))

## ##set the str format of major ticker of X axis

## #ax.xaxis.set_major_formatter(tkr.FormatStrFormatter('%m/%d/%y'))

## #ax.xaxis.set_ticklabels([i[:-3] for i in all_confirmed.index[::2]],rotation=45)

## #all_confirmed.index[::2]#取出奇数位置的元素

## plt.xticks(rotation=45)

## plt.yticks()

## ax.set(xlabel='时间',ylabel='数目')

## plt.legend(loc='upper left',fontsize = 10)

## plt.tight_layout()

## plt.show()


## death_rate=(all_deaths/all_confirmed)

## import matplotlib.ticker as tkr

## fig,ax=plt.subplots()

## ax.plot([i[:-3] for i in death_rate.index],death_rate.values,color='lime',label='死亡率',marker='o',markersize=3)

## ax.xaxis.set_major_locator(tkr.MultipleLocator(2.0))

## ax.xaxis.set_minor_locator(tkr.MultipleLocator(1.0))

## ## set the str format of major ticker of X axis

## #ax.xaxis.set_major_formatter(tkr.FormatStrFormatter('%m/%d'))

## #ax.xaxis.set_ticklabels([i[:-3] for i in death_rate.index[::2]],rotation=45)

## plt.xticks(rotation=45)

## plt.yticks()

## ax.set(xlabel='时间',ylabel='死亡率')

## #plt.title('全球疫情死亡率',size=30)

## plt.tight_layout()

## plt.show()


## last_update = confirmed.columns[-1] # 设置最新数据日期

## China_cases = confirmed[['Province/State',last_update]][confirmed['Country/Region'] == 'Mainland China']

## China_cases['recovered'] = recovered[[last_update]][recovered['Country/Region'] == 'Mainland China']

## China_cases['deaths']=deaths[[last_update]][deaths['Country/Region']=='Mainland China']

## China_cases = China_cases.set_index('Province/State')

## China_cases = China_cases.rename(columns = {last_update:'confirmed'})

## China_cases.head()


## #'Country/Region'

## fig,ax=plt.subplots()

## Mainland_China = China_cases.sort_values(by = 'confirmed',ascending = True)

## Mainland_China.plot(kind = 'barh',color=['red','blue','lime'],figsize=(20,30),ax=ax)

## plt.xticks(fontsize=35)

## plt.yticks(fontsize=35)

## ax.set_xlabel('数量',fontsize=35)

## ax.set_ylabel('省/市',fontsize=35)

## plt.legend(bbox_to_anchor=(0.95,0.95),fontsize = 30)

## plt.tight_layout()

## plt.show()


## confirmed_China = confirmed[confirmed['Country/Region'] == 'Mainland China']

## #得到中国大陆每个省份每日的确诊人数

## confirmed_China = np.sum(confirmed_China.iloc[:,4:])

## #得到中国大陆每日共有的确诊人数

## recovered_China = recovered[recovered['Country/Region'] == 'Mainland China']

## #得到中国大陆每个省份每日的治愈人数

## recovered_China = np.sum(recovered_China.iloc[:,4:])

## #得到中国大陆每日共有的治愈人数

## deaths_China = deaths[deaths['Country/Region'] == 'Mainland China']

## #得到中国大陆每个省份每日的死亡人数

## deaths_China = np.sum(deaths_China.iloc[:,4:])

## #得到中国大陆每日共有的死亡人数

## recovered_rate = (recovered_China/confirmed_China)*100

## deaths_rate = (deaths_China/confirmed_China)*100


## fig,ax=plt.subplots()

## ax.plot([i[:-3] for i in deaths_rate.index],recovered_rate.values,color='blue',label='治愈率',marker='o',markersize=3)

## ax.plot([i[:-3] for i in deaths_rate.index],deaths_rate.values,color='lime',label='死亡率',marker='o',markersize=3)

## ax.xaxis.set_major_locator(tkr.MultipleLocator(2.0))

## ax.xaxis.set_minor_locator(tkr.MultipleLocator(1.0))

## ## set the str format of major ticker of X axis

## #ax.xaxis.set_major_formatter(tkr.FormatStrFormatter('%m/%d/%y'))

## #ax.xaxis.set_ticklabels([i[:-3] for i in deaths_rate.index[::2]],rotation=45)

## #plt.title('中国大陆治愈率 VS 死亡率',size=30)

## ax.set(xlabel='时间',ylabel='数量')

## #plt.ylabel("数量")

## #plt.xlabel('时间')

## plt.xticks(rotation=45)

## plt.yticks()

## plt.legend(loc = "upper left",fontsize = 10)

## plt.tight_layout()

## plt.show()


## others_cases = confirmed[['Country/Region',last_update]][confirmed['Country/Region'] != 'Mainland China']

## others_cases['recovered'] = recovered[[last_update]][recovered['Country/Region'] != 'Mainland China']

## others_cases['deaths'] = deaths[[last_update]][deaths['Country/Region'] != 'Mainland China']

## others_cases = others_cases.set_index('Country/Region')

## others_cases = others_cases.rename(columns = {last_update:'confirmed'})

## others_countries = others_cases.groupby('Country/Region').sum()

## #数据是按地区给的，需要用分组聚合统计每个国家的疫情数据

## others_countries.head()


## fig,ax=plt.subplots()

## others_countries.sort_values(by='confirmed',ascending=True).plot(kind='barh',figsize=(20,30),color=['red','blue','lime'],width=1,rot=2,ax=ax)

## ax.set_xlabel('数量',fontsize = 35)

## ax.set_ylabel('Country/Region',fontsize = 35)

## plt.yticks(fontsize = 30)

## plt.xticks(fontsize = 30)

## plt.legend(bbox_to_anchor=(0.95,0.95),fontsize = 30)

## plt.tight_layout()

## plt.show()

## others_countries['recovered'][others_countries['recovered']==max(others_countries.recovered)]


## confirmed_others = confirmed[confirmed['Country/Region']!= 'Mainland China']

## #世界其他地区每日的确诊人数

## confirmed_others = np.sum(confirmed_others.iloc[:,4:])

## #世界其他地区每日的确诊人数总和

## recovered_others = recovered[recovered['Country/Region']!= 'Mainland China']

## #世界其他地区每日的治愈人数

## recovered_others = np.sum(recovered_others.iloc[:,4:])

## #世界其他地区每日的治愈人数总和

## deaths_others = deaths[deaths['Country/Region'] != 'Mainland China']

## #世界其他地区每日的死亡人数

## deaths_others = np.sum(deaths_others.iloc[:,4:])

## #世界其他地区每日的死亡人数总和

## recover_rate = (recovered_others/confirmed_others)*100

## death_rate = (deaths_others/confirmed_others)*100


## fig,ax=plt.subplots()

## ax.plot([i[:-3] for i in death_rate.index],recover_rate.values,color='blue',label='治愈率',marker='o',markersize=3)

## ax.plot([i[:-3] for i in death_rate.index],death_rate.values,color='lime',label='死亡率',marker='o',markersize=3)

## ax.xaxis.set_major_locator(tkr.MultipleLocator(2.0))

## ax.xaxis.set_minor_locator(tkr.MultipleLocator(1.0))

## ## set the str format of major ticker of X axis

## #ax.xaxis.set_major_formatter(tkr.FormatStrFormatter('%m/%d/%y'))

## #ax.xaxis.set_ticklabels([i[:-3] for i in death_rate.index[::2]],rotation=45)

## #plt.title('世界其他地区治愈率 VS 死亡率',size=30)

## ax.set(ylabel='数量',xlabel='时间')

## plt.xticks(rotation=45)

## plt.yticks()

## plt.legend(loc = "upper left",fontsize = 10)

## plt.tight_layout()

## plt.show()


## import folium

## others = confirmed[['Country/Region','Lat','Long',last_update]][confirmed['Country/Region'] != 'Mainland China']

## others['recovered'] = recovered[[last_update]][recovered['Country/Region'] != 'Mainland China']

## others['death'] = deaths[[last_update]][deaths['Country/Region'] != 'Mainland China']

## others_countries = others.rename(columns = {last_update:'confirmed'})

## others_countries.loc['145'] = ['Mainland China',30.9756,112.2707,confirmed_China[-1],recovered_China[-1],deaths_China[-1]]

## #confirmed_China[-1]是中国大陆2月28日的确诊人数,把巴基斯坦的数据更换为中国大陆数

## #据。

## #others_countries.to_csv('./results/othercountries.csv',index_label=False)


## ----tab1,results='markup', cache=F,echo=F-------------------------------
library("kableExtra")
library('utils')
tab1 = read.csv('./results/othercountries.csv')
knitr::kable(tab1[1:10,], row.names =F, align = c("l",rep('c',5)), caption="各个国家疫情发展情况",
             longtable = TRUE, booktabs = TRUE, linesep  = "")%>%
             kable_styling(latex_options = c("striped", "scale_down", "repeat_header", "hold_position"),repeat_header_text = "(续)")%>%
             kable_styling(full_width = T) %>%
             column_spec(1, width = c("2.5cm"))
			 


## world_map = folium.Map(location=[10, -20], zoom_start=2.3,tiles='Stamen Terrain')


## for lat, lon, value, name in zip(others_countries['Lat'], others_countries['Long'], others_countries['confirmed'], others_countries['Country/Region']):

##     folium.CircleMarker([lat, lon],

##                             radius=10,

##                             popup = ('<strong>Country</strong>: ' + str(name).capitalize() + '<br>'

##                             '<strong>Confirmed Cases</strong>: ' + str(value) + '<br>'),

##                             color='red',

##                             fill_color='red',

##                             fill_opacity=0.3 ).add_to(world_map)

## 

## world_map

## world_map.save('./results/world_map.html')

## import webbrowser

## webbrowser.open('world_map.html')


## ----fig10,eval=T,echo=F,fig.cap="全球疫情分布图",dev="png",results='markup',fig.width=6----
knitr::include_graphics("./results/fol.png")


## import plotly.express as px


## confirmed = confirmed.melt(id_vars = ['Province/State','Country/Region','Lat', 'Long'],var_name='date',value_name = 'confirmed')


## confirmed['date_dt'] = pd.to_datetime(confirmed.date, format="%m/%d/%y")

## confirmed.date = confirmed.date_dt.dt.date

## confirmed.rename(columns={'Country/Region': 'country', 'Province/State': 'province'}, inplace=True)

## #confirmed=confirmed.to_csv('./results/confirmed.csv',index_label=False)


## ----tab2,results='markup',echo=F----------------------------------------
library("kableExtra")
library('utils')
tab2 = read.csv('./results/confirmed.csv')
knitr::kable(tab2[1:10,], row.names =F, align = c("l",rep('c',6)), caption="各个地区疫情确诊情况",
             longtable = TRUE, booktabs = TRUE, linesep  = "")%>%
             kable_styling(latex_options = c("striped", "scale_down", "repeat_header", "hold_position"),repeat_header_text = "(续)")%>%
             kable_styling(full_width = T) %>%
             column_spec(1, width = c("2.5cm"))


## recovered = recovered.melt(id_vars = ['Province/State', 'Country/Region', 'Lat', 'Long'], var_name='date',value_name = 'recovered')

## recovered['date_dt'] = pd.to_datetime(recovered.date, format="%m/%d/%y")

## recovered.date = recovered.date_dt.dt.date

## recovered.rename(columns={'Country/Region': 'country', 'Province/State': 'province'}, inplace=True)

## #recovered=recovered.to_csv('./results/recovered.csv',index_label=False)

## deaths = deaths.melt(id_vars = ['Province/State', 'Country/Region', 'Lat', 'Long'], var_name='date', value_name = 'deaths')

## deaths['date_dt'] = pd.to_datetime(deaths.date, format="%m/%d/%y")

## deaths.date = deaths.date_dt.dt.date

## deaths.rename(columns={'Country/Region': 'country', 'Province/State': 'province'}, inplace=True)

## #deaths=deaths.to_csv('./results/deaths.csv',index_label=False)

## ----tab3, eval=T,results='markup', cache=F,echo=F-----------------------
library("kableExtra")
library('utils')
tab3 = read.csv('./results/recovered.csv')
knitr::kable(tab3[1:10,], row.names =F, align = c("l",rep('c',6)), caption="各个地区疫情治愈情况",
             longtable = TRUE, booktabs = TRUE, linesep  = "")%>%
             kable_styling(latex_options = c("striped", "scale_down", "repeat_header", "hold_position"),repeat_header_text = "(续)")%>%
             kable_styling(full_width = T) %>%
             column_spec(1, width = c("2.5cm"))


## ----tab4, eval=T,results='markup', cache=F,echo=F-----------------------
library("kableExtra")
library('utils')
tab4 = read.csv('./results/deaths.csv')
knitr::kable(tab4[1:10,],row.names =F, align = c("l",rep('c',6)), caption="各个地区疫情死亡情况",
             longtable = TRUE, booktabs = TRUE, linesep  = "")%>%
             kable_styling(latex_options = c("striped", "scale_down", "repeat_header", "hold_position"),repeat_header_text = "(续)")%>%
             kable_styling(full_width = T) %>%
             column_spec(1, width = c("2.5cm"))


## merge_on = ['province', 'country', 'date']

## all_data = confirmed.merge(deaths[merge_on + ['deaths']], how='left', on=merge_on).merge(recovered[merge_on + ['recovered']], how='left', on=merge_on)

## confirmed.shape,recovered.shape,deaths.shape


## Coronavirus_map = all_data.groupby(['date_dt', 'province'])['confirmed', 'deaths','recovered', 'Lat', 'Long'].max().reset_index()

## Coronavirus_map['size'] = Coronavirus_map.confirmed.pow(0.5)  # 创建实心圆大小

## Coronavirus_map['date_dt'] = Coronavirus_map['date_dt'].dt.strftime('%Y-%m-%d')

## #Coronavirusmap=Coronavirus_map.to_csv('./results/Coronavirusmap.csv',index_label=False)

## 
## ----tab5, eval=F,results='markup', cache=F,echo=F-----------------------
## library("kableExtra")
## library('utils')
## tab5 = read.csv('./results/Coronavirusmap.csv')
## #booktabs = TRUE表示生成三线表
## #longtable = TRUE表示续页
## knitr::kable(tab5[1:10,],row.names =F,align = c("l",rep('c',7)), caption="各个地区疫情发展情况",
##              longtable = TRUE, booktabs = TRUE, linesep  = "")%>%
##              kable_styling(latex_options = c("striped", "scale_down", "repeat_header", "hold_position"),repeat_header_text = "(续)")%>%
##              kable_styling(full_width = T) %>%
##              column_spec(1:8, width = c('1.5cm','2cm','1.2cm','1cm','1.1cm',rep('1cm',3)))
## 


## fig = px.scatter_geo(Coronavirus_map, lat='Lat', lon='Long', scope='asia',

##                      color="size", size='size', hover_name='province',

##                      hover_data=['confirmed', 'deaths', 'recovered'],

##                      projection="natural earth",animation_frame="date_dt",title='亚洲地区疫情扩散图')

## fig.update(layout_coloraxis_showscale=False)

## #fig.show()


## ----fig11,eval=T,results = 'hide', echo=F,fig.cap="亚洲地区疫情扩散图",dev="png",results='markup', cache=F----
knitr::include_graphics("./results/px.png")

