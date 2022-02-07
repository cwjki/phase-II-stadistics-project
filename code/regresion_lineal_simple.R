#install.packages("lmtest")
library(lmtest)
#install.packages("ggplot2")
library(ggplot2)


# Importamos la tabla con los datos de las películas
my_data <- read.csv("IMDB.csv", sep = ",", dec = ".")

#Para entender datos numéricos que aparecen acompañados de caracteres no numéricos
convertCurrency <- function(currency){
  currency1 <- sub('$','',as.character(currency), fixed=TRUE)
  currency2 <- sub(' ', '', as.character(currency1), fixed = TRUE)
  currenc32 <- as.numeric(gsub('\\,','',as.character(currency2)))
}

rating <- my_data$Rating

my_data$VotesUS <- convertCurrency(my_data$VotesUS)
votesus <- my_data$VotesUS


#Test de correlación mediante el método de Pearson
cor.test(x = votesus, y = rating, method = "pearson")

# Modelo de regresión lineal simple
linear_regression <- lm(rating ~ votesus, data = my_data)
summary(linear_regression)


# Análisis de los supuestos
my_data$Residuos <- linear_regression$residuals
residuals <- my_data$Residuos

shapiro.test(linear_regression$residuals)

bptest(linear_regression)

dwtest(linear_regression)

mean(residuals)
sum(residuals)



##GRAFICOS##
my_data$Prediction <- linear_regression$fitted.values
predictions <- my_data$Prediction

# Diagrama de dispersión
ggplot(data = my_data, mapping = aes(x = votesus, 
                                     y = rating)) + 
  geom_point(color = "firebrick", size = 2) +
  labs(title = "Diagrama de dispersión", x = "rating en US", 
       y = "rating") +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5))

# Representación del gráfico del modelo de regresión lineal
ggplot(data = my_data, mapping = aes(x = votesus, 
                                     y = rating)) +
  geom_point(color = "firebrick", size = 2) +
  labs(title = "Diagrama de dispersión", x = "rating en US", 
       y = "rating") +
  geom_smooth(method = "lm", se = FALSE, color = "black", formula = "y ~ x") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))

# Distribución de los residuos
ggplot(data = my_data, aes(x = predictions, y = residuals)) +
  geom_point(aes(color = residuals)) +
  scale_color_gradient2(low = "blue3", mid = "grey", high = "red") +
  geom_hline(yintercept = 0) +
  geom_segment(aes(xend = predictions, yend = 0), alpha = 0.2) +
  labs(title = "Distribución de los residuos", x = "rating en US",
       y = "residuos") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "none")

hist(residuals, main = "Histograma de Residuos")
qqnorm(residuals)
qqline(residuals)
