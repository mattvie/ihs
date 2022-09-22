#include <iostream>
#include <omp.h>
#include <vector>

using namespace std;

std::vector<std::vector<int>> matrix = {
    { 1, 2, 3, 4, 5 },
    { 6, 7, 8, 9, 10 },
    { 11, 12, 13, 14, 15 },
    { 16, 17, 18, 19, 20 },
    { 21, 22, 23, 24, 25 }
};
std::vector<int> sumOfAllMatrixes;

int main()
{
#pragma omp parallel for
    {
        for (auto arr : matrix) {
            int i, ID = omp_get_thread_num();
            std::cout << "Summing array " << ID << " from thread " << ID << std::endl;
            int sum = 0;
            for (auto i : arr) {
                sum += i;
            }
#pragma omp critical
            {
                sumOfAllMatrixes.push_back(sum);
            }
        }
    }

    for (auto i : sumOfAllMatrixes) {
        std::cout << i << endl;
    }
    return 0;
}
