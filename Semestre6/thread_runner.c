#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <linux/sched.h>
#include <semaphore.h>
#include <string.h>

int size;
volatile int pos = 0;
pthread_mutex_t lock;
char *buffer; 

void *thread_behaviour(void *data)
{
  printf("Iniciando thread %c\n", (char) data);	
  
  while (pos < size){
		pthread_mutex_lock(&lock);
		buffer[pos] = data;
		pos ++;
    pthread_mutex_unlock(&lock);
	}
	return 0;
}

void print_sched(int policy)
{
	int priority_min, priority_max;

	switch(policy){
		case SCHED_DEADLINE:
			printf("SCHED_DEADLINE");
			break;
		case SCHED_FIFO:
			printf("SCHED_FIFO");
			break;
		case SCHED_RR:
			printf("SCHED_RR");
			break;
		case SCHED_NORMAL:
			printf("SCHED_OTHER");
			break;
		case SCHED_BATCH:
			printf("SCHED_BATCH");
			break;
		case SCHED_IDLE:
			printf("SCHED_IDLE");
			break;
		default:
			printf("unknown\n");
	}
	priority_min = sched_get_priority_min(policy);
	priority_max = sched_get_priority_max(policy);
	printf(" PRI_MIN: %d PRI_MAX: %d\n", priority_min, priority_max);
}

int get_sched(char* policy)
{
  

  if(!strcmp(policy, "SCHED_DEADLINE")){
    return SCHED_DEADLINE;
  }
  if(!strcmp(policy, "SCHED_FIFO")){
    return SCHED_FIFO;
  }
  if(!strcmp(policy, "SCHED_RR")){
    return SCHED_RR;
  }
  if(!strcmp(policy, "SCHED_OTHER")){
    return SCHED_OTHER;
  }
  if(!strcmp(policy, "SCHED_BATCH")){
    return SCHED_BATCH;
  }
  if(!strcmp(policy, "SCHED_IDLE")){
    return SCHED_IDLE;
  }

  return 0;
}


int setpriority(pthread_t *thr, int newpolicy, int newpriority)
{
	int policy, ret;
	struct sched_param param;

	if (newpriority > sched_get_priority_max(newpolicy) || newpriority < sched_get_priority_min(newpolicy)){
		printf("Invalid priority: MIN: %d, MAX: %d", sched_get_priority_min(newpolicy), sched_get_priority_max(newpolicy));

		return -1;
	}

	pthread_getschedparam(*thr, &policy, &param);
	printf("current: ");
	print_sched(policy);

	param.sched_priority = newpriority;
	ret = pthread_setschedparam(*thr, newpolicy, &param);
	if (ret != 0)
		perror("perror(): ");

	pthread_getschedparam(*thr, &policy, &param);
	printf("new: ");
	print_sched(policy);


	return 0;
}


int main(int argc, char **argv){

  int num_threads = atoi(argv[1]);
  size = 1024 *atoi(argv[2]);
  char *politica = argv[3];
  int prioridade = atoi(argv[4]);

  buffer = (char*) malloc(size * sizeof(char));


	// intialize mutex lock
	if (pthread_mutex_init(&lock, NULL) != 0) return 1;

	pthread_t thr[num_threads];
	char initial_char= 'A';
  
  pthread_t self = pthread_self();
  setpriority(&self, SCHED_FIFO, 99);
  
	for(int i = 0; i < num_threads; i++){
			char current = initial_char + i;
			pthread_create(&thr[i], NULL, thread_behaviour, current);
			setpriority(&thr[i], get_sched(politica), prioridade);
	}

  setpriority(&self, SCHED_FIFO, 1);
  
  for(int i = 0; i < num_threads; i++){
    pthread_join(thr[i], NULL);
  }
  
  int* vetor = calloc(num_threads, num_threads*sizeof(int));
  vetor[buffer[0] - 'A'] = 1;
  char old = buffer[0];
  printf("%c", old);

  for(int i = 1; i < size; i++){
    char val = buffer[i];
    if(val != old) {
      printf("%c", val);
      vetor[val -'A']++;
      old = val;
    }
  }
  
  printf("\n");
  for(int i= 0; i < num_threads; i ++){
    printf("%c : %d\n", (char) ('A' + i), vetor[i]);
  }
  
  printf("\n");
	// destroy variables
    	pthread_mutex_destroy(&lock);

}
