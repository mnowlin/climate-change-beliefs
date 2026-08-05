# code to recreate centrality graphs for low and high egals  

# estimate parameters of network including centrality and edge weights
## code from Lee et al paper 

# low egal network
#set.seed(1287) 
#net_boot <- bootnet(lowEgalBeliefNetNetwork, nBoots = 1000,
#                     default = "EBICglasso",
#                     statistics = c("betweenness","closeness","strength","edge"),
#                     type = "nonparametric", nCores = 1)

#save(net_boot, file= paste0(getwd(),"/data/network_data_for_replication2.RData"))

load(paste0(getwd(),"/data/network_data_for_replication2.RData"))

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

labels2 <- c("CapTrade","EPA","GeoEng","IntAgree","Nuclear","Renew","Tax","fatal","happening",
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
ggsave("manuscript/lowEgalCentralPlots.png", centralPlots, width = 10, height = 4)

# high risk network
#set.seed(1287) 
#net_boot <- bootnet(highRiskBeliefNetNetwork, nBoots = 1000,
#                    default = "EBICglasso",
#                    statistics = c("betweenness","closeness","strength","edge"),
#                    type = "nonparametric", nCores = 1)

#save(net_boot, file= paste0(getwd(),"/data/network_data_for_replication3.RData"))

load(paste0(getwd(),"/data/network_data_for_replication3.RData"))

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

labels2 <- c("CapTrade","EPA","GeoEng","IntAgree","Nuclear","Renew","Tax","egal","fatal",
             "hier","ideology","indiv","nepScale","partisan")

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
ggsave("manuscript/highRiskCentralPlots.png", centralPlots, width = 10, height = 4)


######### 

## CC networks centrality 

CCcentrality <- centralityTable(list(lowRiskBeliefNetNetwork, highRiskBeliefNetNetwork), standardized = F) %>% 
  filter(measure != "ExpectedInfluence")

CCcentrality$type <- plyr::revalue(CCcentrality$type, c("type 1" = "lowRisk",
                                                        "type 2" = "highRisk"))


CCcentrality$itemtype[CCcentrality$node=="hier" |
                        CCcentrality$node=="egal" |
                        CCcentrality$node=="indiv" |
                        CCcentrality$node=="fatal" |
                        CCcentrality$node=="ideology" |
                        CCcentrality$node=="partisan" |
                        CCcentrality$node=="nepScale"] <- "Deep\nCore"
CCcentrality$itemtype[CCcentrality$node=="happening" |
                        CCcentrality$node=="sciconsensus"] <- "Policy\nCore"
CCcentrality$itemtype[CCcentrality$node=="CapTrade" |
                        CCcentrality$node=="EPA" |
                        CCcentrality$node=="GeoEng" |
                        CCcentrality$node=="IntAgree" |
                        CCcentrality$node=="Nuclear" |
                        CCcentrality$node=="Renew" |
                        CCcentrality$node=="Tax"] <- "Secondary"

CCcentrality$measure <- factor(as.character(CCcentrality$measure), levels = c("Betweenness", "Closeness", "Strength"))
CCcentrality$itemtype <- factor(as.character(CCcentrality$itemtype), levels = c("Secondary", "Policy\nCore", "Deep\nCore"))

# functions for centrality by belief type plot
ci <- function(x) (sd(x)/sqrt(length(x))*qt(0.975,df=length(x)-1) ) #function to compute size of confidence intervals

data_summary <- function(x) {
  m <- mean(x)
  ymin <- m-ci(x)
  ymax <- m+ci(x)
  return(c(y=m,ymin=ymin,ymax=ymax))
}

lowRiskCent <- subset(CCcentrality, type=="lowRisk")
highRiskCent <- subset(CCcentrality, type=="highRisk")

lowRiskCentP <- ggplot(lowRiskCent, aes(x = factor(itemtype), y = value)) +
  geom_point(size = 2, position=position_jitter(width=.05,height=0), alpha = .5) +
  facet_wrap(~measure, ncol = 3, scales = "free_y") +
  stat_summary(fun.data=data_summary, geom = "crossbar", size = .5, width = .3, color = "black")+
  ylab("")+
  ggtitle("Low Risk") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"),
        plot.caption = element_text(face = "italic"),
        axis.title.x=element_blank())

highRiskCentP <- ggplot(highRiskCent, aes(x = factor(itemtype), y = value)) +
  geom_point(size = 2, position=position_jitter(width=.05,height=0), alpha = .5) +
  facet_wrap(~measure, ncol = 3, scales = "free_y") +
  stat_summary(fun.data=data_summary, geom = "crossbar", size = .5, width = .3, color = "black")+
  ylab("")+
  ggtitle("High Risk") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"),
        plot.caption = element_text(face = "italic"),
        axis.title.x=element_blank())

CCcentralPlots <- ggarrange(lowRiskCentP, highRiskCentP, ncol=2, nrow=1)
ggsave("manuscript/CCcentralPlots.png", CCcentralPlots, width = 10, height = 4)

# arrange by centrality for text
lowRiskCent %>% arrange(desc(value))
highRiskCent %>% arrange(desc(value))
