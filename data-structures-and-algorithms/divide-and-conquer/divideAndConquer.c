// Ali Mert Temizsoy G3 23011018 MAG
// video linki: https://youtu.be/pt_SbcBRYzU

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// fonksiyon prototipleri
void printArrays(int *keys, int *locks, int size);
void printSubArrays(int *keys, int *locks, int start, int end);
void printLocks(int *locks, int start, int end);
void freeArrays(int *keys, int *locks);
int readDataFromFile(char *filename, int **keys, int **locks);
void swap(int *a, int *b);
int randomKeySelection(int start, int end);
int partitionLocks(int *locks, int start, int end);
int partitionKeys(int *keys, int *locks, int start, int end, int lockIndex);
void quickSort(int *keys, int *locks, int start, int end, int size);

int main() {
    char filename[100];
    int size; // dizi boyutlarını tutan değişken
    int *keys; // anahar dizisi
    int *locks; // kilit dizisi
    
    // rastgele sayı üreteci için seed
    srand(time(NULL));
    
    // kullanıcıdan dosya adının alınması
    printf("Lutfen okumak istediginiz dosyanin adini giriniz: ");
    scanf("%s", filename);
    
    // dosyadan verileri okur ve hata kontrolü yapar
    size = readDataFromFile(filename, &keys, &locks);
    if (size <= 0) {
        printf("Veri okuma isleminde hata olustu!\n");
        return 1;
    }
    
    // işlemler başlamadan okunan veriyi yazdırır
    printf("\n");
    printArrays(keys, locks, size);

    // quick sort algoritmasını başlatır
    quickSort(keys, locks, 0, size - 1, size);

    // işlem sonunda dizileri yazdırır
    printf("Islem Sonu:\n");
    printArrays(keys, locks, size);
    
    // belleği serbest bırakır
    freeArrays(keys, locks);

    return 0;
}

/*
@brief dosyadan veri okuyan ve onları keys,locks dizilerine aktaran fonksiyon

@param filename okunacak dosyanın adı
@param keys okunan anahtar dizisinin adresi
@param locks okunan kilit dizisinin adresi

@return dosyadan okunan dizinin boyutu
*/
int readDataFromFile(char *filename, int **keys, int **locks) {
    FILE *file; // dosya işaretçisi değişkeni
    int size = 0; // dizi boyutunu tutan değişken
    
    // dosyayı read modunda açar ve hata kontrolü yapar
    file = fopen(filename, "r");
    if (file == NULL) {
        printf("Dosya acilamadi!\n");
        return 0;
    }
    
    // dizi boyutunu okur ve hata kontrolü yapar
    fscanf(file, "%d", &size);
    if (size <= 0) {
        printf("Gecersiz dizi boyutu!\n");
        fclose(file);
        return -1;
    }
    
    // diziler için kullanıcıdan alınan değer kadar bellek tahsis eder ve hata kontrolü yapar
    *keys = (int*)malloc(size * sizeof(int));
    *locks = (int*)malloc(size * sizeof(int));
    if (*keys == NULL || *locks == NULL) {
        printf("Bellek tahsis edilemedi!\n");
        if (*keys != NULL) free(*keys);
        if (*locks != NULL) free(*locks);
        fclose(file);
        return -2;
    }
    
    // key dizisi için verileri okur
    for (int i = 0; i < size; i++) {
        fscanf(file, "%d", &((*keys)[i]));
    }
    
    // lcock dizisi için verileri okur
    for (int i = 0; i < size; i++) {
        fscanf(file, "%d", &((*locks)[i]));
    }
    
    // dosyayı kapatır ve okunan dizinin boyutunu döndürür
    fclose(file);
    return size;
}

/*
@brief key ve lock dizilerini ekrana yazdıran fonksiyon

@param keys anahtar dizisi
@param locks kilit dizisi
@param size dizilerin boyutu
*/
void printArrays(int *keys, int *locks, int size) {
    // dizileri ekrana yazdırır
    printf("Keys: ");
    for (int i = 0; i < size; i++) {
        printf("%d", keys[i]);
        if (i < size - 1) {
            printf("/");
        }
    }
    printf("\n");
    
    printf("Locks: ");
    for (int i = 0; i < size; i++) {
        printf("%d", locks[i]);
        if (i < size - 1) {
            printf("/");
        }
    }
    printf("\n\n");
}

/*
@brief key ve lock dizilerinin belirtilen aralığını ekrana yazdıran fonksiyon

@param keys anahtar dizisi
@param locks kilit dizisi
@param start yazdırılacak alt dizinin başlangıç indeksi
@param end yazdırılacak alt dizinin bitiş indeksi
*/
void printSubArrays(int *keys, int *locks, int start, int end) {
    // keys dizisinin belirtilen aralığını ekrana yazdırır
    printf("Keys: ");
    for (int i = start; i <= end; i++) {
        printf("%d", keys[i]);
        if (i < end) {
            printf("/");
        }
    }
    printf("\n");
    
    // locks dizisinin belirtilen aralığını ekrana yazdırır
    printf("Locks: ");
    for (int i = start; i <= end; i++) {
        printf("%d", locks[i]);
        if (i < end) {
            printf("/");
        }
    }
    printf("\n");
}

/*
@brief ilk lock dizimizi sort ettiğimiz için sadece onu ekrana yazmamız gerekiyor. bu fonksiyon belirtilen aralıktaki lock dizisini ekrana yazdırır

@param locks kilit dizisi
@param start yazdırılacak alt dizinin başlangıç indeksi
@param end yazdırılacak alt dizinin bitiş indeksi
*/
void printLocks(int *locks, int start, int end) {
    // locks dizisinin belirtilen aralığını ekrana yazdırır
    printf("Locks: ");
    for (int i = start; i <= end; i++) {
        printf("%d", locks[i]);
        if (i < end) {
            printf("/");
        }
    }
    printf("\n");
}

