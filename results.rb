require 'net/http'
require 'json'
require 'csv'

CSV.open('data/unit_results.csv', 'w') { |csv|

    csv << ['unit_id', 'party_id', 'votes']

    # get json result for each municipal unit
    first = true
    CSV.foreach('data/units.csv') { |row|

        if first
            first = false
            next
        end

        unit_id = row[0]

        uri = URI('http://ekloges.ypes.gr/current/dyn/v/den_' + unit_id + '.js')
        puts uri

        json = JSON.parse(Net::HTTP.get(uri))
        json['party'].each { |x|
            csv << [unit_id, x['PARTY_ID'], x['VOTES']]
        }
    }
}
