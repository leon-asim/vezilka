library(synthpop)

set.seed(123)

n <- 200

vozrast <- sample(18:65, n, replace = TRUE)

obrazovanie <- sapply(vozrast, function(v) {
  if (v < 23) "Средно"
  else if (v < 27) sample(c("Средно", "Високо"), 1)
  else if (v < 35) sample(c("Високо", "Магистер"), 1)
  else sample(c("Високо", "Магистер", "Докторски"), 1)
})

vrabotuvanje <- sapply(vozrast, function(v) {
  if (v < 23) sample(c("Студент", "Невработен"), 1, prob = c(0.7, 0.3))
  else sample(c("Вработен", "Невработен"), 1, prob = c(0.8, 0.2))
})

plata <- sapply(vrabotuvanje, function(v) {
  if (v == "Невработен") 0
  else if (v == "Студент") round(rnorm(1, 15000, 3000))
  else round(rnorm(1, 50000, 12000))
})

original_data <- data.frame(
  vozrast = vozrast,
  pol = factor(sample(c("Машки", "Женски"), n, replace = TRUE)),
  obrazovanie = factor(obrazovanie,
                       levels = c("Средно", "Високо", "Магистер", "Докторски"),
                       ordered = TRUE),
  grad = factor(sample(
    c("Скопје", "Битола", "Тетово", "Прилеп", "Охрид"),
    n, replace = TRUE
  )),
  vrabotuvanje = factor(vrabotuvanje),
  plata = pmax(plata, 0)
)

init_syn <- syn(original_data, visit.sequence = names(original_data), seed = 123)

predictor.matrix <- init_syn$predictor.matrix


method <- c(
  vozrast = "sample",
  pol = "sample",
  obrazovanie = "polyreg",
  grad = "sample",
  vrabotuvanje = "polyreg",
  plata = "norm"
)

predictor.matrix["obrazovanie", "vozrast"] <- 1
predictor.matrix["vrabotuvanje", "vozrast"] <- 1
predictor.matrix["vrabotuvanje", "obrazovanie"] <- 1
predictor.matrix["plata", "vozrast"] <- 1
predictor.matrix["plata", "obrazovanie"] <- 1
predictor.matrix["plata", "vrabotuvanje"] <- 1

synthetic_data <- syn(
  original_data,
  method = method,
  predictor.matrix = predictor.matrix,
  seed = 123
)

synthetic_df <- synthetic_data$syn

synthetic_df$plata[synthetic_df$vrabotuvanje == "Невработен"] <- 0
synthetic_df$plata <- round(pmax(synthetic_df$plata, 0))

summary(original_data)
summary(synthetic_df)

compare(synthetic_data, original_data)

write.csv(
  synthetic_df,
  "sinteticki_podatoci_mk1.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

