require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'sinatra/namespace'
require './models'
require './lib/analytics'

class SinatraBlogApp < Sinatra::Base 
  use Rack::MethodOverride
  register Sinatra::Flash
  register Sinatra::Namespace

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

  namespace '/posts' do 
    get '' do
      @posts = Post.order("created_at DESC")
      erb :index
    end

    get '/new' do
      @post = Post.new
      erb :new
    end

    get '/:id' do 
      @post = Post.find params[:id]
      erb :show
    end

    post '/' do 
    	post = Post.create params[:post]
      if post.save
        redirect '/'
      else
        redirect '/new' 
      end
    end

    get '/:id/edit' do
      @post = Post.find params[:id]
      erb :edit
    end

    put '/:id' do
      @post = Post.find params[:id]
      if @post.update_attributes(params[:post])
        puts params
        redirect "/posts"
      else
        erb :edit
      end
    end

    delete '/:id' do
      post = Post.find params[:id] 
      if post.destroy
        redirect '/'
      else
        erb :edit
      end
    end

  end

  namespace '/analytics' do
    get '/posts' do 
      content_type :json
      Analytics.new.post_data.to_json 
    end

    get '/blog' do
      content_type :json
      Analytics.new.blog_data.to_json
    end
  end
    
end