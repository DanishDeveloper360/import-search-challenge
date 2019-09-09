module V1
  class PortsController < ApplicationController
      before_action :set_port, only: [:show, :destroy]

      # GET /ports
      def index
        @ports = Port.all.paginate(page: 1, per_page: 20)
        json_response(@ports)
      end
    
      # POST /ports
      def create
        if not (params[:file]).present?
          return json_response({ message: Message.file_not_found }, :not_found)
        elsif params[:file].content_type != "text/csv"
          return json_response({ message: Message.unsupported_media_type }, :unsupported_media_type)
        end

        file_path = params[:file].path
        ports = []
        portTypes = PortType.all.select(:id, :name).take(10)
        
        CSV.foreach(file_path, headers: true) do |row|

          raise(ExceptionHandler::HeaderCorrupt, Message.header_corrupt) unless ['Name', 'Code', 'City', 'Port type', 'Oceans insights code','Latitude', 'Longitude', 'Bigschedules' ].all? { |header| row.headers.include? header }

          propTypeForRow = portTypes.select {|e| e[:name] == row['Port type']}

          if propTypeForRow.count <= 0
            PortType.create!(:name => row['Port type'], 
              :created_at => row['Created at'].blank? ? Date.today() : DateTime.parse(row['Created at']), 
              :updated_at => row['Updated at'].blank? ? Date.today() : DateTime.parse(row['Updated at']))
            portTypes = PortType.all.select(:id, :name).take(10)
            propTypeForRow = portTypes.select {|e| e[:name] == row['Port type']}
          end
          newPort = { :name => row['Name'], :code => row['Code'], :city => row['City'], 
          :oceans_insights_code => row['Oceans insights code'], :lat => row['Latitude'], :lng => row['Longitude'], :big_schedules => row['Bigschedules'], 
          :created_at => row['Created at'].blank? ? Date.today() : DateTime.parse(row['Created at']), 
          :updated_at => row['Updated at'].blank? ? Date.today() : DateTime.parse(row['Updated at']),
          :port_type_id => propTypeForRow[0][:id] }
          ports << newPort
        end

        Port.import ports, validate: false, on_duplicate_key_update: { conflict_target: [:code], columns: [ :name, :city, :lat, :lng, :port_type_id, :big_schedules, :oceans_insights_code ] }
        
        json_response({ message: 'Ports uploaded successfully', count: ports.count }, :created)
      end
    
      # GET /ports/:id
      def show
        json_response(@port)
      end
    
      # DELETE /ports/:id
      def destroy
        @port.destroy
        head :no_content
      end

      def search
        if params[:pageSize].blank?
          params[:pageSize] = 10
        end

        if params[:page].blank?
          params[:page] = 1
        end

        if(params[:code])
          @port = Port.find_by_code(params[:code]).paginate(page: params[:page], per_page: params[:pageSize])

        elsif(params[:name])          
          @port = Port.where("name LIKE :query", query: "%#{params[:name]}%").paginate(page: params[:page], per_page: params[:pageSize])
            
        elsif(params[:portType])
          @port = Port.WithPortType().where("port_types.name = ?", params[:portType]).paginate(page: params[:page], per_page: params[:pageSize])
        else
          @port = nil    
        end

        if(@port.blank?) 
          json_response("Couldn't find Port", :not_found)
        else
          json_response(@port)
        end
        
      end
    
      private
    
      def set_port
        @port = Port.find(params[:id])
      end

      def is_csv_expected_format
        
      end
      
  end
end