class Processes


    def self.source_url(source)
        if source == "mzk" 
            "https://kramerius.mzk.cz"
        elsif source == "kfbz" 
            "http://kramerius.kfbz.cz"
        elsif source == "nm" 
            "https://kramerius.nm.cz"
        elsif source == "mlp" 
            "https://kramerius4.mlp.cz"
        end
    end

    def self.renew_data(source)
        url = "#{Processes.source_url(source)}/search/api/v5.0/search?q=*:*&fq=fedora.model:soundrecording&fl=PID,dostupnost,dc.creator,keywords,dc.title,datum_str&rows=3000&start=0"
        albums = Processes.get(url)
        albumMap = {}
        albums.each do |album|
            pid = album['PID']
            c = Album.where("pid='#{pid}' AND source='#{source}'")
            a = c.count > 0 ? c.first : Album.new
            a.pid = album['PID']
            a.title = album['dc.title']

            genres = []
            unless album['keywords'].nil? 
                album['keywords'].each do |genre|
                    if genre == "rocková hudba"
                        genre = "rock"
                    elsif !["populární hudbapopulární písně", "populární hudba", "populární písně"].index(genre).nil?
                        genre = "pop"
                    elsif !["country hudba", "country music"].index(genre).nil?
                        genre = "country"
                    end
                    genre = genre.upcase_first
                    genres.push(genre)
                end
            end
            a.genres = genres.join(";;")

            artists = []
            unless album['dc.creator'].nil? 
                album['dc.creator'].each do |artist|
                    artist.gsub!(" (hudební skupina)", "")
                    if !artist.index(", 1").nil?
                        artist = artist[0, artist.index(", 1")]
                    end
                    artist.strip!
                    if artist.scan(", ").count == 1 && artist.scan(" ").count <= 2
                        artist = artist.split(", ").reverse.join(" ")
                    end
                    artist = artist.upcase_first
                    artists.push(artist)
                end
            end
            a.artists = artists.join(";;")

            a.date = album['datum_str']
            a.is_private = album['dostupnost'] == 'private'
            a.source = source
            a.save
            albumMap[a.pid] = a
        end
        return

        url = "#{Processes.source_url(source)}/search/api/v5.0/search?q=*:*&fq=fedora.model:soundunit&fl=PID,dc.title&rows=3000&start=0"
        units = Processes.get(url)
        unitMap = {}
        units.each do |unit|
            pid = unit['PID']
            title = unit['dc.title']
            unitMap[pid] = title
        end


        tracks = []
        start = 0
        rows = 1000
        while true
            url = "#{Processes.source_url(source)}/search/api/v5.0/search?q=*:*&fq=fedora.model:track&fl=PID,dostupnost,dc.title,model_path,pid_path&rows=#{rows}&start=#{start}"
            url += "&sort=created_date asc" if source != "kfbz"
            st = Processes.get(url)
            st.each do |track|
                pid = track['PID']
                c = Track.where("pid='#{pid}' AND source='#{source}'")
                t = c.count > 0 ? c.first : Track.new
                sri = track['model_path'][0].split("/").index("soundrecording")
                puts "sri #{sri}"
                next if sri.nil?
                album_pid = track['pid_path'][0].split("/")[sri]
                puts "album_pid #{album_pid}"

                sui = track['model_path'][0].split("/").index("soundunit")
                unless sui.nil?
                    unit_pid = track['pid_path'][0].split("/")[sui]
                    unit = unitMap[unit_pid]
                    t.unit = unit unless unit.nil?
                end
                album = albumMap[album_pid]
                puts "album - {album}"
                next if album.nil?
                t.album = album
                t.pid = track['PID']
                t.title = track['dc.title']
                t.is_private = track['dostupnost'] == 'private'
                t.source = source
                t.position = album.tracks.count if t.position.nil?
                t.save
            end
            break if st.count == 0 
            start += rows
        end

    end


    private
        def self.get(url)
            uri = URI(url)
            http = Net::HTTP.new(uri.host, uri.port)
            if url.start_with? "https"
                http.use_ssl = true 
                http.verify_mode = OpenSSL::SSL::VERIFY_PEER
                # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            end
            req =  Net::HTTP::Get.new(uri)
            req.add_field "Content-Type", "application/json; charset=utf-8"
            req.add_field "Accept", "application/json"
            res = http.request(req)
            res.body
            JSON.parse(res.body)['response']['docs']
        end 

end