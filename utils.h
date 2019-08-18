#include <iostream>
#include <vector>

using namespace std;

typedef vector<double> Mat1D;
typedef vector<Mat1D> Mat2D;
typedef vector<Mat2D> Mat3D;


Mat2D Mat2D_init(Mat2D Mat, int y, int x) {
	
	Mat.resize(y);
	for(int i = 0; i < y; i++){
		Mat[i].resize(x);
	}

	for (int j = 0; j < y; j++) {
		for (int i = 0; i < x; i++) {
			Mat[i][j] = (double)(i + j);
		}
	}

	return Mat;
}

void show_Mat2D(Mat2D Mat) {
	for (int i = 0; i < Mat.size(); i++) {
		for (int j = 0; j < Mat[0].size(); j++) {
			//printf("%3.3lf	");
			cout << Mat[i][j] << " ";
		}
		cout << endl;
	}
}