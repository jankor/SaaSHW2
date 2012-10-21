class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	redirect =false

	if params[:sort_by].nil? and !(session[:sort_by].nil?)
	  params[:sort_by] = session[:sort_by]
	  redirect = true
	else
	  session[:sort_by] = params[:sort_by] 
	end

	if (params[:ratings].nil? and params[:commit].nil?) and !(session[:ratings].nil?)
	  params[:ratings] = session[:ratings]
	  redirect = true
	else
	  session[:ratings] = params[:ratings]
	end

	redirect_to movies_path params if redirect 
  
	@all_ratings = Movie.all_ratings
    @sort_by = params[:sort_by]
	@selected_ratings = params[:ratings]
	if params[:ratings] == nil
		@selected_ratings = {"G"=>1, "PG"=>1, "PG-13"=>1, "NC-17"=>1, "R" =>1}
	end
	
	
	find_params = Hash.new
	find_params[:order] = @sort_by
	
    @movies = Movie.find_all_by_rating(@selected_ratings.keys, find_params)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
