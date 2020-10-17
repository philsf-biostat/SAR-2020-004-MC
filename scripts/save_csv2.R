source('scripts/input.R', encoding = 'UTF-8')
write.csv2(dados.particpantes, "dataset/participantes_incluidos.csv", row.names = FALSE)
write.csv2(dados.particpantes.exclusao, "dataset/participantes_excluidos.csv", row.names = FALSE)
write.csv2(dados, "dataset/dedos.csv", row.names = FALSE)
