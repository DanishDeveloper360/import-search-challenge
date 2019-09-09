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
        imported_count = Port.ImportCSV(file_path)
        json_response({ message: 'Ports uploaded successfully', count: imported_count }, :created)
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
          @port = Port.find_by_code(params[:code])
          
        elsif(params[:name])          
          downcase_query = params[:name].downcase()
          @port = Port.where("name ILIKE :query", query: "%#{downcase_query}%").paginate(page: params[:page], per_page: params[:pageSize])
            
        elsif(params[:portType])
          @port = Port.WithPortType().where("port_types.name = ?", params[:portType]).paginate(page: params[:page], per_page: params[:pageSize])
        else
          @port = nil    
        end

        if(@port.blank?) 
          json_response({ message: Message.not_found(Port) }, :not_found)
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