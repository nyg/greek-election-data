require 'net/http'
require 'json'
require 'csv'

# content of statics.js is almost valid JSON
uri = URI('http://ekloges.ypes.gr/current/stat/v/statics.js')
content = Net::HTTP.get(uri)

# make content parsable
content.gsub!(/window.static=|;/, '')
content.gsub!(/\s(epik|snom|ep|dhm|den|party):/, '"\1":')

# create json object
json = JSON.parse(content)

# helper to create csv files
def parse_data(array, csv_header, filename, parse_fn)
    CSV.open('data/' + filename + '.csv', 'w') { |csv|
        csv << csv_header
        array.each { |x|
            csv << parse_fn.call(x)
        }
    }
end

# create parties.csv - κόμματα
header = ['id', 'name']
parse_data(json['party'], header, 'parties', lambda { |x|
    [x[0], x[2]]
})

# create districts.csv - εκλογικές περιφέρειες
header = ['id', 'name', 'stations', 'seats']
parse_data(json['ep'], header, 'districts', lambda { |x|
    [x[0], x[1], x[2], x[4]]
})

# create municipality.csv - δήμοι
header = ['id', 'name', 'stations', 'district']
parse_data(json['dhm'], header, 'municipalities', lambda { |x|
    [x[0], x[1], x[2], x[3]]
})

# create (municipal) units.csv - δημοτικές ενότητες
header = ['id', 'name', 'stations', 'municipality']
parse_data(json['den'], header, 'units', lambda { |x|
    [x[0], x[1], x[2], x[3]]
})
