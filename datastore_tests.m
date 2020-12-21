close all;
clc;

import matlab.io.*

ds = fileDatastore('0114\011442793','ReadFcn',@ReadFITFunc)
ds = transform(ds,@mediands);
data=readall(ds);

% data = cell2underlying(data1);

figure
plot(data.TIME, data.SAP_FLUX);
hold all;
plot(data.TIME,data.PDCSAP_FLUX);





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

end

function file_names=read_light_curve(kepid, keper_data_dir)% Reads light curves and returnes file_names of read light curve

end

function [time,flux]=process_light_curve(all_time, all_flux) % remove low-frequence variability from a light curves and returns time,flux

end

function [time, values]=phase_fold_and_sort_light_curve(time, values, period, t0) % Sorts light curve by acending time

end

function view=generate_view(time,values,num_bins,bin_width,t_min,t_max,normalize)% generates a view of phase-folded and binned light curves in fuction we must define normalize as "True", boolean

end

function generate_view=global_view(time, values, period, num_bins,bin_width_factor) % returns Global View of Light curve(corrected define num_bins as 2001 and bin_width_factor as 1/2001

end

function generate_view=local_view(time,values,period,duration,num_bins,bin_width_factor,num_durations)% Returns local view of one dip area define num_bins as 201 bin_width_factor as 0.16 and num_durations as 4

end

function ex=generate_example_for_tce(time,flux,tce) % Generates a train example representing an input TCE

end

function preprocess=process_tce(tce) % it should really return preprocess.generate_example_for_tce(time, flux, tce)

end

function process_file_shard=process_file_shard(tce_table, file_name)

end

function main=main(argv)

end
