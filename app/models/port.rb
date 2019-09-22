class Port < ApplicationRecord
  # model association
  belongs_to :port_type, optional: true

  # validations
  validates_presence_of :name, :code

  include PgSearch
  pg_search_scope :search, against: [:name, :code, :city, :oceans_insights_code, :created_at, :updated_at], 
  associated_against: {
    port_type: [ :name ]
  },
    using: {
        tsearch: {
            prefix: true
        }
    }

  def self.WithPortType
    Port.joins(:port_type).select("ports.*, port_types.name as port_type_name")
  end

  def self.search_partial_text(downcase_query)
    Port.joins(:port_type).where("port_types.name ILIKE :query OR ports.name ILIKE :query OR code ILIKE :query OR city ILIKE :query OR oceans_insights_code ILIKE :query", query: "%#{downcase_query}%").select("ports.*, port_types.name as port_type_name")
  end
  
  # Import CSV ports data
  def self.ImportCSV(file_path)
    ports = []
    portTypes = PortType.all.select(:id, :name).take(10)
    
    CSV.foreach(file_path, headers: true) do |row|

      raise(ExceptionHandler::HeaderCorrupt, Message.header_corrupt) unless ['Name', 'Code', 'City', 'Port type', 'Oceans insights code','Latitude', 'Longitude', 'Bigschedules' ].all? { |header| row.headers.include? header }

      propTypeForRow = portTypes.select {|e| e[:name] == row['Port type']}

      if propTypeForRow.count <= 0
        # avoiding the N+1 insert problem 1 : Since Port Type are identified from business requirement to be two in number (very few), this approach will not hit database every time
        # avoiding the N+1 insert problem 2 : Activerecord-Import also provides :recursive option for Imports has_many/has_one associations, but I found out very very late and decided not to use it for this test
        PortType.create!(:name => row['Port type'], 
          :created_at => row['Created at'].blank? ? Date.today() : DateTime.parse(row['Created at']), 
          :updated_at => row['Updated at'].blank? ? Date.today() : DateTime.parse(row['Updated at']))
        portTypes = PortType.all.select(:id, :name).take(10)
        propTypeForRow = portTypes.select {|e| e[:name] == row['Port type']}
      end

      if row['Code'].present?
        newPort = { :name => row['Name'], :code => row['Code'], :city => row['City'], 
        :oceans_insights_code => row['Oceans insights code'], :lat => row['Latitude'], :lng => row['Longitude'], :big_schedules => row['Bigschedules'], 
        :created_at => row['Created at'].blank? ? Date.today() : DateTime.parse(row['Created at']), 
        :updated_at => row['Updated at'].blank? ? Date.today() : DateTime.parse(row['Updated at']),
        :port_type_id => propTypeForRow[0][:id], :port_hub => row['Hub port'] }

        # storing in-memory array
        ports << newPort
      end
    end

    # bulk inserting data | perform on duplicate key updates
    Port.import ports, validate: false, on_duplicate_key_update: { conflict_target: [:code], columns: [ :name, :city, :lat, :lng, :port_type_id, :big_schedules, :oceans_insights_code, :port_hub ] }
    
    return ports.count
  end

end
