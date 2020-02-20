class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  # end
  
  def index
    @all_ratings = %w(G PG PG-13 R)
    
    if params[:commit].nil? or (params[:ratings].nil? and params[:commit])
      @selected_ratings = %w(G PG PG-13 R)
    else
      @selected_ratings = params[:ratings].keys
    end
    
    @sort_type = nil
    if params[:sort] == "title"
      @sort_type = "title"
      @title_header = 'hilite'
      session[:sort] = params[:sort]
    elsif params[:sort] == "release_date"
      @sort_type = "release_date"
      @release_date_header = 'hilite'
      session[:sort] = params[:sort]
    elsif params[:sort].nil? and session[:sort] == "title"
      @sort_type = "title"
      @title_header = 'hilite'
    elsif params[:sort].nil? and session[:sort] == "release_date"
      @sort_type = "release_date"
      @release_date_header = 'hilite'
    end
    
    @movies = Movie.order(@sort_type).where(rating: @selected_ratings)

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

end