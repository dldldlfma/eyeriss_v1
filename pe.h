#include <iostream>
#include <vector>

using namespace std;

class PE {
private:

public:
	double weight[12];
	double if_map[224];
	double p_sum[30];


	int weight_id;
	
	int if_map_id;

	double* dram_value;

	int stride;
	int padding;
	int channel;
	int i_size;
	int f_size;
	int o_size;
	int num_of_filter;


	PE()
	{

	}


	void set_size_value(int input_size, int filter_size, int num_of_filter) {
		this->i_size = input_size;
		this->f_size = filter_size;
		this->o_size = (input_size - filter_size) + 1;
		this->num_of_filter = num_of_filter;
	}

	void set_stride_padding_value(int stride, int padding) {
		this->stride = stride;
		this->padding = padding;
	}

	void init_reg_file() {
		for (int i = 0; i < f_size; i++) {
			weight[i] = 0;
		}
		for (int i = 0; i < i_size; i++) {
			if_map[i] = 0;
		}
		for (int i = 0; i < o_size; i++) {
			p_sum[i] = 0;
		}
	}

	void set_dram_path(double* a) {
		this->dram_value = a;
	}




	void set_weight_id(int id) {
		weight_id = id;
	}

	void set_weight(int i, int j) {
		if (i == weight_id) {
			weight[j] = (double) *dram_value;
		}
	}

	void show_weight() {
		for (int i = 0; i < f_size; i++) {
			cout << weight[i] << " ";
		}
		cout << endl;
	}


	void set_if_map_id(int id) {
		if_map_id = id;
	}

	void set_if_map(int i, int j) {
		if (i == if_map_id) {
			if_map[j] = (double)* dram_value;
		}
	}

	

	void show_if_map() {
		for (int i = 0; i < i_size; i++) {
			cout << if_map[i] << " ";
		}
		cout << endl;
	}

	void set_omap() {
		for (int i = 0; i < o_size; i++) {
			p_sum[i] = 0;
		}
	}

	void single_line_calc() {
		for (int i = 0; i < o_size; i++) {
			for (int j = 0; j < f_size; j++) {
				//cout << p_sum[i] << endl;
				p_sum[i] += weight[j] * if_map[i + j];
			}
		}
	}

	void show_psum() {
		for (int i = 0; i < o_size; i++) {
			printf("%.2lf ", p_sum[i]);
		}
		printf("\n");
	}	

};