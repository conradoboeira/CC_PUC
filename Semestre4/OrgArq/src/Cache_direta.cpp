#include <iostream>
#include <cmath>
#include <bitset>
#include <cstdlib>
#include <string>
#include <fstream>
//#include <Cache_direta.h>

using namespace std;

//retorna o numero de digitos binarios para represetar n
int bin_digitos_d(int n){
    return (int) (ceil(log2(n)));
}

//retorna maks com n 1s
int mask_ones_d(int n){
    return (int) (pow(2, n) - 1);
}


void configura_cache(int tamanho_cache, int tamanho_palavra, int num_bloco, int * linhas, int * tag){
     int tamanho_tag, num_linhas, tamanho_tag_linhas,
     maior_tamanho, tamanho_atual_cache, tag_atual, linha_atual;

     tamanho_tag_linhas = 32 - bin_digitos_d(num_bloco);
     maior_tamanho = 0;

     //calculo do numero de linhas e tamanho do tag
     for(linha_atual = 2; bin_digitos_d(linha_atual) < tamanho_tag_linhas - 1; linha_atual *= 2){
         tag_atual = tamanho_tag_linhas - bin_digitos_d(linha_atual);

         tamanho_atual_cache = linha_atual * ( 1 + tag_atual + num_bloco * tamanho_palavra);

         if(tamanho_atual_cache <= tamanho_cache && tamanho_atual_cache > maior_tamanho){
             maior_tamanho = tamanho_atual_cache;
             num_linhas = linha_atual;
             tamanho_tag = tag_atual;
         }

     }

     *linhas = num_linhas;
     *tag = tamanho_tag;
}

bool acessa_cache(int pos, bool *bit_validade, int *tags, int num_bloco, int num_linhas, int tamanho_tag){

    unsigned int curr_tag, curr_linhas, curr_palavra;

    curr_palavra = pos & mask_ones_d(bin_digitos_d(num_bloco));
    curr_linhas = (pos & ( mask_ones_d(bin_digitos_d(num_linhas)) << bin_digitos_d(num_bloco) )) >> bin_digitos_d(num_bloco);
    curr_tag = (pos & ( mask_ones_d(tamanho_tag) << (bin_digitos_d(num_bloco) + bin_digitos_d(num_linhas)) )) >> (bin_digitos_d(num_bloco) + bin_digitos_d(num_linhas) );

    bitset<32> position (pos);
    ofstream log;
    log.open("log.txt", ios_base::app);
    log << "pos: " << position << endl;
    log << "linha: " << curr_linhas << endl;
    log << "tag: " <<curr_tag << endl;
    log << "palavra: " <<curr_palavra << endl;
    log.close();

    // cout << "pos: " << position << endl;
    // cout << "linha: " << curr_linhas << endl;
    // cout << "tag: " <<curr_tag << endl;
    // cout << "palavra: " <<curr_palavra << endl;

    if(!bit_validade[curr_linhas] || tags[curr_linhas] != curr_tag){
        bit_validade[curr_linhas] = true;
        tags[curr_linhas] = curr_tag;
        return false;
    }else {
        return true;
    }

}

int procedimento_cd(){

    int tamanho_cache, tamanho_palavra, num_bloco, num_linhas, tamanho_tag;

    // entrada bonitinha de entrada
    cout << "Tamanho da cache: ";
    cin >> tamanho_cache;
    tamanho_cache = tamanho_cache * 8; //para transformar de bytes para bits

    cout << "Tamanho da palavra: ";
    cin >> tamanho_palavra;

    cout << "Número de palavras por bloco: ";
    cin >> num_bloco;

    configura_cache(tamanho_cache, tamanho_palavra, num_bloco, &num_linhas, &tamanho_tag);

    // cout << "Número de linhas: " << num_linhas << endl;
    // cout << "Tamanho da tag: " << tamanho_tag << endl;

    cout << endl << "Forma de interpretação :" << endl;
    cout << "Tag: " << tamanho_tag << " bit(s)  "
        << "Linha: " << bin_digitos_d(num_linhas) << " bit(s)   "
        << "Palavra: " << bin_digitos_d(num_bloco) << " bit(s)" << endl << endl;

    //calculo da porcentagem de dados uteis
    double percent_dados = ((num_linhas * num_bloco * tamanho_palavra) / (float)(tamanho_cache)) * 100;
    cout << "Porcentagem de dados úteis: " << percent_dados << "%" << endl;


    //separa uma matriz para representar a memoria cache
    bool bit_validade[num_linhas] = {false};
    int tags[num_linhas] = {0};

    int num_hits = 0;
    int num_misses = 0;
    int total_reqs = 0;

    string nome, file_line;
    cout << "Arquivo teste: ";
    cin >> nome;

    ifstream arquivo (nome.c_str());
    ofstream log;
    log.open("log.txt", ios_base::app);
    log << endl << "Memoria Cache direta" << endl;
    log << "Tamanho da cache: " << tamanho_cache << endl;
    log << "Tamanho da palavra: " << tamanho_palavra << endl;
    log << "Número de palavras por bloco: " << num_bloco << endl;
    log << "Número de linhas: " << num_linhas << endl;
    log << "Tamanho da tag: " << tamanho_tag << endl;


    if(arquivo.is_open()){
        while(getline(arquivo, file_line)){
            bool resp = acessa_cache(stoi(file_line), bit_validade, tags, num_bloco, num_linhas, tamanho_tag);

            if(resp) {
                num_hits ++;
                log << "Hit" << endl;
                log << "************" << endl;
            }
            else {
                num_misses ++;
                log << "Miss" << endl;
                log << "************" << endl;
            }
        }
        total_reqs = num_misses + num_hits;
        cout << "Total de requisições: " << num_hits + num_misses << endl;
        cout << "Número de hits: " << num_hits << " Porcentagem: " << (num_hits / (double) total_reqs) * 100 << "%" << endl;
        cout << "Número de misses: " << num_misses << " Porcentagem: " << (num_misses / (double) total_reqs) * 100 << "%" << endl;
        arquivo.close();
    }
    else cout << "Não foi possível localizar arquivo" << endl;
    double tempo_total = num_hits + 10 * num_misses;
    double tempo_medio = tempo_total / total_reqs;

    cout << "Tempo médio para busca: " << tempo_medio << " unidades de tempo" << endl;
    cout << "Tempo de execução: " << tempo_total << " unidades de tempo" << endl;
    log.close();

    //
    // while(true){
    //    int pos;
    //    cout << "Posição da memória: ";
    //    cin >> pos;
    //
    //
    // }

}
//
// int main(){
//     procedimento_cd();
// }
