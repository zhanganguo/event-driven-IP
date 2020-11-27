function sum_spikes = spikecount_sfnn(sfnn)

sum_spikes = 0;
for lyr = 1 : numel(sfnn.layers)
    sum_spikes = sum_spikes + sum(sum(sfnn.layers{lyr}.sum_spikes));
end