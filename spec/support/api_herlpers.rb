module ApiHelpers
    #convierte la respuesta en json y después convierte los keys a hash
    def json
        JSON.parse(response.body).deep_symbolize_keys
    end

    # convierte el simbolo :data a json
    def json_data
        json[:data]
    end
end