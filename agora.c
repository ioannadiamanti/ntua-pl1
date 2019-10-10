#include <stdio.h>
#include <inttypes.h>
#include <stdlib.h>

int64_t gcd (int64_t a, int64_t b) {
    if (a == 0) return b;
    return gcd(b%a, a);
}

int64_t ekp (int64_t a, int64_t b) {
    int64_t c;
    if (a>b) {
        c = a/gcd(a,b);
        return c*b;
    }
    else {
        c = b/gcd(a,b);
        return c*a;
    }

}

int main (int argc, char **argv) {
    int64_t N, temp, min, mini;
    int64_t i=0;

    FILE *fd = fopen(argv[1], "r");
    
    fscanf (fd, "%" SCNd64, &N);

    int64_t *xi, *ekp1, *ekp2, *totalekp;
    xi = malloc (sizeof(int64_t)*N);
    ekp1 = malloc (sizeof(int64_t)*N);
    ekp2 = malloc (sizeof(int64_t)*N);
    totalekp = malloc (sizeof(int64_t)*(N+1));
    

    while (fscanf(fd, "%" SCNd64, &temp)>0) {
        xi[i] = temp;
        i++;
    }

    fclose(fd);


    ekp1[0] = xi[0];
    ekp2[N-1] = xi[N-1];
    for (i=1; i<N; i++) {
        ekp1[i] = ekp( ekp1[i-1] , xi[i] );
        ekp2[N-1-i] = ekp( ekp2[N-i] , xi[N-1-i] );
    }

    totalekp[0]=ekp2[0];
    totalekp[1]=ekp2[1];
    totalekp[N]=ekp1[N-1];

    for (i=2;i<N;i++){
        totalekp[i]=ekp(ekp1[i-2],ekp2[i]);
    }
    
    min = totalekp[0];
    mini = 0;
    for (i=1;i<N+1;i++) {
        if (totalekp[i]<min) {
            min = totalekp[i];
            mini = i;
        }
    }

    free (xi);
    free(ekp1);
    free(ekp2);
    free(totalekp);

    printf("%" PRId64 "%c" "%" PRId64 "\n", min, ' ', mini);
    
    return 0;
}
