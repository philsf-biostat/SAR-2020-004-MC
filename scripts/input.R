library(readxl)
library(data.table)
library(tidyr)

dados <- read_excel("dataset/EPIINFODADOS.xlsx")
dados <- data.table(dados)


# tipos de variaveis (participante) ---------------------------------------

dados$UniqueKey <- factor(dados$UniqueKey)
dados$Prontuario <- factor(dados$Prontuario)
dados$UF <- factor(dados$UF)
dados$Abandono <- factor(dados$Abandono)
dados$Recidiva <- factor(dados$Recidiva)
dados$Iniciais <- factor(dados$Iniciais)
dados$Genero <- factor(dados$Genero)
dados$Inclusao <- factor(dados$Inclusao)
dados$Tipo <- ordered(dados$Tipo)


# colunas deletadas -------------------------------------------------------

dados[, Idade := NULL] # remover Idade
dados[, names(dados)[grep("Goniometria", names(dados))] := NULL] # remover Goniometria
dados[, names(dados)[grep("Graus", names(dados))] := NULL] # remover Graus
dados[, DataColeta := NULL] # data de coleta
dados[, Obs := NULL] # remover Observação


# participantes excluidos -------------------------------------------------

dados.particpantes.exclusao <- dados[Inclusao == "N"] # salvar participantes excluidos
dados <- dados[Inclusao == "S"] # excluir participantes da tabela de dedos
dados.particpantes <- dados # tabela de participantes


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


# reshape -----------------------------------------------------------------

## Reshape para long table

dados %>% pivot_longer(#dados,
  cols = names(dados)[grep("Camptodactilia|Correcao|FinalAcompanhamento|Forma|TempoAcompanhamento", names(dados))],
  # names_prefix = "Correcao",
  names_to = c(".value", "Dedo"),
  names_pattern = "(Camptodactilia|Correcao|FinalAcompanhamento|Forma|TempoAcompanhamento)(...)",
) %>% data.table -> dados


# lateralidade do dedo ----------------------------------------------------

dados %>%
  separate(
    Dedo,
    c("Dedo", "Lado"),
    2
    ) %>% data.table -> dados

# tipos de variaveis (dedo) -----------------------------------------------

dados$Dedo <- factor(dados$Dedo)
dados$Camptodactilia <- factor(dados$Camptodactilia)
dados$Forma <- factor(dados$Forma)
dados$Correcao <- factor(dados$Correcao)


# limpeza final -----------------------------------------------------------

dados[Correcao == "Missing", Correcao := NA] # dados faltantes da Correcao
# dados <- dados[Camptodactilia == "Yes"] # excluir dedos sem camptodactilia
dados[, Inclusao := NULL] # coluna inclusao já cumpriu seu papel
dados <- droplevels(dados) # limpar níveis dos fatores


# Abandono ----------------------------------------------------------------

dados[ Camptodactilia == "No" ]$Abandono <- NA
dados[ Camptodactilia == "Yes" & (dados$FinalAcompanhamento >= dados$DataAbandono) ]$Abandono <- "Yes"
dados[ Camptodactilia == "Yes" & (dados$FinalAcompanhamento < dados$DataAbandono) ]$Abandono <- "No"


# Idade -------------------------------------------------------------------

dados.particpantes$Idade <- cut(dados.particpantes$IdadeInicioAcompanhamento, breaks = c(0, 12, 24, 60, 120, Inf), right = FALSE)
dados$Idade <- cut(dados$IdadeInicioAcompanhamento, breaks = c(0, 12, 24, 60, 120, Inf), right = FALSE)

