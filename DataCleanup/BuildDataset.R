votes <- read.csv("D:/Desktop/CSX_ALL/PA/FinalProj/SourceData/votes.csv")
overall <- read.csv("D:/Desktop/CSX_ALL/PA/FinalProj/SourceData/overall_results.csv")

votes$time <- as.POSIXct(votes$time) # perform datetime conversion for listed timestamps
overall$time <- as.POSIXct(overall$time)

times <- unique(overall$time)

overall <- overall[overall$time %in% times[16:length(times)],]

times <- unique(overall$time)

final <- votes[votes$time == times[length(times)],c("District","Party","Mandates")]

res <- c()

for(t in 1:length(times)) {
  
  distr <- overall[overall$time==times[t],]
  distr.names <- distr$territoryName
  
  # acquire "minutes elapsed" value for each data collection timestamp
  timedif <- as.numeric(round(difftime(times[t],times[1],units="mins"))) 
  
  for(i in 1:length(distr.names)) {
    
    info.distr <- distr[distr$territoryName==distr.names[i],c(1,3,5:15,18:24)]
    
    votes.distr <- votes[votes$time==unique(distr$time) & votes$District==distr.names[i],3:7]
    
    if(nrow(votes.distr)>0) {
      
      maxElected <- sum(final[final$District==distr.names[i],]$Mandates)
      
      hondt.m <- matrix(nrow=maxElected,ncol=nrow(votes.distr))
      colnames(hondt.m) <- votes.distr$Party; rownames(hondt.m) <- 1:nrow(hondt.m)
      
      for(m in 1:maxElected) {
        hondt.m[m,] <- votes.distr$Votes/m
      }
      
      threshold <- sort(hondt.m,decreasing = TRUE)[maxElected]
      
      votes.distr["Hondt"] <- apply(hondt.m,2,FUN=function(x) length(x[x>=threshold]))
      
      ###
      
      parties <- votes.distr$Party
      
      for(p in 1:length(parties)) {
        
        final.mandates <- final[final$District==distr.names[i] & final$Party==parties[p],]$Mandates
        
        res.row <- cbind(TimeElapsed=timedif,info.distr,votes.distr[votes.distr$Party==parties[p],],FinalMandates=final.mandates)
        
        res <- rbind(res,res.row)
        
      }
      
    }
    
  }
  
}

# Note: I have commented this last part out (the one generating the CSV) because I manually inserted ISO codes into the .CSV file via Excel formulas, and wanted to preserve the original content of this file for the most part, since it isn't my work. 
# I've run this code several times and it works just fine to generate the rest of the file outside of the ISO codes.
# write.csv(res,file="ElectionData.csv",row.names=FALSE)
