#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/environment'
require 'csv'
include Noosfero::SampleDataHelper

categories = $environment.categories

def rand_position(type)
  range = {
    :lat => [-33.52, 4.6],
    :lng => [-72.9, -32.41],
  }[type]
  amplitude = (range.last - range.first)
  range.first + rand() * amplitude
end

# Importa a partir do dejus.formatted.csv 
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

start_time = Time.now

CSV.foreach("dejus.formatted.csv") do |row|
    enterprise = Enterprise.new(
        :name => row[10],
        :identifier => row[10],
        :enabled => false,
        :foundation_year => (1990..2008).to_a[rand(18)]
      )
      save enterprise do
        categories.rand.enterprises << enterprise
        categories.rand.enterprises << enterprise
      end
    end

EnterpriseActivation.find(:all, :conditions => ['created_at > ?', start_time]).each do |activation|
  enterprise = activation.enterprise
  puts [activation.code, enterprise.name, enterprise.foundation_year].join(';')
end

ze = Person['ze']
# give admin rights for 'ze' in some enterprises
$environment.enterprises.rand.add_admin(ze)
$environment.enterprises.rand.add_admin(ze)
$environment.enterprises.rand.add_admin(ze)
