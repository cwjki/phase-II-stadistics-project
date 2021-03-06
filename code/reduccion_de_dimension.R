# Importamos la tabla con los datos de las pel�culas
my_data <- read.csv("IMDB.csv", sep = ",", dec = ".")

#Para entender datos num�ricos que aparecen acompa�ados de caracteres no num�ricos
convertCurrency <- function(currency){
  currency1 <- sub('$','',as.character(currency), fixed=TRUE)
  currency2 <- as.numeric(gsub('\\,','',as.character(currency1)))
}
convertTime <- function(time){
  time1 <- as.numeric(sub(' min','',as.character(time), fixed=TRUE))
}

my_data$TotalVotes <- convertCurrency(my_data$TotalVotes)
my_data$Runtime <- convertTime(my_data$Runtime)
my_data$Budget <- convertCurrency(my_data$Budget)

#Eliminar las columnas con datos cualitativos
my_data <- subset(my_data, select = -c(X, Title, Genre1, Genre2, Genre3))


# Resumen de los datos
summary(my_data)

# Matriz de correlaci�n
matrix_cor <- cor(x = my_data, use = "pairwise.complete.obs", method = "pearson")
print(matrix_cor)

# Correlaci�n de las variables de la muestra
pairs(my_data, main = "Correlaci�n de las variables de la muestra")

# Matriz de correlaci�n en forma gr�fica
symnum(matrix_cor)


my_data <- na.omit(my_data)

# An�lisis de componentes principales
acp <- prcomp(my_data, scale = TRUE)
summary(acp)


print(acp$sdev)

print(acp$rotation)


## GRAFICOS
plot(acp, main = "Plot de componentes principales")
biplot(acp)