/*
@brief dinamik belleği serbest bırakan fonksiyon

@param keys anahtar dizisi
@param locks kilit dizisi
*/
void freeArrays(int *keys, int *locks) {
    free(keys);
    free(locks);
}

/*
@brief iki integer değerinin yer değiştiren fonksiyon. bu swap işlemini sort yaparken sıklıkla kullanacağız

@param a birinci değer
@param b ikinci değer
*/
void swap(int *a, int *b) {
    // temp değişkeni kullanılarak iki değerin yeri değiştirilir
    int temp = *a;
    *a = *b;
    *b = temp;
}

/*
@brief verilen aralıkta rastgele bir anahtar seçen fonksiyon. key dizisinde bu seçilen anahtara göre partition işlemi yapılacak

@param start rastgele seçilecek anahtar dizisinin minimum değeri
@param end rastgele seçilecek anahtar dizisinin maksimum değeri
*/
int randomKeySelection(int start, int end) {
    return start + rand() % (end - start + 1);
}

/*
@brief verilen aralıkta lock dizisini partition eden fonksiyon. rastgele key değerini
dizinin son elemanıyla değiştirir ve sort işlemini yapar. bu partition işlemi sonucunda lock dizisindeki pivotun key dizisindeki indexi döndürülür

@param locks kilit dizisi
@param start partition işlemi yapılacak alt dizinin başlangıç indeksi
@param end partition işlemi yapılacak alt dizinin bitiş indeksi
*/
int partitionLocks(int *locks, int start, int end) {

    int pivot = randomKeySelection(start, end); // rastgele bir pivot seçilir

    printf("locks icin secilen pivot: %d\n", locks[pivot]);
    printf("Locklar duzenleniyor..\n");
    swap(&locks[pivot], &locks[end]); // pivotu dizinin son elemanıyla değiştirir. bu sayede işlem kolaylaşır.
    
    int i = start - 1; // i değişkeni pivotun solundaki elemanları tutar
    for (int j = start; j < end; j++) { 
        if (locks[j] < locks[end]) { 
            i++;
            swap(&locks[i], &locks[j]); // pivotun solundaki elemanlar pivotun sağında olanlardan küçükse yer değiştirilir
        }
    }
    
    swap(&locks[i + 1], &locks[end]); // yaptığımız işlemler sonucunda pivotun doğru yeri bulunur ve yer değiştirilir

    printLocks(locks, start, end); // işlem sonunda lock dizisi yazdırılır
    
    return i + 1; // pivotun key dizisindeki indexi döndürülür
}

/*
@brief verilen aralıkta key dizisini partition eden fonksiyon. lock dizisindeki pivotun key dizisindeki
indexi verilir. daha sonra bu eleman sona alınır ve key dizisi sort edilir. bu partition işlemi sonucunda key dizisindeki pivotun indexi döndürülür.

@param keys anahtar dizisi
@param locks kilit dizisi
@param start partition işlemi yapılacak alt dizinin başlangıç indeksi
@param end partition işlemi yapılacak alt dizinin bitiş indeksi
@param lockIndex lock dizisindeki pivotun key dizisindeki indexi
*/

int partitionKeys(int *keys, int *locks, int start, int end, int lockIndex) {
    int j; // döngü değişkeni  
    int i = start - 1; // pivotun solundaki elemanları tutan değişken
    
    printf("keyler lock ->%d ile duzenleniyor..\n", locks[lockIndex]);
    
    for (j = start ; j <= end - 1 ; j++) {
        if(keys[j] < locks[lockIndex]) { // pivotun solundaki elemanlar pivotun sağında olanlardan küçükse yer değiştirilir
            i++;
            swap(&keys[i], &keys[j]); // swap işlemi
        }
        else if (keys[j] == locks[lockIndex]) { // pivotun key dizisindeki indexi pivotun lock dizisindeki indexine eşitse 
            swap(&keys[j], &keys[end]); // pivotun key dizisi sona alınır
            
            if(keys[j] < locks[lockIndex]) { // pivotun solundaki elemanlar pivotun sağında olanlardan küçükse yer değiştirilir
                i++;
                swap(&keys[i], &keys[j]); // swap işlemi
            }
        }    
    }
    swap(&keys[i + 1], &keys[end]); // yaptığımız işlemler sonucunda pivotun doğru yeri bulunur ve yer değiştirilir

    printSubArrays(keys, locks, start, end); // işlem sonunda key ve lock subdizileri yazdırılır
    printf("%d pivotu icin adim sonu..\n\n", locks[lockIndex]);
    
    return i + 1; // pivotun key dizisindeki indexi döndürülür
}   

/*
@brief verilen aralığı quick sort algoritması ile sıralayan fonksiyon

@param keys anahtar dizisi
@param locks kilit dizisi
@param start sıralama yapılacak alt dizinin başlangıç indeksi
@param end sıralama yapılacak alt dizinin bitiş indeksi
@param size dizinin boyutu
*/

void quickSort(int *keys, int *locks, int start, int end, int size) {
    if (start < end) { // dizinin boyutu 1'den büyükse işlem yapılır
        int lockIndex = partitionLocks(locks, start, end); // lock dizisini partition eder ve pivotun key dizisindeki indexini döndürür
        int keyIndex = partitionKeys(keys, locks, start, end, lockIndex); // key dizisini partition eder ve pivotun key dizisindeki indexini döndürür
        
        quickSort(keys, locks, start, keyIndex - 1, size); // sol alt diziyi sıralar
        quickSort(keys, locks, keyIndex + 1, end, size); // sağ alt diziyi sıralar
    }
}

