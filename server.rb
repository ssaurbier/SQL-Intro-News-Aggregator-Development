require 'sinatra'
require 'pry'
require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname: "news_aggregator_development")
    yield(connection)
  ensure
    connection.close
  end
end

def new_article
  [params["article"], params["url"], params["description"]]
end




get "/articles" do
  news = db_connection { |x| x.exec("SELECT article, url, description FROM articles")}
  erb :landing, locals: {news: news}
end

get "/articles/new" do
  erb :form
end

get "/error" do
  erb :sub_error
end

post "/articles/new" do
  db_connection do |x|
    x.exec_params("INSERT INTO articles (article, url, description) VALUES ($1, $2, $3)", new_article)
  end

  redirect "/articles"
end


get "/" do
  redirect "/articles"
end
