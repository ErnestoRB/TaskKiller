# include <iostream>
using namespace std;

int main(int argc, char** argv) {
	if(argc < 2) {
		cout << "Especifica como argumento el numero de kilobytes a reservar!!" << endl;
		return 1;
	}
	int N = atoi(argv[1]);
	if(N <= 0) {
		cout << "Especifica un numero positivo" << endl;
		return 1;
	}
	char** arreglo = new char*[N];
	for (int n=0;n<N;n++) {
		arreglo[n] = new char[1024];
	}
	while (1) {}
	return 0;
}
