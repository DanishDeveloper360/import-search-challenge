class PortsController < ApplicationController
    before_action :set_port, only: [:show, :update, :destroy]

    # GET /ports
    def index
      @ports = Port.all
      json_response(@ports)
    end
  
    # POST /ports
    def create
      file_path = params[:file].path
      portType = []
      ports = []
      # columns = [:name, :code, city]
      portTypes = PortType.all.select(:id, :name).take(10)
      
      CSV.foreach(file_path, headers: true) do |row|

        # propTypeId = portTypes.select(name: row[10])
        propTypeForRow = portTypes.select {|e| e[:name] == row['Port type']}

        if propTypeForRow.count <= 0
          PortType.create!(:name => row['Port type'], 
            :created_at => row['Created at'].blank? ? Date.today() : DateTime.parse(row['Created at']), 
            :updated_at => row['Updated at'].blank? ? Date.today() : DateTime.parse(row['Updated at']))
          portTypes = PortType.all.select(:id, :name).take(10)
          propTypeForRow = portTypes.select {|e| e[:name] == row['Port type']}
        end
        # Id	Name	Code	City	Oceans insights code	Latitude	Longitude	Bigschedules	Created at	Updated at	Port type	Hub port	Ocean insights
        newPort = { :name => row['Name'], :code => row['Code'], :city => row['City'], 
        :oceans_insights_code => row['Oceans insights code'], :lat => row['Latitude'], :lng => row['Longitude'], :big_schedules => row['Bigschedules'], 
        :created_at => row['Created at'].blank? ? Date.today() : DateTime.parse(row['Created at']), 
        :updated_at => row['Updated at'].blank? ? Date.today() : DateTime.parse(row['Updated at']),
        :port_type_id => propTypeForRow[0][:id] }
        ports << newPort
      end
      Port.import ports, validate: false, on_duplicate_key_update: { conflict_target: [:code], columns: [ :name, :city, :lat, :lng, :port_type_id, :big_schedules, :oceans_insights_code ] }
      
      json_response({ message: 'Records uploaded successfully', count: ports.count }, :created)
    end
  
    # GET /ports/:id
    def show
      Port.where(code: params[:code])
      json_response(@port)
    end
  
    # PUT /ports/:id
    def update
      @port.update(port_params)
      head :no_content
    end
  
    # DELETE /ports/:id
    def destroy
      @port.destroy
      head :no_content
    end

    def search
      if(params[:code])
        @port = Port.find_by_code(params[:code])
        json_response(@port)
      elsif(params[:name])
        
        @port = Port.where("name LIKE :query", query: "%#{params[:name]}%")
        json_response(@port)    
      elsif(params[:portType])
        #TODO: implement pagination
        @port = Port.joins(:port_type).where("port_types.name = ?", params[:portType]).limit(10)
        json_response(@port)          
      end
    end
  
    private
  
    def port_params
      # whitelist params
      params.permit(:name, :code)
    end
  
    def set_port
      @port = Port.find(params[:id])
    end

    def is_csv_expected_format
      
    end
    
end
