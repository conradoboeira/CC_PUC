#include <iostream>
#include <cmath>
#include <bitset>
#include <cstdlib>
#include <cstring>
#include <random>
#include <string>
#include <fstream>

using namespace std;

//retorna o numero de digitos binarios para represetar n
int bin_digitos(int n){
    return (int) (ceil(log2(n)));
}

//retorna maks com n 1s
int mask_ones(int n){
    return (int) (pow(2, n) - 1);
}



int pol_random(int max_linhas){
    return rand() % max_linhas;
}

int lfu(int* acessos, int num_linhas){
    int menor, pos, i;
    menor = acessos[0];
    pos = 0;
    for(i = 1; i < num_linhas; i ++){
        if(acessos[i] < menor){
            menor = acessos[i];
            pos = i;
        }
    }

    return i;

}

int procura(int conjunto, int tag, int linhas, int num_conjunto, int **tag_mem){
    int i, resp, linhas_per_conj;
    resp = -1;
    linhas_per_conj = linhas/num_conjunto;
    // linhas_per_conj = linhas;

    for(i = 0; i < linhas_per_conj; i++){
        if(tag_mem[conjunto][i] == tag){
            resp = i + conjunto * linhas_per_conj;
            return resp;
        }
    }

    return resp;

}

void insere(int conjunto, int tag, int linhas, int num_conjunto, bool* bit_validade, int **tag_mem,
            int *pos_livre, int* acessos, int politica){
    int posicao = pos_livre[conjunto];
    //int linhas_per_conj = linhas/conjunto;
    int linhas_per_conj = linhas /num_conjunto;

    if(posicao < linhas_per_conj){
        tag_mem[conjunto][posicao] = tag;
        bit_validade[posicao + conjunto * linhas_per_conj] = true;
        pos_livre[conjunto] ++;
        acessos[posicao + conjunto * linhas_per_conj] ++;
    }
    else{
        if(politica) posicao = lfu(acessos, linhas);
        else posicao = pol_random(linhas_per_conj);
        tag_mem[conjunto][posicao] = tag;
        bit_validade[posicao + conjunto * linhas_per_conj] = true;
        acessos[posicao + conjunto * linhas_per_conj] ++;
    }
}


void configura_cache(int tamanho_cache, int tamanho_palavra, int num_bloco, int num_conjunto,
                                                                    int * linhas, int * tag){
    //calculo do numero de linhas
    *linhas = tamanho_cache / (1 + tamanho_palavra * num_bloco);

    *tag = 32 - (bin_digitos(num_bloco) + bin_digitos(num_conjunto));

}

bool acessa_cache(int pos, bool *bit_validade, int **tags, int num_bloco, int num_conjunto, int num_linhas,
                    int tamanho_tag, int* pos_livre, int* acessos, int politica){
    unsigned int curr_tag, curr_conj, curr_palavra;
    int curr_linhas;

    curr_palavra = pos & mask_ones(bin_digitos(num_bloco));
    curr_conj = (pos & ( mask_ones(bin_digitos(num_conjunto)) << bin_digitos(num_bloco) )) >> bin_digitos(num_bloco);
    curr_tag = (pos & ( mask_ones(tamanho_tag) << (bin_digitos(num_bloco) + bin_digitos(num_conjunto)) )) >> (bin_digitos(num_bloco) + bin_digitos(num_conjunto) );
    curr_linhas = procura(curr_conj, curr_tag, num_linhas, num_conjunto, tags);

    bitset<32> position (pos);
    ofstream log;
    log.open("log.txt", ios_base::app);
    log << "pos: " << position << endl;
    log << "conjunto: " << curr_conj << endl;
    log << "tag: " <<curr_tag << endl;
    log << "palavra: " <<curr_palavra << endl;
    log.close();

    // tratamento para caso não ache a tag
    if(curr_linhas == -1){
        insere(curr_conj, curr_tag, num_linhas, num_conjunto, bit_validade, tags, pos_livre, acessos, politica);
        return false;

    }else if (!bit_validade[curr_linhas]){
        bit_validade[curr_linhas] = true;
        acessos[curr_linhas] ++;
        return false;
    }else{
        acessos[curr_linhas] ++;
        return true;
    }


}

int procedimento_cca(){

    int tamanho_cache, tamanho_palavra, num_bloco, num_conjunto, num_linhas, tamanho_tag;


    // entrada bonitinha de entrada
    cout << "Tamanho da cache: ";
    cin >> tamanho_cache;
    tamanho_cache = tamanho_cache * 8; //para transformar de bytes para bits

    cout << "Tamanho da palavra: ";
    cin >> tamanho_palavra;

    cout << "Número de palavras por bloco: ";
    cin >> num_bloco;

    cout << "Número de conjuntos associativos: ";
    cin >> num_conjunto;

    configura_cache(tamanho_cache, tamanho_palavra, num_bloco, num_conjunto, &num_linhas, &tamanho_tag);

    // cout << "Número de linhas: " << num_linhas << endl;
    // cout << "Tamanho da tag: " << tamanho_tag << endl;
    cout << "Forma de interpretação :" << endl;
    cout << "Tag: " << tamanho_tag << " bit(s)  "
        << "Conjunto: " << bin_digitos(num_conjunto) << " bit(s)   "
        << "Palavra: " << bin_digitos(num_bloco) << " bit(s)" << endl;


    //calculo da porcentagem de dados uteis
    double percent_dados = ((num_linhas * num_bloco * tamanho_palavra) / (float)(tamanho_cache)) * 100;
    cout << "Porcentagem de dados úteis: " << percent_dados << "%" << endl;


    //separa uma matriz para representar a memoria cache
    bool bit_validade[num_linhas] = {false};

    int **tags = new int *[num_conjunto];
    for(int i = 0; i <num_conjunto; i++) tags[i] = new int[num_linhas/num_conjunto];
    //memset(tags, 0, sizeof(tags[0][0]) * num_conjunto * (num_linhas/num_conjunto));

    int pos_livre[num_conjunto] = {0};

    //para o lfu
    int acessos [num_linhas] = {0};
    //para o randomico
    srand(time(NULL));

    int num_hits = 0;
    int num_misses = 0;
    int total_reqs = 0;

    string nome, file_line;
    cout << "Arquivo teste: ";
    cin >> nome;

    int politica;
    cout << "Política de substituição (0 para randômica, 1 para LFU): ";
    cin >> politica;

    ifstream arquivo (nome.c_str());
    ofstream log;
    log.open("log.txt", ios_base::app);
    log << endl << "Memoria Cache conjunto associativo" << endl;
    log << "Tamanho da cache: " << tamanho_cache << endl;
    log << "Tamanho da palavra: " << tamanho_palavra << endl;
    log << "Número de palavras por bloco: " << num_bloco << endl;
    log << "Número de conjuntos: " << num_conjunto << endl;
    log << "Número de linhas: " << num_linhas << endl;
    log << "Tamanho da tag: " << tamanho_tag << endl;
    string polit = (politica ? "LFU" : "Randomica");
    log << "Política de substituição: " << polit << endl;


    if(arquivo.is_open()){
        while(getline(arquivo, file_line)){
            bool resp = acessa_cache(stoi(file_line), bit_validade, tags, num_bloco, num_conjunto, num_linhas,
                                    tamanho_tag, pos_livre, acessos, politica);

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


}
