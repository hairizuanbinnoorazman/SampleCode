if(!require(RSelenium)){
  install.packages("RSelenium")
  library(RSelenium)
}

## Requires firefox to be installed on host computer to prevent complications
## Default browser is firefox

## First time require to run this but no harm running again.
## Installs the Selenium Remote Web server on Host Computer 
## to control the browser
RSelenium::checkForServer()

## Start selenium remote browser (Firefox will come live)
RSelenium::startServer()
remDr <- remoteDriver(remoteServerAddr = "localhost" 
                      , port = 4444
                      , browserName = "firefox"
)
remDr$open()




# For findElement, there are only these entries:
# xpath
# css selector
# id
# name
# tag name
# class name
# link text
# partial link text


username = "XXX"
password = "XXX"

## Sample website to access
loginToGoogleAnalytics<-function(username, password){
    remDr$navigate("http://www.google.com/analytics/")
    webElem<-remDr$findElement(using = "link text", value = "Sign in")
    webElem$clickElement()
    webElem<-remDr$findElement(using = "name", value = "Email")
    webElem$sendKeysToElement(list(username))
    webElem<-remDr$findElement(using = "name", value = "Passwd")
    webElem$sendKeysToElement(list(password))
    webElem<-remDr$findElement(using = "name", value = "signIn")
    webElem$clickElement()
}

changeDateGoogleAnalytics<-function(startDate, endDate){
  webElem<-remDr$findElement(using = "class", value = "_GAYu")
  webElem$clickElement()
  webElem<-remDr$findElement(using = "xpath", value = '//*[@id="ID-dateControl"]/div[2]/table/tbody/tr/td[2]/div/div[2]/input[1]')
  #webElem<-remDr$findElement(using = "class", value = "ID-datecontrol-primary-start._GAUj.ACTION-daterange_input.TARGET-primary_start._GAdp")
  webElem$clearElement()
  webElem$sendKeysToElement(list(startDate))
  webElem<-remDr$findElement(using = "xpath", value = '//*[@id="ID-dateControl"]/div[2]/table/tbody/tr/td[2]/div/div[2]/input[2]')
  webElem$clearElement()
  webElem$sendKeysToElement(list(endDate))
  webElem<-remDr$findElement(using = "xpath", value = '//*[@id="ID-dateControl"]/div[2]/table/tbody/tr/td[2]/div/input')
  webElem$clickElement()
}



remDr <- remoteDriver(remoteServerAddr = "localhost" 
                      , port = 4444
                      , browserName = "firefox"
)
remDr$open()
loginToGoogleAnalytics("hairizuanbinnoorazman@gmail.com", "Assgghjyugyujoiuoiuoijuoi89")
changeDateGoogleAnalytics("Nov 15, 2014", "Dec 12, 2014")
remDr$maxWindowSize()
pic<-remDr$screenshot()

webElem<-remDr$findElements(using = "link text", value="All Web Site Data")
yahoo<-webElem[[1]]
yahoo$clickElement()
