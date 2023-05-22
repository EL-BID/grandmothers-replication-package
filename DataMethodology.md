## Data Methodology

### Data: 3GenPanel.dta

The primary data source is the Mexican National Survey of Occupation and Employment (ENOE). The ENOE is the largest household survey conducted in Mexico, and it is superior to administrative data in this context because it includes both the formal and informal sectors of the economy. Its data collection occurs quarterly in a rotating panel format with five observations per household. The ENOE data in this paper spans Q1 of 2005 to Q1 of 2020, a total of 61 surveys (one per quarter). Each survey visits approximately 120,000 households. The survey's demographics section includes information on every member of the household, such as their relationship to the head of household, gender, education, marital status, reason for not living in the household anymore (after the first survey), access to health care, employment, income, and hours worked.
The ENOE database comprises five questionnaires: the Living Place, the Household, the Sociodemographic, and two Occupation and Employment Questionnaires. The paper uses Sociodemographic and Occupation and Employment questionnaires

### Building the 3-Generations Panel

Starting with the sociodemographic questionnaire (SDEMT), I merged the time use variables from the Occupation and Employment sub-database (COE2T) and appended the responses for all the survey waves. 
Households in the ENOE are unique within a quarter but not necessarily across time. That means there is the possibility of having two different families with the same identifier. To address this, I add to the household identifier the year_quarter the first interview occurred

### Cleaning date of birth and age

The date of birth is in the year, month, and day format. To clean these variables, if for the same individual, two of them are the same in the previous or next period, but one of them is different, I adjust this variable to match. If the age is not consistent across surveys, but the date of birth is the same, I replace the inconsistent age with the one consistent with the date of birth.

### Identifying 3-Generations Households

I created seven new variables that identify three different generations based on the relation to the household head. The ENOE has three kinship classifications (2005, 2008, and 2012). Using those dictionaries, I created the following variables: 
- Descendant: Son/daughter, son/daughter-in-law, nephew/niece, anyone under guardianship, godson/goddaughter, student/pupil 
- Ascendant: Mother/father, stepmother/stepfather, mother/father-in-law, uncle/aunt, tutor/guardian, godmother/godfather.
- Ascendent_2: Grandmother/grandfather
- Descendant_2: Grandson/granddaughter. 
- Main: Household head, husband/wife or any partner, father/mother-in-law of one's son/daughter, friend, brother/sister, stepbrother/stepsister, half-brother/sister, cousin, non-relative, brother/sister-in-law, brother/sister in law's brother/sister.
- Ascendant_3: great-grandfather/mother, great-great-grandfather/mother
- Descendant_3: great-grandson/daughter, great-great-grandson/daughter
Using this classification, I create the generations variable with the number of generations living in the household. I keep only households with three generations.  

### Additional Data Sources

- I use the National Survey of Employment and Social Security (ENESS) to construct measures of public and private daycare costs. It is available for 2009, 2013, and 2017. As an accompanying module of the ENOE, it covers all the households covered by the ENOE for two out of the three months in the quarter. Hence, the ENESS covers roughly two-thirds of the ENOE sample for the quarter. The ENESS data includes responses from 209,266 households. These households use public and private daycare providers for 3,991 and 1,177 children under seven years old.  
To create the measure of cost and hourly cost for public and private daycares: first, I merge to the panel the average costs at the locality level for 2009, 2013, and 2017; second, I demean these costs by year; third, I average these demeaned costs to have only one cost per locality, and fourth, I standardize. 
- I use the National Economic Units Statistical Directory (DENUE) of 2015 to construct childcare availability measures. The DENUE lists all the public and private daycare facilities. Based on the February 25, 2015, version, I added the number of daycare facilities of each type (private or public) at the municipality level. I divide this number by the number of children up to five years old to create the availability measures.
- I use The 2020 Census to obtain the population of children under five years old at the municipality level. 
- I use the 2016 Directory of Estancias Infantiles to measure the availability of these daycares at the municipality level. I divide the number of these daycares at the municipality level by the number of children up to five years old. 