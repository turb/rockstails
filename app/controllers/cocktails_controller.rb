class CocktailsController < ApplicationController
  # GET /cocktails
  # GET /cocktails.xml
  def index
    @cocktails = Cocktail.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cocktails }
    end
  end

  # GET /cocktails/1
  # GET /cocktails/1.xml
  def show
    @cocktail = Cocktail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cocktail }
    end
  end

  # GET /cocktails/new
  # GET /cocktails/new.xml
  def new
    @cocktail = Cocktail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cocktail }
    end
  end

  # GET /cocktails/1/edit
  def edit
    @cocktail = Cocktail.find(params[:id])
  end

  # POST /cocktails
  # POST /cocktails.xml
  def create
    @cocktail = Cocktail.new(params[:cocktail])

    respond_to do |format|
      if @cocktail.save
        flash[:notice] = 'Cocktail was successfully created.'
        format.html { redirect_to(@cocktail) }
        format.xml  { render :xml => @cocktail, :status => :created, :location => @cocktail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cocktail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cocktails/1
  # PUT /cocktails/1.xml
  def update
    @cocktail = Cocktail.find(params[:id])

    respond_to do |format|
      if @cocktail.update_attributes(params[:cocktail])
        flash[:notice] = 'Cocktail was successfully updated.'
        format.html { redirect_to(@cocktail) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cocktail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cocktails/1
  # DELETE /cocktails/1.xml
  def destroy
    @cocktail = Cocktail.find(params[:id])
    @cocktail.destroy

    respond_to do |format|
      format.html { redirect_to(cocktails_url) }
      format.xml  { head :ok }
    end
  end
end
