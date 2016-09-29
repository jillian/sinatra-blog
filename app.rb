require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require './models'
require './lib/analytics'

class SinatraBlogApp < Sinatra::Base 
  use Rack::MethodOverride
  register Sinatra::Flash

  enable :sessions

  helpers do 
    include Rack::Utils
    alias_method :h, :escape_html

    def format_date(time)
     time.strftime("%d %b %Y")
    end
  end

  get '/' do
    redirect '/posts'
  end

  get '/posts' do
    @posts = Post.order("created_at DESC")
    erb :index
  end

  get '/posts/new' do
    @post = Post.new
    erb :new
  end

  get '/posts/:id' do 
    @post = Post.find params[:id]
    erb :show
  end

  post '/posts' do 
  	post = Post.create params[:post]
    if post.save
      redirect '/'
    else
      redirect '/new' 
    end
  end

  get '/posts/:id/edit' do
    @post = Post.find params[:id]
    erb :edit
  end

  put '/posts/:id' do
    @post = Post.find params[:id]
    if @post.update_attributes(params[:post])
      puts params
      redirect "/posts"
    else
      erb :edit
    end
  end

  delete '/posts/:id' do
    post = Post.find params[:id] 
    if post.destroy
      redirect '/'
    else
      erb :edit
    end
  end

  get '/analytics/posts' do 
    content_type :json
    Analytics.new.post_data.to_json 
  end

  get '/analytics/blog' do
    content_type :json
    Analytics.new.blog_data.to_json
  end
    
end