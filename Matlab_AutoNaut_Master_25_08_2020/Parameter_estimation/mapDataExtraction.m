function [data] = mapDataExtraction(timestamp, latitude, longitude, latitude_map, longitude_map, map_data)
    [n_positions,~] = size(latitude);
    [lat_size_map, long_size_map] = size(map_data(:,:,1));
    data = zeros(1,n_positions);
    hour = round(timestamp/3600);

    for i = 1:n_positions
        lat = latitude(i);
        long = longitude(i); 
        long_lat = repmat(lat,lat_size_map,long_size_map);
        long_long = repmat(long,lat_size_map,long_size_map);
        pos_diff = Haversine_deg(long_lat,long_long,latitude_map,longitude_map,6371*10^3);
        [test, index] = minmat(pos_diff);
        data(i) = map_data(index(1),index(2),hour(i));
    end
end

