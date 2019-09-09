class Port < ApplicationRecord
  # model association
  belongs_to :port_type, optional: true

  # validations
  validates_presence_of :name, :code

  def self.WithPortType
    Port.joins(:port_type).select("ports.*, port_types.name as port_type_name")
  end
  
  def self.ImportCSV(file_path)
    ports = []
    portTypes = PortType.all.select(:id, :name).take(10)
    # file_path = inputs[:file_path]
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
    
    return ports.count
  end

end
