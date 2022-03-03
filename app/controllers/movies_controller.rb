class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @sort_param = sort_param
      @rating_filter_param = rating_filer_params
      @all_ratings = Movie.all_ratings

      if @sort_param
        @movies = Movie.with_ratings(@rating_filter_param).order(@sort_param)
      else
        @movies = Movie.with_ratings(@rating_filter_param)
      end
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end

    def sort_param
      return session[:sort_param] if params[:sort].nil?
      session[:sort_param] = params[:sort]
    end

    def rating_filer_params
      return session[:rating_filter_param] if params[:ratings].nil?
      return session[:rating_filter_param] = params[:ratings] if params[:ratings].is_a?(Array)
      session[:rating_filter_param] = params[:ratings].keys
    end
  end