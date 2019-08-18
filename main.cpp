// eyeriss_module_test.cpp : 이 파일에는 'main' 함수가 포함됩니다. 거기서 프로그램 실행이 시작되고 종료됩니다.
//


#include <iostream>
#include <vector>
#include "pe.h"
#include "utils.h"

#define PE_ARRAY_ROW 10
#define PE_ARRAY_COL 10
#define FILTER_SIZE 3
#define IFMAP_SIZE 32
#define CHANNEL 1

using namespace std;


typedef vector<PE> PE_1D;
typedef vector<PE_1D> PE_2D;


int main()
{

	double dram_data;
	PE_2D PE_array;

	PE_array.resize(PE_ARRAY_ROW);

	for (int i = 0; i < PE_ARRAY_ROW; i++) {
		PE_array[i].resize(PE_ARRAY_COL);
	}

	for (int i = 0; i < PE_ARRAY_ROW; i++) {
		for (int j = 0; j < PE_ARRAY_COL; j++) {
			PE_array[i][j].dram_value = &dram_data;
		}
	}

	cout << PE_array.size() << endl;
	cout << PE_array[0].size() << endl;


	Mat2D weight;
	weight = Mat2D_init(weight, 3, 3);
	Mat2D ifmap;
	ifmap = Mat2D_init(ifmap, 32, 32);
	
	//Set_weight_id;
	cout << "------PE_array value setup----------"<< endl;
	for (int pe_y = 0; pe_y < PE_array.size(); pe_y++) {
		for (int pe_x = 0; pe_x < PE_array[0].size(); pe_x++) {
			PE_array[pe_y][pe_x].set_size_value(32, 3, 1);
			PE_array[pe_y][pe_x].set_weight_id(pe_y%3); //%3 
			PE_array[pe_y][pe_x].init_reg_file();
		}
	}
	cout << endl;




	cout << "------weight pipeline set up------" <<endl; 
	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			cout << weight[i][j] << " ";
			dram_data = weight[i][j];
			for (int pe_y = 0; pe_y < PE_array.size(); pe_y++) {
				for (int pe_x = 0; pe_x < PE_array[0].size(); pe_x++) {
					PE_array[pe_y][pe_x].set_weight(i, j);
				}
			}
		}
		cout << endl;
	}
	cout << endl;




	cout <<"-----PE_array weight show-----"<<endl;
	for (int pe_y = 0; pe_y < PE_array.size(); pe_y++) {
		for (int pe_x = 0; pe_x < PE_array[0].size(); pe_x++) {
			PE_array[pe_y][pe_x].show_weight();
		}
		cout << endl;
	}

	cout << "-----Set PE_array ifmap_id-----" << endl;
	for (int pe_y = 0; pe_y < PE_array.size(); pe_y++) {
		for (int pe_x = 0; pe_x < PE_array[0].size(); pe_x++) {
			PE_array[pe_y][pe_x].set_if_map_id( int(pe_y/FILTER_SIZE)* PE_ARRAY_ROW + (pe_y%FILTER_SIZE) + pe_x);
		}
	}

	cout << "-----Show PE_array ifmap_id-----" << endl;
	for (int pe_y = 0; pe_y < PE_array.size()-1; pe_y++) {
		for (int pe_x = 0; pe_x < PE_array[0].size(); pe_x++) {
			cout << PE_array[pe_y][pe_x].if_map_id << " ";
		}
		cout << endl;
	}

	cout << "-----Set PE_array ifmap_value-----" << endl;
	for (int i = 0; i < ifmap.size(); i++) {  //32
		for (int j = 0; j < ifmap[0].size(); j++) { //32
			dram_data = ifmap[i][j];
			for (int pe_y = 0; pe_y < PE_array.size(); pe_y++) {
				for (int pe_x = 0; pe_x < PE_array[0].size(); pe_x++) {
					PE_array[pe_y][pe_x].set_if_map(i, j);

				}
			}
		}
	}

	cout << "-----Show PE_array ifmap-----" << endl;
	for (int pe_y = 0; pe_y < PE_array.size()-1; pe_y++) {
		cout << " ---" << pe_y << "---" << endl;
		for (int pe_x = 0; pe_x < PE_array[0].size(); pe_x++) {
			PE_array[pe_y][pe_x].show_if_map();
		}
		cout << endl;
	}

	cout << "----- Ifmap array -----" << endl;
	show_Mat2D(ifmap);

	cout << "----calculation-----" << endl;
	for (int pe_y = 0; pe_y < PE_array.size() - 1; pe_y++) {
		for (int pe_x = 0; pe_x < PE_array[0].size(); pe_x++) {
			PE_array[pe_y][pe_x].single_line_calc();
		}
		cout << endl;
	}

	cout << "----show p_sum-----" << endl;
	for (int pe_y = 0; pe_y < PE_array.size() - 1; pe_y++) {
		for (int pe_x = 0; pe_x < PE_array[0].size(); pe_x++) {
			PE_array[pe_y][pe_x].show_psum();
		}
		cout << endl;
	}

	cout << "----ofmap_init-----" << endl;
	Mat2D ofmap;
	ofmap.resize(IFMAP_SIZE - FILTER_SIZE + 1);
	for (int i = 0; i < ofmap.size(); i++) {
		ofmap[i].resize(IFMAP_SIZE - FILTER_SIZE + 1);
		for (int j = 0; j < IFMAP_SIZE - FILTER_SIZE + 1; j++) {
			ofmap[i][j] = 0;
		}
	}

	cout << "----p_sum accumulation for ofmap-----" << endl;
	for (int i = 0; i < 9; i++) {
		for (int j = 0; j < 10; j++) {
			for (int k = 0; k < 30; k++) {
				ofmap[int(i/3)*10 + j][k] += PE_array[i][j].p_sum[k];
			}
		}
	}
	cout << "----show ofmap-----" << endl;
	show_Mat2D(ofmap);
	return 0;
}