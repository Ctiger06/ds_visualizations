---
title: "insuranceclaims"
author: "Christie"
date: "January 16, 2017"
output: html_document
---

# Insurance Claim Fraud




```
##   claim_id customer_id age gender     incident_cause days_to_incident
## 1 54004764    21868593  32 Female       Driver error              225
## 2 33985796    75740424  60 Female              Crime            11874
## 3 53522022    30308357  27 Female Other driver error                4
## 4 13015401    47830476  39 Female     Natural causes             5278
## 5 22890252    19269962  47   Male              Crime             2335
##   claim_area police_report    claim_type claim_amount total_policy_claims
## 1       Auto            No Material only       2980.0                   1
## 2       Home       Unknown Material only       2980.0                   3
## 3       Auto            No Material only       3369.5                   1
## 4       Auto            No Material only       1680.0                   1
## 5       Auto            No Material only       2680.0                   1
##   fraudulent
## 1         No
## 2         No
## 3        Yes
## 4         No
## 5         No
```


## _Exploratory Data Analysis_
### Sample Data

Below shows a small sample of the insurance fraud data.
<!-- html table generated in R 3.2.2 by xtable 1.7-4 package -->
<!-- Sun Mar 12 21:01:41 2017 -->
<table border=1>
<tr> <th>  </th> <th> claim_id </th> <th> customer_id </th> <th> age </th> <th> gender </th> <th> incident_cause </th> <th> days_to_incident </th> <th> claim_area </th> <th> police_report </th> <th> claim_type </th> <th> claim_amount </th> <th> total_policy_claims </th> <th> fraudulent </th>  </tr>
  <tr> <td align="right"> 1 </td> <td align="right"> 54004764 </td> <td align="right"> 21868593 </td> <td align="right">  32 </td> <td> Female </td> <td> Driver error </td> <td align="right"> 225 </td> <td> Auto </td> <td> No </td> <td> Material only </td> <td align="right"> 2980.00 </td> <td align="right">   1 </td> <td> No </td> </tr>
  <tr> <td align="right"> 2 </td> <td align="right"> 33985796 </td> <td align="right"> 75740424 </td> <td align="right">  60 </td> <td> Female </td> <td> Crime </td> <td align="right"> 11874 </td> <td> Home </td> <td> Unknown </td> <td> Material only </td> <td align="right"> 2980.00 </td> <td align="right">   3 </td> <td> No </td> </tr>
  <tr> <td align="right"> 3 </td> <td align="right"> 53522022 </td> <td align="right"> 30308357 </td> <td align="right">  27 </td> <td> Female </td> <td> Other driver error </td> <td align="right">   4 </td> <td> Auto </td> <td> No </td> <td> Material only </td> <td align="right"> 3369.50 </td> <td align="right">   1 </td> <td> Yes </td> </tr>
  <tr> <td align="right"> 4 </td> <td align="right"> 13015401 </td> <td align="right"> 47830476 </td> <td align="right">  39 </td> <td> Female </td> <td> Natural causes </td> <td align="right"> 5278 </td> <td> Auto </td> <td> No </td> <td> Material only </td> <td align="right"> 1680.00 </td> <td align="right">   1 </td> <td> No </td> </tr>
  <tr> <td align="right"> 5 </td> <td align="right"> 22890252 </td> <td align="right"> 19269962 </td> <td align="right">  47 </td> <td> Male </td> <td> Crime </td> <td align="right"> 2335 </td> <td> Auto </td> <td> No </td> <td> Material only </td> <td align="right"> 2680.00 </td> <td align="right">   1 </td> <td> No </td> </tr>
   </table>



```r
kable(head(train, 5), digits = 2, align = c(rep("l", 4), rep("c", 4), rep("r", 4)))
```



|claim_id |customer_id |age |gender |   incident_cause   | days_to_incident | claim_area | police_report |    claim_type| claim_amount| total_policy_claims| fraudulent|
|:--------|:-----------|:---|:------|:------------------:|:----------------:|:----------:|:-------------:|-------------:|------------:|-------------------:|----------:|
|54004764 |21868593    |32  |Female |    Driver error    |       225        |    Auto    |      No       | Material only|       2980.0|                   1|         No|
|33985796 |75740424    |60  |Female |       Crime        |      11874       |    Home    |    Unknown    | Material only|       2980.0|                   3|         No|
|53522022 |30308357    |27  |Female | Other driver error |        4         |    Auto    |      No       | Material only|       3369.5|                   1|        Yes|
|13015401 |47830476    |39  |Female |   Natural causes   |       5278       |    Auto    |      No       | Material only|       1680.0|                   1|         No|
|22890252 |19269962    |47  |Male   |       Crime        |       2335       |    Auto    |      No       | Material only|       2680.0|                   1|         No|



```r
library(stargazer, quietly = TRUE)


stargazer(train, type = 'html')
```


<table style="text-align:center"><tr><td colspan="6" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Statistic</td><td>N</td><td>Mean</td><td>St. Dev.</td><td>Min</td><td>Max</td></tr>
<tr><td colspan="6" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">claim_id</td><td>1,100</td><td>48,838,190.000</td><td>29,188,060.000</td><td>26,832</td><td>99,775,483</td></tr>
<tr><td style="text-align:left">customer_id</td><td>1,100</td><td>50,874,698.000</td><td>28,461,020.000</td><td>154,557</td><td>99,961,993</td></tr>
<tr><td style="text-align:left">age</td><td>1,100</td><td>47.797</td><td>17.628</td><td>18</td><td>79</td></tr>
<tr><td style="text-align:left">days_to_incident</td><td>1,100</td><td>2,814.125</td><td>2,784.766</td><td>2</td><td>14,991</td></tr>
<tr><td style="text-align:left">claim_amount</td><td>1,100</td><td>12,317.580</td><td>13,687.810</td><td>1,000.000</td><td>48,150.500</td></tr>
<tr><td style="text-align:left">total_policy_claims</td><td>1,100</td><td>1.596</td><td>1.151</td><td>1</td><td>8</td></tr>
<tr><td colspan="6" style="border-bottom: 1px solid black"></td></tr></table>
