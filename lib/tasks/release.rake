namespace :noosfero do

  desc 'checks if there are uncommitted changes in the repo'
  task :check_repo do
    sh "git status | grep 'nothing.*commit'" do |ok, res|
      if !ok
        raise "******** There are uncommited changes in the repository, cannot continue"
      end
    end
  end

  version = Noosfero::VERSION
  desc 'checks if there is already a tag for the curren version'
  task :check_tag do
    sh "git tag | grep '^#{version}$' >/dev/null" do |ok, res|
      if ok
        raise "******** There is already a tag for version #{version}, cannot continue"
      end
    end
    puts "Not found tag for version #{version}, we can go on."
  end

  AUTHORS_HEADER = <<EOF
If you are not listed here, but should be, please write to the noosfero mailing
list: http://ynternet.net/mailman/listinfo/noosfero (this list requires
subscription to post, but since you are an author of noosfero, that's not a
problem).

Developers
==========

EOF
  AUTHORS_FOOTER = <<EOF

Ideas, specifications and incentive
===================================
Daniel Tygel <dtygel@fbes.org.br>
Guilherme Rocha <guilherme@gf7.com.br>
Raphael Rousseau <raph@r4f.org>
Théo Bondolfi <move@cooperation.net>
Vicente Aguiar <vicenteaguiar@colivre.coop.br>

EOF

  desc 'updates the AUTHORS file'
  task :authors do
    begin
      File.open("AUTHORS", 'w') do |output|
        output.puts AUTHORS_HEADER
        output.puts `git log --pretty=format:'%aN <%aE>' | sort | uniq`
        output.puts AUTHORS_FOOTER
      end
    rescue Exception => e
      rm_f 'AUTHORS'
      raise e
    end
  end

  desc 'prepares a release tarball'
  task :release => [ 'noosfero:doc:build', :authors, :check_repo, :check_tag ] do
    raise "Not implemented yet"
    sh "git tag #{version}"
  end
    
end