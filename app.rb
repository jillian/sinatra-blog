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
    get do
      @posts = Post.order("created_at DESC")
      erb :index
    end

    get '/new' do
      @post = Post.new
      erb :new
    end

    post do 
      post = Post.create params[:post]
      if post.save
        redirect '/'
      else
        redirect '/new' 
      end
    end

    namespace '/:id' do
      before do 
        @post = Post.find params[:id]
      end

      get do 
        # @post = Post.find params[:id]
        @comment = @post.comments.new
        erb :show

      end

      get '/edit' do
        # @post = Post.find params[:id]
        erb :edit
      end

      put do
        # @post = Post.find params[:id]
        if @post.update_attributes(params[:post])
          puts params
          redirect "/posts"
        else
          erb :edit
        end
      end

      delete do
        # @post = Post.find params[:id] 
        if @post.destroy
          redirect '/'
        else
          erb :edit
        end
      end

      namespace '/comments' do
        post do
          @comment = @post.comments.create(params[:comment])
          erb :show
        end

        delete do 
          @comment = @post.comments.find(params[:id])
          @comment.destroy
          redirect '/'
        end
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