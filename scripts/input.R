library(readxl)
library(data.table)
library(tidyr)

dados <- read_excel("dataset/EPIINFODADOS.xlsx")
dados <- data.table(dados)


# tipos de variaveis ------------------------------------------------------

dados$Prontuario <- factor(dados$Prontuario)
dados$UF <- factor(dados$UF)

# deletar -----------------------------------------------------------------

dados[, Idade := NULL] # remover Idade
dados[, names(dados)[grep("Goniometria", names(dados))] := NULL] # remover Goniometria
dados[, names(dados)[grep("Graus", names(dados))] := NULL] # remover Graus
dados[, Obs := NULL] # remover Observação

# dados <- dados[Inclusao == "S"] # participantes excluidos


# renomear colunas --------------------------------------------------------

setnames(dados, "CorrecaoInd", "CorrecaoInD")
setnames(dados, "CorrecaoAndi", "CorrecaoAnD")
setnames(dados, "AnDi", "AnD")
setnames(dados, "TempoAcompanhamentoAnDi", "TempoAcompanhamentoAnD")
setnames(dados, "FinalAcompanhamentoAnDi", "FinalAcompanhamentoAnD")
setnames(dados, "FormaAnDi", "FormaAnD")

# camptodacilia
setnames(dados, "InD", "CamptodactiliaInD")
setnames(dados, "InE", "CamptodactiliaInE")
setnames(dados, "MeD", "CamptodactiliaMeD")
setnames(dados, "MeE", "CamptodactiliaMeE")
setnames(dados, "AnD", "CamptodactiliaAnD")
setnames(dados, "AnE", "CamptodactiliaAnE")
setnames(dados, "MiD", "CamptodactiliaMiD")
setnames(dados, "MiE", "CamptodactiliaMiE")
