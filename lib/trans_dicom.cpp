#include <cstdlib>
#include<iostream>
#include<fstream>
#include<sys/stat.h>
#include <stdio.h>
#include <stdlib.h>

using namespace std;

void save_output(float *ecg_signal, int ecg_signal_length){
  ofstream out_file;
  out_file.open("out_data.txt");
  for(int index = 0; index < ecg_signal_length; index++){
  	out_file << ecg_signal[index] << endl;
  }
  out_file.close();
}

float* process_file(int ecg_channel, int ecg_signal_length, FILE* ecg_file){	

  float *ecg_signal;
  ecg_signal = new float[ecg_signal_length];
  unsigned char *ecg_signal_buffer;
  ecg_signal_buffer = new unsigned char[1];

  if(ecg_channel > 1)
    fread(ecg_signal_buffer, sizeof(char), ecg_channel - 1, ecg_file);
  for(int index = 0; index < ecg_signal_length; index++)
  {
	  fread(ecg_signal_buffer, sizeof(char), 3, ecg_file);
	  ecg_signal[index] = float((2.2E-7)*ecg_signal_buffer[0]);
  }
  fclose(ecg_file);
  return ecg_signal;
}

int calculate_length(char *ecg_file_path){
  struct stat ecg_file_s;
  stat(ecg_file_path, &ecg_file_s);
  int ecg_signal_length = ecg_file_s.st_size / 3;
  return ecg_signal_length;
}

int main(int argc, char *argv[]){

  int ecg_channel = 2;
  char *ecg_file_path = "temporary.dcm";
  FILE *ecg_file = fopen(ecg_file_path, "rb");
  int ecg_signal_length = calculate_length(ecg_file_path);
  float *ecg_signal = process_file(ecg_channel, ecg_signal_length, ecg_file);
  save_output(ecg_signal, ecg_signal_length);
}