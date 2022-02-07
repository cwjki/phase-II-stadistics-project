library(purrr)
library(ggplot2)
library(cluster)
library(factoextra)


# Importamos la tabla con los datos de las películas
my_data <- read.csv("IMDB.csv", sep = ",", dec = ".")

#Para entender datos numéricos que aparecen acompañados de caracteres no numéricos
convertCurrency <- function(currency){
  currency1 <- sub('$','',as.character(currency), fixed=TRUE)
  currency2 <- sub(' ', '', as.character(currency1), fixed = TRUE)
  currenc32 <- as.numeric(gsub('\\,','',as.character(currency2)))
}

my_data$TotalVotes <- convertCurrency(my_data$TotalVotes)
my_data$Budget <- convertCurrency(my_data$Budget)


#Eliminar las columnas con datos cualitativos
my_data <- subset(my_data, select = -c(Title, Genre1, Genre2, Genre3))

#Eliminar las columnas que no hablen sobre conteo de votos
my_data <- subset(my_data, select = -c(X, Rating, MetaCritic, Budget, Runtime,
                                       VotesM, VotesF, VotesU18, VotesU18M,
                                       VotesU18F, Votes1829, Votes1829M,
                                       Votes1829F, Votes3044, Votes3044M,
                                       Votes3044F, Votes45A, Votes45AM,
                                       Votes45AF, VotesIMDB, Votes1000,
                                       VotesUS, VotesnUS))

ac <- function(metodo)
{
  agnes(my_data, method = metodo)$ac
}


#Estandarizar
my_data <- scale(my_data)
my_data <- na.omit(my_data)

d <- dist(my_data, method = "euclidean")

hc2 <- agnes(my_data, method = "complete")
hc2$ac

hc3 <- agnes(my_data, method = "ward")

metodos <- c("average", "single", "complete", "ward")
names(metodos) <- c("average", "single", "complete", "ward")
map_dbl(metodos, ac)

cluster_kmeans <- kmeans(my_data, 7)

cluster_pam <- pam(my_data, 7)

##GRAFICOS

fit <- hclust(d, method = "complete" )
d2 <- as.dendrogram(fit)
plot(fit)
rect.hclust(fit, k = 7, border = "blue")

pltree(hc3, hang = -1, cex = 0.6)
rect.hclust(hc3, k = 7)

plot(my_data, col = cluster_kmeans$cluster)

fit2 <- hclust(d, method = "average" )
d2 <- as.dendrogram(fit2)
plot(fit2)
rect.hclust(fit, k = 7, border = "blue")

plot(cluster_pam)
rect.hclust(fit2, k = 7, border = "blue")
