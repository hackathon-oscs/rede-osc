#!/usr/bin/python

"""Importa a tabela de entidades do DEJUS a partir de um arquivo .csv .

O banco de dados de destino é obrigatoriamente PostgreSQL e indicado na
seção 'dejus' do arquivo config.ini . O diretório dos arquivos .csv do DEJUS
estão indicados na seção 'dejus-csv' do mesmo arquivo.

O formato do CSV é delimitado por ponto-e-vírgula (SCSV?), e as colunas são:

# 0 - CodigoEntidade
# 1 - CodigoSetorEntidade
# 2 - CodigoTipoEstabelecimento
# 3 - HabilitaCertidao
# 4 - OrigemEntidade
# 5 - OrigemCadastro
# 6 - CodigoUsuarioResponsavelCadastro
# 7 - DataAtualizacao
# 8 - IndicaEntidadeTemporaria
# 9 - NomeFantasia
# 10 - RazaoSocial
# 11 - NomeReduzido
# 12 - NumeroCNPJ
# 13 - Site
# 14 - Email
# 15 - Logradouro
# 16 - Complemento
# 17 - NumeroLogradouro
# 18 - NomeBairro
# 19 - NumeroCEP
# 20 - CodigoMunicipio
# 21 - SiglaUF
# 22 - NomeMunicipio
# 23 - NomeEstado
# 24 - SiglaPais
# 25 - NumeroDDD
# 26 - NumeroTelefone1
# 27 - NumeroTelefone2
# 28 - NumeroFax
# 29 - CodigoNaturezaJuridica
# 30 - data
# 31 - DataCriacao

Das quais, o interessante para a gente (e pela amostragem que fizemos 
são os mais confiáveis):

- NomeFantasia
- RazaoSocial
- NumeroCNPJ
- Site
- Email
- SiglaUF
"""
