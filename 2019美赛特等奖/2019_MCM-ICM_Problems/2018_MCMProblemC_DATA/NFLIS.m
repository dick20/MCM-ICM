clear all;
% NFLIS数据整理
data_path = 'MCM_NFLIS_Data.xlsx';
[data, text] = xlsread(data_path, 'Data', 'A2:J24063');

years = data(:, 1);
drug_report = data(:, 8);
drug_state_report = data(:, 10);
drug_county_report = data(:, 9);

state = text(:, 3);
county = text(:, 5);
%fips_state = text(:, 3);
%fips_county = text(:, 5);
drug = text(:, 6);
%clear data text;

data_len = length(years);
county_list = {};
%fips_county_list = {};
drug_list = {};
state_list = {'39', '21', '54', '51', '42'};
%{'OH','KY','WV','VA','PA'}
%fips_state_list = {39, 21, 54, 51, 42};
state2id = containers.Map(state_list, {1, 2, 3, 4, 5});
county2state = containers.Map();
drug2id = containers.Map();
%county2id = containers.Map();
county_list_map = containers.Map();
state_county_num = [0, 0, 0, 0, 0];

for i = 1:data_len
    if ~ismember(drug(i), drug_list)
        drug_list = [drug_list, drug(i)];
        drug2id(cell2mat(drug(i))) = length(drug_list);
    end
    if ~ismember(cell2mat(county(i)), county_list)
        state_code = cell2mat(state(i));
        state_idx = state2id(state_code);
        county_code = cell2mat(county(i));
        county_list = [county_list, county_code];
        %fips_county_list = [fips_county_list, fips_county(i)];
        county_list_map(county_code) = length(county_list);
        county2state(county_code) = state_code;        
        state_county_num(state_idx) = state_county_num(state_idx) + 1;
        %county2id(cell2mat(county(i))) = state_county_num(state_idx);
    end
end

year_list = [2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017];
drug_state = zeros(length(state_list), length(year_list), length(drug_list));
drug_county = zeros(length(county_list), length(year_list), length(drug_list));
drug_state_total = zeros(length(state_list), length(year_list));
drug_county_total = zeros(length(county_list), length(year_list));
for i = 1:data_len
    state_idx = state2id(cell2mat(state(i)));
    year_idx = years(i) - 2009;
    drug_idx = drug2id(cell2mat(drug(i)));
    %county_idx = county2id(cell2mat(county(i)));
    county_list_idx = county_list_map(cell2mat(county(i)));
    drug_county(county_list_idx, year_idx, drug_idx) = drug_report(i);
    drug_state(state_idx, year_idx, drug_idx) = drug_state(state_idx, year_idx, drug_idx) + drug_report(i);
    drug_state_total(state_idx, year_idx) = drug_state_report(i);
    drug_county_total(county_list_idx, year_idx) = drug_county_report(i);
end

