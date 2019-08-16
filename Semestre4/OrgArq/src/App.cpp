#include <Cache_direta.h>
#include <Cache_conjunto_assoc.h>
#include <iostream>

using namespace std;

int main(){

    int escolha;


    cout << "Tipo de cache (0 para direta, 1 para conjunto associativo): ";
    cin >> escolha;

    if(escolha) procedimento_cca();
    else procedimento_cd();
}
