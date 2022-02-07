#install.packages("psych")
library(psych)
library(lmtest)
library(ggplot2)
library(gridExtra)

# Importamos la tabla con los datos de las películas
my_data <- read.csv("IMDB.csv", sep = ",", dec = ".")

#Para entender datos numéricos que aparecen acompañados de caracteres no numéricos
convertCurrency <- function(currency){
  currency1 <- sub('$','',as.character(currency), fixed=TRUE)
  currency2 <- as.numeric(gsub('\\,','',as.character(currency1)))
}
convertTime <- function(time){
  time1 <- as.numeric(sub(' min','',as.character(time), fixed=TRUE))
}

my_data$TotalVotes <- convertCurrency(my_data$TotalVotes)
my_data$Budget <- convertCurrency(my_data$Budget)
my_data$Runtime <- convertTime(my_data$Runtime)
my_data$Rating <- convertCurrency(my_data$Rating)
rating <- my_data$Rating
votesm <- my_data$VotesM
votesf <- my_data$VotesF
votesnus <- my_data$VotesnUS

#Eliminar las columnas con datos cualitativos
my_data <- subset(my_data, select = -c(Title, Genre1, Genre2, Genre3))

# Coeficiente de correlación para cada par de variables
round(cor(x = my_data, use = "pairwise.complete.obs", method = "pearson"), 3)

# Graficamos la relación entre las variables
multi.hist(x = my_data, dcol = c("blue", "red"), dlty = c("dotted", "solid"),
           main = "")

# Generamos el modelo de regresión múltiple
multi_regression <- lm(rating ~ votesm + votesf
             + votesnus, data = my_data)
summary(multi_regression)

# Analizamos los supuestos mediante los residuos
residuals <- multi_regression$residuals
mean(residuals)
sum(residuals)

shapiro.test(residuals)
bptest(multi_regression)
dwtest(multi_regression)

##GRAFICOS##

qqnorm(residuals)
qqline(residuals)


#Eliminamos la fila en la que uno de los predictores contiene NA para
#emparejar cada elemento de ellos con uno de los residuos
my_data <- my_data[-111,]
rating <- my_data$Rating
votesm <- my_data$VotesM
votesf <- my_data$VotesF
votesnus <- my_data$VotesnUS

plot1 <- ggplot(data = my_data, aes(votesnus, residuals)) + 
  geom_point() + 
  labs(title = "", x = "votesnus", y = "residuos") + 
  geom_smooth(formula = "y ~ x", method = "loess", color = "firebrick") + 
  geom_hline(yintercept = 0) + 
  theme_bw()
plot2 <- ggplot(data = my_data, aes(votesf, residuals)) +
  geom_point() + 
  labs(title = "", x = "votesf", y = "residuos") + 
  geom_smooth(formula = "y ~ x", method = "loess", color = "firebrick") + 
  geom_hline(yintercept = 0) + 
  theme_bw()
plot3 <- ggplot(data = my_data, aes(votesm, residuals)) +
  geom_point() + 
  labs(title = "", x = "votesm", y = "residuos") + 
  geom_smooth(formula = "y ~ x", method = "loess", color = "firebrick") + 
  geom_hline(yintercept = 0) + 
  theme_bw()

grid.arrange(plot1, plot2, plot3)


