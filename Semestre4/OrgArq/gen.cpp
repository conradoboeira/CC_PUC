#include <random>
#include <limits>
#include <iostream>

#define ACESSOS 100000
#define BRANCH_CHANCE 40

//IMPORTANTE: esse código não é de autoria minha, recebi de meus colegas Yago e Paulo pois este gera testes melhores que 
// endereços gerados aleatóriamente.

using namespace std;

unsigned int max_unsigned_int_size = numeric_limits<unsigned int>::max();

random_device rd;     // only used once to initialise (seed) engine
mt19937 rng(rd());    // random-number engine used (Mersenne-Twister in this case)
uniform_int_distribution<unsigned int> uni(0,max_unsigned_int_size); // guaranteed unbiased

auto random_integer = uni(rng);



main() {
        unsigned int PC = 0;
        for(int i = 0; i<ACESSOS; i++) {
            cout << PC << endl;
            if( rand() % BRANCH_CHANCE ) {                  //nao teve branch
                PC++;
            } else {
                PC = rand();
            }
                                    }
}
