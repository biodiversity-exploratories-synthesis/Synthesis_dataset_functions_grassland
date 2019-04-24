minimult <- raw_functions[, c("beta_Glucosidase", "N_Acetyl_beta_Glucosaminidase", "Xylosidase", "Urease", "DEA",
                              "Potential.nitrification2011", "Potential.nitrification2014","nifH","amoA_AOB.2011",
                              "amoA_AOA.2011", "amoA_AOB.2016", "amoA_AOA.2016", "nxrA_NS", "16S_NB", "P_loss2011",
                              "P_loss2015", "PRI", "SoilOrganicC", "Soil.C.stock", "Phosphatase")]

# take mean of multi-year-measurements
minimult[, "amoA_AOB" := apply(minimult[,c("amoA_AOB.2011", "amoA_AOB.2016")],1, mean)]
minimult[, "amoA_AOA" := apply(minimult[,c("amoA_AOA.2011", "amoA_AOA.2016")],1, mean)]
minimult[, "Potential.nitrification" := apply(minimult[, c("Potential.nitrification2014", "Potential.nitrification2011")], 1, mean)]
minimult[, c("amoA_AOB.2011", "amoA_AOB.2016", "amoA_AOA.2011", "amoA_AOA.2016", "Potential.nitrification2014", "Potential.nitrification2011") := NULL]
minimult[, "P_loss" := apply(minimult[,c("P_loss2011", "P_loss2015")],1, mean)]
minimult[, c("P_loss2011", "P_loss2015") := NULL]

# correlations
M <- cor(minimult, use="pairwise.complete.obs")

corrplot::corrplot(M,type="lower",addCoef.col = "black",method="color",diag=F, tl.srt=1, tl.col="black", mar=c(0,0,0,0), number.cex=0.6)
corrplot::corrplot(M, type = "upper", tl.col="black", tl.srt=40)

highM <- M
highM[M < 0.6 & M > -0.6] <- 0
corrplot::corrplot(highM, type = "upper", tl.col="black", tl.srt=40)


library(igraph)

par(mfrow=c(2,2))

t <- 0.4
highM <- M
highM[M < t & M > -t] <- 0
network <- graph_from_adjacency_matrix(highM, weighted=T, mode="undirected", diag=F)
plot(network)

t <- 0.5
highM <- M
highM[M < t & M > -t] <- 0
network <- graph_from_adjacency_matrix(highM, weighted=T, mode="undirected", diag=F)
plot(network)

t <- 0.6
highM <- M
highM[M < t & M > -t] <- 0
network <- graph_from_adjacency_matrix(highM, weighted=T, mode="undirected", diag=F)
plot(network)

t <- 0.7
highM <- M
highM[M < t & M > -t] <- 0
network <- graph_from_adjacency_matrix(highM, weighted=T, mode="undirected", diag=F)
plot(network)


# pca

