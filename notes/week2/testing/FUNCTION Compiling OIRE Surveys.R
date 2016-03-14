#******************************************************************
# Function that will automatically read in SPSS files and compile surveys across years
# into long and lean format for Tableau with demographics and panel data repeated for 
# each question row
#******************************************************************
library(foreign)
library(plyr)

compile_OIRE_surveys <- function(surveywd, outputDirectory, dictionaryName, population, outputName) {

  setwd(surveywd)
  dict_full <- read.csv(dictionaryName, check.names=FALSE)
  
  dict <- dict_full[dict_full$`Question Type`!="",]
  
  setwd(paste(surveywd,"Survey Data",sep="/"))
  dslist <- list()
  
  for (i in 1:length(list.files())) {
    
    fileName <- list.files()[i]
    
    ds_data_full <- read.spss(fileName, to.data.frame=FALSE, use.value.labels=FALSE)
    data_labels <- attr(ds_data_full,"label.table")
    data_names <- attr(ds_data_full,"variable.labels")
    qnames <- attr(ds_data_full,"names")
    
    #Shorten the data to only what we want to keep
    
    year <- survey_year(fileName)
    
    dc <- which(colnames(dict)==year)
    
    keepme <- which(attr(ds_data_full,"names") %in% dict[,dc])
    
    ds_data <- ds_data_full[keepme]
    attr(ds_data,"label.table") <- data_labels[keepme]
    attr(ds_data,"variable.labels") <- data_names[keepme]
    
    #Discover what attributes are included when we read in this data
    myattributes <- names(attributes(ds_data))
    #Results: "label.table", "variable.labels", "names", "codepage"
    #We want to be able to access the first 3; codepage does not seem useful

    #Want to include our own quesiton type labeling in here...
    attr(ds_data,"question.type") <- rep("",length(ds_data))
    attr(ds_data,"question.subtype") <- rep("",length(ds_data))

    #Add in the attribute names from the dictionary
    panel_items <- c()
    text_items <- c()
    instruction <- c()
    question_items <- c()
    
    mynum <- c()
    
    
    #Get our question types and subtypes read in so we can standardize variables; use this in function
    for (qt in 1:length(ds_data)) {
      if(names(ds_data)[qt] %in% dict[,dc]) {
        mynum <- c(mynum,qt)
        dict_row <- which(names(ds_data)[qt]==dict[,dc])
        attr(ds_data,"question.type")[qt] <- as.matrix(dict$`Question Type`)[dict_row]
        if ((dict$`Question Subtype`[dict_row]=="")==FALSE && is.na(dict$`Question Subtype`[dict_row])==FALSE){
          attr(ds_data,"question.subtype")[qt] <- as.matrix(dict$`Question Subtype`)[dict_row]
        }   
      }
      #attr(ds_data,"question.type")[[qt]] <- 
    }
    
    #Now we want to standardize variable coding
    
    #preserve old coding
    attr(ds_data,"ORIGINAL_label.table") <- attr(ds_data,"label.table")
    
    likert_q <- which(attr(ds_data,"question.type")=="Likert")
    
    for (lnum in 1:length(likert_q)) {
      lq <- likert_q[lnum]
      codebook <- attr(ds_data,"label.table")[[lq]]
      lq_type <- attr(ds_data,"question.subtype")[[lq]]
      
#       print(attr(ds_data,"variable.label")[[lq]]) 
#       print(codebook)
#       print(lq_type)
# 
#       
#       codebook2 <- standard_var_coding(codebook,lq_type)
#       
#       print("Revised codebook: ")
#       print(codebook2)
#       
#       continue <- readline(prompt = "Do you want to continue to the next question?")
#       if (continue=="n") break
      
      attr(ds_data,"label.table")[[lq]] <- standard_var_coding(codebook,lq_type)

    }
    
    #Right now we are only choosing panel based on panel columns; however, we will
    #also want to include any data from demographic questions or other identifiers that
    #should be linked to all quesitons
    
    #In panelCol we want items that are type Qualtrics, Panel, Demographic
    #In qCol, we want things that (a) aren't in the panel and (b) aren't Text Entry or Instruction
    
    panelCol <- which(attr(ds_data,"question.type")=="Panel")
    
    qCol <- which(attr(ds_data,"question.type") %in% c("Likert","Y-N","MC","Check All", "Value"))
    
#     panel_items <- which(dict$`Question Type` %in% c("Qualtrics","Panel","Demographic"))
#     
#     panel_data <- dict[panel_items,]
    
    
    
    #panelCol <- which(names(ds_data) %in% panel_data[,dc])
    #qCol <- which(names(ds_data) %in% question_dict[,dc])
    
    # fileName <- list.files()[i]
    # #  ds <- read.spss(fileName, to.data.frame=TRUE, use.value.labels=FALSE)
    # setwd(paste(surveywd,"Codebook",sep="/"))
    # keyname <- list.files()[i]
    # key <- read.csv(keyname, check.names=FALSE)
    # setwd(paste(surveywd,"Survey Data",sep="/"))
    
    
    # ds <- read.spss(fileName,to.data.frame=TRUE, use.value.labels=FALSE)
    
    # panelCol <- which(substr(colnames(ds),1,1) != "Q")
    # qCol <- which(substr(colnames(ds),1,1) == "Q")
    qNumber <- length(qCol)
    pNumber <- length(panelCol)
    
    ds <- as.data.frame(ds_data)
    df <- matrix("",nrow=qNumber*nrow(ds), ncol=length(panelCol)+8)
    
    #Substitute the correct panel data into our data frame ds; this will be used to fill the new data frame...
    for (s in 1:pNumber) {
      panelKey <- attr(ds_data,"label.table")[[panelCol[s]]]
      if (length(panelKey)>0) {
        for (t in 1:nrow(ds)) {
          panelValue <- as.data.frame(ds_data)[t,panelCol[s]]
          
          #pvp is our panel value place
          
          pvp <- which(panelValue == panelKey)
          if (length(pvp)==1) {
            ds[t,panelCol[s]] <- names(pvp)
          }
        }
      }
    }
    
    
    #we're doing rows of ds since the other is just a list of columns, not rows
    
    for (k in 1:nrow(ds)) {
      
      #Need to generate the correct number of rows to include each question
      
      r <- qNumber*(k-1)+1
      r2 <- r+qNumber-1
      
      #Add panel data to all rows for the individual respondent
      
      panelData <- as.matrix(ds)[k,panelCol]
      for (l in 1:pNumber) {
        df[r:r2,l] <- panelData[[l]]
      }
      
      #Add year to ALL rows with the given panel data
      #Because we have separate continuing & exit for Fletcher, need to put the correct year data here
      
      if (substr(fileName,1,6)=="fltrce" && nchar(fileName)==15) {
        df[r:r2,pNumber+1] <- substr(year,1,4)
      }
      else {df[r:r2,pNumber+1] <- year}
      
      #Values
      #Now substitue quesiton values and names for all quesitons
      
      for(q in 1:qNumber) {
        
        #Question code
        attrNum <- qCol[q]
        qvar <- names(ds_data)[attrNum]
        
        df[r+q-1,pNumber+2] <- qvar
        
        #Variable Name
        n <- which(qvar==dict[,dc])
        qText <- as.matrix(dict$`Variable Name`)[n]
        df[r+q-1,pNumber+3] <- qText
        
        #Variable Text
        df[r+q-1,pNumber+4] <- as.matrix(dict$`Question Text`)[n]
        
        #Coded values
        
        #Don't want to enter the loop unless there is a recorded value, so check for NA
        if (is.na(ds_data[[attrNum]][k])==FALSE) {
          codeValue <- ds_data[[attrNum]][k]
          df[r+q-1,pNumber+5] <- codeValue
          if (codeValue!=-99) {
          
          #Want to do this part without having to read in the codebook...
            qcode <- as.data.frame(attr(ds_data,"label.table")[attrNum])
            origcode <- as.data.frame(attr(ds_data,"ORIGINAL_label.table")[attrNum])
            if (length(qcode)>0) {
              valrow <- which(origcode==codeValue)
              df[r+q-1,pNumber+6] <- rownames(qcode)[valrow]
              df[r+q-1,pNumber+5] <- qcode[valrow,1]
              df[r+q-1,pNumber+6] <- rownames(qcode)[valrow]
              
              
              #Labeled value only if we have a coded value
              #         keyrows <- which(qvar==key$Question)
              #         if (length(keyrows)>0) {
              #           qcode <- key[keyrows,]
              #           if (is.na(codeValue)==FALSE) {
              #             a <- which(codeValue==qcode$Value)
              #             df[r+q-1,pNumber+6] <- as.matrix(qcode$Label)[a]
              #           }
              
            }
            else {df[r+q-1,pNumber+5] <- codeValue}
          }
          else {df[r+q-1,pNumber+5] <- codeValue}
        }
        df[r+q-1,pNumber+7] <- attr(ds_data,"question.type")[attrNum]
        df[r+q-1,pNumber+8] <- attr(ds_data,"question.subtype")[attrNum]
        
      }
    }
    
    mydf <- as.data.frame(df)
    panelHeader <- rep("",length(panelCol))
    for (p in 1:length(panelCol)) {
      b <- which(names(ds_data)[panelCol[p]] == as.matrix(dict[,dc]))
      panelHeader[p] <- as.matrix(dict$`Question Text`)[b]
    }
    colnames(mydf) <- c(panelHeader,"Year", "Qualtrics Question","Variable Name", "Survey Question", "Value", "Label", "Question Type","Question Subtype")
    
    if (substr(fileName,1,6)=="fltrce" && nchar(fileName)==15) {
      mydf$`Continuing or Exiting` <- ""
      if (substr(fileName,11,11)=="e") {mydf$`Continuing or Exiting` <- "Exiting"}
      else if (substr(fileName,11,11)=="c") {mydf$`Continuing or Exiting` <- "Continuing"}
    }
    
    dslist[[i]] <- assign(paste("ds",i,sep=""),mydf)
    
  }
  
  full_ds <- rbind.fill(dslist)
  
  full_ds$Population <- population
  
  setwd(outputDirectory)
  
  write.csv(full_ds,outputName, row.names=FALSE, na="")

}

#*********************************************************
#Function for year based on data file name
#*********************************************************
survey_year <- function(surveyName) {
  if (substr(surveyName,1,6)=="mbsges") {
    year <- substr(surveyName,7,10)
  }
  if(substr(surveyName,1,5)=="phges") {
    year <- substr(surveyName,6,9)
  }
  if (substr(surveyName,1,6)=="dvmges") {
    year <- substr(surveyName,7,10)
  }
  if (substr(surveyName,1,2)=="ss") {
    year <- substr(surveyName,3,6)
  }
  if (substr(surveyName,1,6)=="aseges") {
    year <- substr(surveyName,7,10)
  }
  if (substr(surveyName,1,6)=="fltrce") {
    if (nchar(surveyName)==15) {
      year <- substr(surveyName,7,11)
    }
    else {
    year <- substr(surveyName,7,10)
    }
  }
  return (year)
}

