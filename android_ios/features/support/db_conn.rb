
begin
  require 'pg'
rescue LoadError
  puts "cannot load gem pg"
end

def connect(database_url)
  db_parts = database_url.split(/\/|:|@/)
  username = db_parts[3]
  password = db_parts[4]
  host = db_parts[5]
  port = db_parts[6]
  db = db_parts[7]
  conn = PGconn.open(:host =>  host, :dbname => db, :user=> username, :password=> password, :port => port)
  return conn
end
def remove_users(email)
  if defined? $DATABASE_URL
    conn = connect($DATABASE_URL)
    res = conn.exec_params("SELECT id FROM users WHERE email = '#{email}'")
    res_arr = []
    res.each { |result| res_arr.push(result['id'].to_s)}
    res_arr.each { |id| puts (conn.exec_params("DELETE FROM users WHERE id = '#{id}'").cmd_status() )}
  else
    puts "There is no URL for database available on that backend"
    fail
  end
end

def find_users(email)
  if defined? $DATABASE_URL
    conn = connect($DATABASE_URL)
    res = conn.exec_params("SELECT * FROM users WHERE email = '#{email}'")
    return res
  else
    puts "There is no URL for database available on that backend"
    fail
  end

end
