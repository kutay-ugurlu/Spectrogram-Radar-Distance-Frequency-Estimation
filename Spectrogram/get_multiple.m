function [signal, t] = get_multiple(number_of_components,total_length, F_s, frequency, amplitude, phase)
t = linspace(0,total_length,total_length*F_s);
signal = 0;
for i = 1:number_of_components
    temp = get_cosine(total_length,F_s,frequency(i),amplitude(i),phase(i));
    signal = signal + temp;
end
end