#include <string>
#include <vector>
#include <map>
#include <list>
#include <limits>
#include <math.h>
#include "Vector3D.h"

using namespace std;

double entropy(vector<vector<double>>& front, int gridSize);
double distance(vector<double> p1, vector<double> p2);
double gauss(const double r);
vector<vector<double>> project(const list<vector<double>>& vecList);
list<vector<double>> normalize(const vector<vector<double>>& front);

double entropy(vector<vector<double>>& front, int gridSize) {
        vector<double> entropyResults_;
        double return_val = 0;
	
	auto vectorNormalized = normalize(front);
	
	double const d_ = 2.0 / gridSize;
	//Save the mid-points for later use
	vector<vector<double>> midPoints_;
	//for (double x = -1 + d_ / 2; x < 1.0; x += d_) {
	//	for (double y = -1 + d_ / 2; y < 1.0; y += d_) {
	//		//for (double z = d / 2; z < 1.0; z += d) {
	//			QVector<double> p(3);
	//			p[0] = x; p[1] = y; //p[2] = z;
	//			midPoints_.append(p);
	//		//}
	//	}
	//}
        
	for (int dx_ = 0; dx_ < 10; dx_++) {
		const auto x_ = -1 + d_ / 2 + dx_ * d_;
		for (int dy_ = 0; dy_ < 10; dy_++) {
			const auto y_ = -1 + d_ / 2 + dy_ * d_;
			vector<double> p(3);
			p[0] = x_; p[1] = y_; //p[2] = z;
			midPoints_.emplace_back(p);
		}
	}

	const int cells_ = gridSize * gridSize;

	//now calculate the Entropy for Front
		//project the front to a 2D plane
		auto front2D_ = project(vectorNormalized);
		//calculate the distance between each point from the non - dominated set and each grid cell
		//save it to an 2 - dimensional array
		vector<vector<double>> dis_(cells_);
		for (int i = 0; i < cells_; i++) {
			vector<double> dist_(front2D_.size());
			for (int j = 0; j < front2D_.size(); j++) {
				dist_[j] = distance(front2D_[j], midPoints_[i]);
			}
			dis_[i] = dist_;
		}
		//calculate the density at each cell
		double sumD_ = 0;
		vector<double> D(cells_);
		for (int i = 0; i < cells_; i++) {
			for (int j = 0; j < front2D_.size(); j++) {
				D[i] += gauss(dis_[i][j]);
			}
			sumD_ += D[i];
		}

		//normalized density at each cell
		vector<double> rho_(cells_);
		for (auto i = 0; i < cells_; i++) {
			rho_[i] = D[i] / sumD_;
		}

		//finally calculate the entropy
		//note that the "minus" can be moved into the sum
		double H = 0;
		for (auto i = 0; i < cells_; i++) {
			H -= rho_[i] * log(rho_[i]);
		}
		return_val = H;
	//qDebug() << entropyResults_;
	return return_val;
}

double distance(vector<double> p1, vector<double> p2) {
	return sqrt(pow(p1[0] - p2[0], 2) + pow(p1[1] - p2[1], 2)); //+ std::pow(p1[2] - p2[2], 2));
}

double gauss(const double r) {
	//return 6 * (std::exp(18 * (std::pow(-r, 2)))) / (std::sqrt(2 * PI()));
	double const sigma_ = 1.0 / 6.0;
	double const omega_ = (1 / sigma_ * sqrt(2 * 3.141592653589)) * exp(-1 * pow(r, 2) / (2 * sigma_*sigma_));
	return omega_;
}

vector<vector<double>> project(const list<vector<double>>& vecList) {
	const Vector3D bad_(1.0, 1.0, 1.0), u2_(0.0, 1.0, 0.0), u3_(0.0, 0.0, 1.0);
	const Vector3D v1_ = bad_.normalized();
	
	Vector3D v2_ = u2_ - ((u2_ * v1_) * v1_);
	//v2 = v2 / v2.length();
	v2_.normalize();
	Vector3D v3_ = u3_ - ((u3_ * v1_) * v1_) - ((u3_ * v2_) * v2_);
	v3_ = v3_ / v3_.length();
	v3_.normalize();
	vector<vector<double>> projectedList_;
	for (auto vector_ : vecList) {
		const Vector3D f_(vector_[0], vector_[1], vector_[2]);
		double const x_ = (f_ * v2_);
		double const y_ = (f_ * v3_);
		vector<double> projected_(2);
		projected_[0] = x_;
		projected_[1] = y_;
		projectedList_.emplace_back(projected_);
	}
	return projectedList_;
}

list<vector<double>> normalize(const vector<vector<double>>& front) {
	//Find the minimum and maximum value for each objective
	vector<double> min_(3), max_(3);
	min_[0] = numeric_limits<double>::infinity();
	min_[1] = numeric_limits<double>::infinity();
	min_[2] = numeric_limits<double>::infinity();

	max_[0] = numeric_limits<double>::min();
	max_[1] = numeric_limits<double>::min();
	max_[2] = numeric_limits<double>::min();
        for (const auto& vec_ : front) {
            min_[0] = min<double>(vec_[1], min_[0]);
            min_[1] = min<double>(vec_[2], min_[1]);
            min_[2] = min<double>(vec_[3], min_[2]);

            max_[0] = max<double>(vec_[1], max_[0]);
            max_[1] = max<double>(vec_[2], max_[1]);
            max_[2] = max<double>(vec_[3], max_[2]);
	}
	
	//Normalize the vector
	list<vector<double>> frontVectorNormalized_;
        for (const auto& vec_ : front) {
            vector<double> vecNorm_(3);
            vecNorm_[0] = (double) (vec_[1] - min_[0]) / (double) (max_[0] - min_[0]);
            vecNorm_[1] = (double) (vec_[2] - min_[1]) / (double) (max_[1] - min_[1]);
            vecNorm_[2] = (double) (vec_[3] - min_[2]) / (double) (max_[2] - min_[2]);
            frontVectorNormalized_.emplace_back(vecNorm_);
	}
	
	return frontVectorNormalized_;
}
