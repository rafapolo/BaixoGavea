namespace :db do
  namespace :replica do

    desc "replica banco de dados em produção para desenvolvimento"
    task :prod do
      sh "mysqldump -h db.baixogavea.com -u polo -p --compress --compatible=ansi --default-character-set=utf8 --skip-opt prod_baixogavea > db/baixogavea_prod_dump"
      sh "cd db; sh mysql-to-sqlite3.sh baixogavea_prod_dump"
      sh "cd db; mv baixogavea_prod_dump.db dev_baixogavea.db"
      sh "cd db; ls -alho dev_baixogavea.db"
    end

  end
end
