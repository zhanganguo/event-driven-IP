function noisy_data = makenoise(data, noise_type, snr)

gaussian_noise = {
  struct('snr', '-3db', 'param', struct('a', 0, 'theta', 0.33465))
};
uniform_noise = {
    struct('snr', '-3db', 'param', struct('alpha', 0, 'beta', 0.5793))
};
rayleigh_noise = {
    struct('snr', '-3db', 'param', struct('alpha', 0, 'beta', 0.33417))
};
gamma_noise = {
    struct('snr', '-3db', 'param', struct('n', 4, 'alpha', 18.78))
};
saltpepper_noise = {
    struct('snr', '-3db', 'param', struct('p', 0.06))
};

if strcmp(noise_type, 'none') == 1
    data_noise = zeros(size(data));
elseif strcmp(noise_type, 'gaussian') == 1  
    noise_parameters = get_param(gaussian_noise, snr);
    a = noise_parameters.a;
    theta = noise_parameters.theta;
    data_noise = a + theta * randn(size(data));
elseif strcmp(noise_type, 'rayleigh') == 1
    noise_parameters = get_param(rayleigh_noise, snr);
    alpha = noise_parameters.alpha;
    beta = noise_parameters.beta;
    data_noise = alpha + beta * (-log(1-rand(size(data)))).^0.5 .* sign(rand(size(data))-0.5);
elseif strcmp(noise_type, 'uniform') == 1
    noise_parameters = get_param(uniform_noise, snr);
    alpha = noise_parameters.alpha;
    beta = noise_parameters.beta;
    data_noise =  alpha + (beta - alpha) * (rand(size(data))-0.5) * 2;
elseif strcmp(noise_type, 'gamma') == 1
    noise_parameters = get_param(gamma_noise, snr);
    alpha = noise_parameters.alpha;
    n = noise_parameters.n;
    data_noise = zeros(size(data));
    for i = 1 : n
        data_noise = data_noise + (-1/alpha) .* log(1 - rand(size(data_noise)));
    end
elseif strcmp(noise_type, 'pepper') == 1
    noise_parameters = get_param(saltpepper_noise, snr);
    p = noise_parameters.p;
    x = rand(size(data));
    data_noise = zeros(size(data));
    data_noise(x<=p) = -1;
    data_noise(x>p & x<2*p) = 1;
end

noisy_data = data + data_noise;
noisy_data(noisy_data < 0) = 0;
noisy_data(noisy_data > 1) = 1;

end

function parameters = get_param(noise_option, snr)
for op = 1 : numel(noise_option)
    if strcmp(noise_option{op}.snr, snr) == 1
        parameters = noise_option{op}.param;
    end
end
end
