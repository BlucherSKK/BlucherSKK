#include <iostream>
#include <string>
#include <cmath>
#include <unistd.h>
#include <vector>
#include <fstream> // Для работы с файлами

using namespace std;

// Функция для установки цвета (не используется в этом варианте)
string setColor(string color) {
    if (color == "red") {
        return "\033[31m";
    } else if (color == "green") {
        return "\033[32m";
    } else if (color == "yellow") {
        return "\033[33m";
    } else if (color == "blue") {
        return "\033[34m";
    } else if (color == "magenta") {
        return "\033[35m";
    } else if (color == "cyan") {
        return "\033[36m";
    } else if (color == "white") {
        return "\033[37m";
    }
    return "\033[37m"; // По умолчанию белый
}

int main() {
    float A = 0, B = 0, i, j;
    
    int size = 5;
    //string colorInput;
    //cout << "Enter size (1-10): ";
    //cin >> size;
    //cout << "Enter color (e.g., red, green, blue): ";
    //cin >> colorInput;

    // Открываем файл для записи
    ofstream outFile("frames.txt");
    if (!outFile) {
        cerr << "Error opening file!" << endl;
        return 1;
    }

    float R1 = 1, R2 = 2, K2 = 5;
    R2 = R2 + (size - 5) * 0.2; // Масштабируем R2 на основе входного размера
    float K1 = 10 / (R1 + R2);
    vector<char> b(1760, '_');
    vector<float> z(1760, 0);
    //cout << "\x1b[2J"; // Очистка экрана
    for (;;) {
      fill(b.begin(), b.end(), '_');
      fill(z.begin(), z.end(), 0);
      for (j = 0; 6.28 > j; j += 0.07)
	for (i = 0; 6.28 > i; i += 0.02) {
	  float c = sin(i), d = cos(j), e = sin(A), f = sin(j),
	    g = cos(A), h = d + 2, D = 1 / (c * h * e + f * g + 5),
	    l = cos(i), m = cos(B), n = sin(B),
	    t = c * h * g - f * e;
	  int x = 40 + 30 * D * (l * h * m - t * n),
	    y = 12 + 15 * D * (l * h * n + t * m),
	    o = x + 80 * y,
	    N = 8 * ((f * e - c * d * g) * m - c * d * e - f * g - l * d * n);
	  if (22 > y && y > 0 && x > 0 && 80 > x && D > z[o]) {
	    z[o] = D;
	    b[o] = ".,-~:;=!*#$@"[N > 0 ? N : 0];
	  }
	}
      //cout << "\x1b[H"; // Перемещение курсора в верхний левый угол
      for (int k = 0; 1761 > k; k++)
	if (k % 80) {
	  outFile << b[k]; // Запись в файл 
	} else {
	  outFile << endl; // Перевод строки в файле
	}
      for (int i = 0; i < 161; i++)
	if (i % 80) {
	  outFile << '_';
	} else {
	  outFile << endl;
	}
      A += 0.04;
      B += 0.02;
      if((A > 6.28*2) or (B > 6.28*2)) break;
      outFile << "frame_end";  //outFile << endl;
    }

    outFile.close();
      cout << "усё";// Закрываем файл
    return 0;
}
