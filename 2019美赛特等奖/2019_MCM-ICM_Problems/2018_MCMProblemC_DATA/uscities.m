city_path = 'uscities.xlsx';
[data, text] = xlsread(city_path);
infor_order = data(:, 1);

lat = data(:, 5);
lng = data(:, 6);
population = data(:, 7);
density = data(:, 8);
clear data text;

order_map = containers.Map();
for i = 1:length(infor_order)
    order_map(num2str(infor_order(i))) = i;
end

load struct_data
county_num = length(county_list);
year_num = 8;
lat_expand = [];
lng_expand = [];
population_expand = [];
density_expand = [];
for i = 1:county_num
    county_id = cell2mat(county_list(i));
    try
        idx = order_map(county_id);
        pre = idx;
    catch
        idx = pre;
    end
    lat_expand = [lat_expand; ones(year_num, 1) * lat(idx)];
    lng_expand = [lng_expand; ones(year_num, 1) * lng(idx)];
    population_expand = [population_expand; ones(year_num, 1) * population(idx)];
    density_expand = [density_expand; ones(year_num, 1) * density(idx)];
end
    
save county_data infor_order lat lat_expand lng_expand population population_expand density density_expand 
