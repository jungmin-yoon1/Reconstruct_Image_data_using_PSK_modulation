clc; clear; close all;

%% image settings
%load image
image_original=imread('starry_night.jpg'); %min:0. max:255, RGB

%image parameters settings
Height_=size(image_original,1); %height 
Width_=size(image_original,2); %weight
CH_=size(image_original,3); %RGB channel
Level=double(max(max(max(image_original)))); %pixel value range
Level_binary=ceil(log2(Level)); % # of required bits for pixel

%plot the original image
figure
imshow(image_original)

%image vectorization
image_vec=image_original(:); %size : 1519200X1

%image binarize : decimal to binary
image_bit=de2bi(image_vec); %size : 1519200X8

%bit vectorization
bit_stream = image_bit(:); %size : 12153600X1
N_bits=length(bit_stream); %number of bits

%% BPSK modulation & demodulation
% Eb/No settings
Eb_mW=1; Eb_dBm=pow2db(Eb_mW);
Eb_No_dB=-5;
No_dBm=Eb_dBm-Eb_No_dB;
No_mW=db2pow(No_dBm);

%BPSK symbol generation
s=2*double(bit_stream)-1;

%Rayleigh generation
h=(randn(N_bits,1)+1j*randn(N_bits,1))/sqrt(2);

%noise generation
n=sqrt(No_mW/2)*(randn(N_bits,1)+1j*randn(N_bits,1));

%received signal
y=h.*s+n;

%channel equalization 채널 보상
r=(conj(h)./abs(h).^2).*y;

%decoding
bit_stream_re=real(r)>0;

%ber calculation
ber_=[sum(bit_stream_re~=bit_stream)]/N_bits;

%% reconstruct image file
%construct bit matrix - 10진법으로 바꾸려고
image_bit_re=reshape(bit_stream_re,[Height_*Width_*CH_,Level_binary]);
%binary to decimal
image_vec_re=bi2de(image_bit_re);
%image file vector to matrix 
image_re=uint8(reshape(image_vec_re,[Height_,Width_,CH_]));

figure
imshow(image_re)









