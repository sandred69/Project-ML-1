close all;
clc;

import matlab.io.*

ds = fileDatastore('Project\011442793','ReadFcn',@ReadFITFunc)
ds = transform(ds,@mediands);

data=readall(ds);




figure
% plot(data.TIME, data.SAP_FLUX);
hold all;
% plot(data.TIME,data.PDCSAP_FLUX);


ds = transform(ds,@process_light_curve);

data=readall(ds);

data = phase_fold_and_sort_light_curve(data);

plot(data.TIME,data.PDCSAP_FLUX,'o');

function tabledData =   ReadFITFunc(filename)

import matlab.io.*

info = fitsinfo(filename);

fptr=fits.openFile(filename);
fits.movAbsHDU(fptr,2);
[tnum,tname]=fits.getColName(fptr,'time');
[sapnum,sapname]=fits.getColName(fptr,'SAP_FLUX');
[pdnum,pdname]=fits.getColName(fptr, 'PDCSAP_FLUX');
fits.closeFile(fptr);

tableData=fitsread(filename,'binarytable',...
    'Info',info,...
    'TableColumns', [tnum,sapnum,pdnum]);

tableArray = cell2mat(tableData);

tabledData = array2table(tableArray, 'VariableNames',[tname,sapname,pdname]);
end

function ds = mediands(ds)

ds.PDCSAP_FLUX = ds.PDCSAP_FLUX / nanmedian(ds.PDCSAP_FLUX);
% figure
% plot(ds.TIME,ds.PDCSAP_FLUX);hold all;

% plot(ds.TIME,ds.PDCSAP_FLUX);

end

function file_names=read_light_curve(kepid, keper_data_dir)% Reads light curves and returnes file_names of read light curve % Kepid is the Kepler ID found in the CSV file, Kepler_data_dir is the directory in which your CSV file is located

end

function ds = process_light_curve(ds) % remove low-frequence variability from a light curves and returns time,flux all_time and all_flux is defined in the function read_light_curve
%  threshold  = 0.75 ;
%  boundaries = [true, diff(ds.TIME) > threshold, true,true] ;
%  time_flux = mat2cell([ds.TIME, ds.PDCSAP_FLUX],[diff(find(boundaries))],2);
%  Asamplepoints = cellfun(@(x) smoothdata(x(:,2),'movmedian',2,'SamplePoints',x(:,1)),time_flux,'UniformOutput',false);
ds.TIME = inpaint_nans(ds.TIME);
ds.PDCSAP_FLUX = ds.PDCSAP_FLUX ./ (smoothdata(ds.PDCSAP_FLUX,'movmedian',2,'omitnan','SamplePoints',ds.TIME));
 
end

function data =phase_fold_and_sort_light_curve(data) % Sorts light curve by acending time time found in CSV file Values is the sorted time period is the tce_period, which is the orbital period of the detected event in days can be found in CSV file t0: The center of the resulting folded vector; this value is mapped to 0.

period = 331.603;%%TODO: Need to get this from CSV file per source
t0 = 140.48;%%TODO: Need to get this from CSV file per source
hperiod = period/2;
data.TIME = mod(data.TIME + (hperiod -t0),period);
data.TIME = data.TIME - hperiod;
data = sortrows(data,1);

end

function view=generate_view(time,values,num_bins,bin_width,t_min,t_max,normalize)% generates a view of phase-folded and binned light curves in fuction we must define normalize as "True", boolean time input is the "Corrected" time from the function above the values is the corrected time from above num_bins is from the CSV file bin_width=period * bin_width_factor, 2001. t_min=-period / 2, t_max=period / 2

end

function generate_view=global_view(time, values, period, num_bins,bin_width_factor) % returns Global View of Light curve(corrected define num_bins as 2001 and bin_width_factor as 1/2001

end

function generate_view=local_view(time,values,period,duration,num_bins,bin_width_factor,num_durations)% Returns "Coordinates" of local view of one dip area define num_bins as 201 bin_width_factor as 0.16 and num_durations as 4 time values and period are defined and refined in functionsa above and are being passed again into this function which will return one local light curve in a "Zoomed" in fasion

end

function ex=find_tce(time,flux,tce) % Generates a train example representing an input TCE flux is the rturn from process_light_curve, all_flux

end

function preprocess=process_tce(tce) % it should really return preprocess.generate_example_for_tce(time, flux, tce) transiting period, found in CSV file

end

function process_file_shard=process_file_shard(tce_table, file_name)% data frame containing the TCE in the shard the file_name is where it is stored

end

function main=main(argv)% main argument argv

end
