
   


## Project description

Visit https://aprscraper.herokuapp.com/


How it`s made

## 1. NBS website.
   - Since the APR website cannot be scraped headlessly, first step was to scrape all possible tax identification numbers in Serbia on the National Bank of Serbia website.
   - Every positive hit, that returns current account number,returns a uniform registry number (MB) and tax identification number (PIB) as a combination.
   - This info is saved in sql table.
   - Technologies used - Mechanize. It took aprox. 1.5 months to try several milion numbers. Data gathered was around 170.000 of valid MB numbers.
   - NBS website doeasnt have a good ban policy for this kind of scraping.
## 2. Next is scraping of APR website.
   - APR uses JS for search fields, so Mechanize wouldnt do. Capybara + phantomjs were used for headless scraping.
   - Each page set was defined with SitePrism. A page set coresponds with type of company.
   - APR webiste has much better protection. In addition to JS, it temporary bans the apps adress, for aprox. 24 hours.
   - In each turn, it allows only about 100 pages to be scraped from one adress. This part took the longest. Three apps were used, local and cloud. Approx. 8 months for 65.77%  coverage of cca. 170.000 companies according to official data.
## 3. Cleaning raw data.
   - Data had to be extracted using regular expressions, and saved to new mysql database.
   - It was easier to upload raw file to app, and then to add every file 1 by 1.
## 4. Presentation.
   - Again data had to be reorganized to match criteria of network visualization software.
   - Cytoscape is used for complete network images.
   - Cytoscape.js is used in-app for graphic representation of single searched entities and their connected entities.
   - Out of 111k companies, only around 30% are used for onepic-graph of economy, because of memory and cpu limits.


Visit https://aprscraper.herokuapp.com/
