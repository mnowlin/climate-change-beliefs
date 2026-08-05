# create data set for replication 

## load data 
beliefData <- read.csv("data/nationalData.csv")

## add variables 
egal1 <- (beliefData$egal1)
egal2 <- (beliefData$egal2)
egal3 <- (beliefData$egal3)
egal <- (beliefData$egal)

indiv1 <- (beliefData$indiv1)
indiv2 <- (beliefData$indiv2)
indiv3 <- (beliefData$indiv3)
indiv <- (beliefData$indiv)

hier1 <- (beliefData$hier1)
hier2 <- (beliefData$hier2)
hier3 <- (beliefData$hier3)
hier <- (beliefData$hier)

fatal1 <- (beliefData$fatal1)
fatal2 <- (beliefData$fatal2)
fatal3 <- (beliefData$fatal3)
fatal <- (beliefData$fatal)

nep2 <- (beliefData$nep2)
nep3 <- (beliefData$nep3)
nep6 <- (beliefData$nep6)
nepScale <- (beliefData$nepScale)

ideology <- (beliefData$ideology)
partisan <- (beliefData$partisan)

happening <- (beliefData$happening)
risk <- (beliefData$risk)
sciconsensus <- (beliefData$sciconsensus)

IntAgree <- (beliefData$IntAgree)
Renew <- (beliefData$Renew)
Nuclear <- (beliefData$Nuclear)
Tax <- (beliefData$Tax)
EPA <- (beliefData$EPA)
CapTrade <- (beliefData$CapTrade)
GeoEng <- (beliefData$GeoEng)

## create data set 
beliefDataRep <- data.frame(egal1,egal2,egal3,egal,indiv1,indiv2,indiv3,indiv,hier1,hier2,hier3,hier,fatal1,fatal2,fatal3,fatal,
                            nep2,nep3,nep6,nepScale,ideology,partisan,happening,risk,sciconsensus,IntAgree,Renew,Nuclear,Tax,
                            EPA,CapTrade,GeoEng)
write.csv(beliefDataRep, "data/beliefDataRep.csv")

