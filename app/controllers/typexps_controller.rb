class TypexpsController < ApplicationController
before_filter :authorize

  # GET /typexps
  # GET /typexps.xml
  def index
    @typexps = Typexp.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @typexps }
    end
  end

  # GET /typexps/1
  # GET /typexps/1.xml
  def show
    @typexp = Typexp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @typexp }
    end
  end

  # GET /typexps/new
  # GET /typexps/new.xml
  def new
    @typexp = Typexp.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @typexp }
    end
  end

  # GET /typexps/1/edit
  def edit
    @typexp = Typexp.find(params[:id])
  end

  # POST /typexps
  # POST /typexps.xml
  def create
    @typexp = Typexp.new(params[:typexp])

    respond_to do |format|
      if @typexp.save
        flash[:notice] = 'Typexp was successfully created.'
        format.html { redirect_to(@typexp) }
        format.xml  { render :xml => @typexp, :status => :created, :location => @typexp }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @typexp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /typexps/1
  # PUT /typexps/1.xml
  def update
    @typexp = Typexp.find(params[:id])

    respond_to do |format|
      if @typexp.update_attributes(params[:typexp])
        flash[:notice] = 'Typexp was successfully updated.'
        format.html { redirect_to(@typexp) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @typexp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /typexps/1
  # DELETE /typexps/1.xml
  def destroy
    @typexp = Typexp.find(params[:id])
    @typexp.destroy

    respond_to do |format|
      format.html { redirect_to(typexps_url) }
      format.xml  { head :ok }
    end
  end
end
