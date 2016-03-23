#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db 
  @db =SQLite3::Database.new 'leprosorium.db'
  @db.results_as_hash = true
end  

before do 
   init_db
end

configure do               #создаем таблицы в БД
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS
		Posts
		(
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			created_date DATE,
			content TEXT
		)'
end	

get '/' do
#	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
#Выбираем список постов в БД	
@results = @db.execute 'select * from Posts order by id desc'

erb :index
end

get '/new' do
 erb :new
end

post '/new' do
  content = params[:content]    # :content - это атрибут name = "content" for textarea
  if content.length <= 0
  	 @error= 'Введите текст'
  	 return erb :new
  	end
  @db.execute 'insert into Posts (content, created_date) values (?, datetime())',[content]	 
  redirect to '/'
end
#вывод информации о посте
get '/details/:post_id' do 
	post_id = params[:post_id]

	#Выбираем список постов с определенным id
results = @db.execute 'select * from Posts where id = ?', [post_id]
@row = results[0]

#	erb "Displaying information for post with id #{post_id}"
 erb :details
  
end	

