# climate change belief network centrality measures 

## packages
library("tidyverse")
library("bootnet")
library("egg")

## load data
beliefData <- read.csv("data/beliefDataRep.csv")
beliefData$nepScale <- round((beliefData$nep2+beliefData$nep3+beliefData$nep6)/3, 0)

## create network
beliefNetVars <- c("egal","indiv","hier","fatal",
                   "ideology","partisan",
                   "nepScale",
                   "happening","risk","sciconsensus", 
                   "IntAgree","Renew","Nuclear","Tax",
                   "EPA","CapTrade","GeoEng")
beliefNetData <- beliefData[beliefNetVars]

beliefNetNetwork <- estimateNetwork(beliefNetData, 
                                    default = "EBICglasso",
                                    corMethod = "cor_auto",
                                    tuning = 0.5)


set.seed(1287) 
net_boot <- bootnet(beliefNetNetwork, nBoots = 1000,
                     default = "EBICglasso",
                     statistics = c("betweenness","closeness","strength","edge"),
                     type = "nonparametric", nCores = 1)

save(net_boot, file= paste0(getwd(),"/data/network_data_for_replication.RData"))

load(paste0(getwd(),"/data/network_data_for_replication.RData"))

summary(net_boot)

net_boot_whole <- net_boot$bootTable
# net_boot_strength <- net_boot_whole %>%
#  filter(type=="strength") %>%
#  filter(id == c("US \nrisk","GW \nworry"))

net_boot_stat<-summary(net_boot)
net_boot_stat_cent <- net_boot_stat %>%
  filter(type!="edge")

cent_stat <- net_boot_stat_cent %>%
  dplyr::select(type, id, mean, CIlower, CIupper)
cent_stat$id
cent_stat$type

labels2 <- c("CapTrade","EPA","GeoEng","IntAgree","Nuclear","Renew","Tax","egal","fatal","happening",
             "hier","ideology","indiv","nepScale","partisan","risk","sciconsensus")

cent_stat$labels <- rep(labels2, 3)

str_cent<- cent_stat %>%
  filter(type == "strength")

str_centP <- ggplot(data = str_cent, aes(x=reorder(labels, mean), y=mean)) + 
  geom_point() +
  geom_errorbar(aes(ymin=(CIlower), ymax=(CIupper)), stat = "identity", position=position_dodge(0.1), width=.1) +
  coord_flip() +
  xlab("") +
  ylab("") + 
  ggtitle("Strength") +
  theme_minimal() +
  geom_vline(xintercept = 0, linetype = "dotted", alpha = .3) +
  theme(plot.title = element_text(face = "bold"),
        plot.caption = element_text(face = "italic"))

close_cent<- cent_stat %>%
  filter(type == "closeness")

close_centP <- ggplot(data = close_cent, aes(x=reorder(labels, mean), y=mean)) + 
  geom_point() +
  geom_errorbar(aes(ymin=(CIlower), ymax=(CIupper)), stat = "identity", position=position_dodge(0.1), width=.1) +
  coord_flip() +
  xlab("") +
  ylab("") + 
  ggtitle("Closeness") +
  theme_minimal() +
  geom_vline(xintercept = 0, linetype = "dotted", alpha = .3) +
  theme(plot.title = element_text(face = "bold"),
        plot.caption = element_text(face = "italic"))

betw_cent <- cent_stat %>%
  filter(type == "betweenness")

betw_centP <- ggplot(data = betw_cent, aes(x=reorder(labels, mean), y=mean)) + 
  geom_point() +
  geom_errorbar(aes(ymin=(CIlower), ymax=(CIupper)), stat = "identity", position=position_dodge(0.1), width=.1) +
  coord_flip() +
  xlab("Beliefs") +
  ylab("") + 
  ggtitle("Betweenness") +
  theme_minimal() +
  geom_vline(xintercept = 0, linetype = "dotted", alpha = .3) +
  theme(plot.title = element_text(face = "bold"),
        plot.caption = element_text(face = "italic"))

centralPlots <- ggarrange(betw_centP, close_centP, str_centP, ncol=3, nrow=1)
ggsave("manuscript/centralPlots.png", centralPlots, width = 10, height = 4)
