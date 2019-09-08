module V2
    class PortsController < ApplicationController
        def index
            json_response({ message: 'Dummy response for versioning check'})
        end
    end
end
