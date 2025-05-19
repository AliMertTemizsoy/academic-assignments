// Ali Mert Temizsoy G3 23011018 MAG
// Video linki: https://youtu.be/QjeFEYnkfTU

// Kullandığımız kütüphaneler
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>

// Kullandığımız struct'lar

// Şarkı yapısı
typedef struct SONG {
    char* name; // Şarkı adı
    float duration; // Şarkı süresi (saniye cinsinden)
} SONG;

// Çalma listesi düğümü yapısı
typedef struct PLAYLIST_NODE {
    SONG* song;  // Şarkıya işaretçi
    struct PLAYLIST_NODE* next;  // Sonraki düğüm
    struct PLAYLIST_NODE* prev;  // Önceki düğüm
} PLAYLIST_NODE;

// Kullanıcı yapısı
typedef struct USER {
    char* username;  // Kullanıcı adı
    PLAYLIST_NODE* playlistHead;  // Çalma listesinin başı 
    int playlistSize;  // Çalma listesinin boyutu
} USER;

// En iyi şarkılar düğümü yapısı
typedef struct TOP_SONGS{
    struct SONG* song;  // Şarkıya işaretçi
    struct TOP_SONGS* next;  // Sonraki düğüm
    int totalCount;  // Şarkının dinlenme sayısı
    float totalDuration;  // Şarkının toplam dinlenme süresi
} TOP_SONGS;

// Fonksiyon prototipleri
struct SONG* createSong(char* name, float duration);  
struct PLAYLIST_NODE* createPlaylistNode(struct SONG* song);  
struct PLAYLIST_NODE* addSongToPlaylist(struct PLAYLIST_NODE* head, struct SONG* song);  
struct TOP_SONGS* createTopSongsNode(struct SONG* song);  
struct TOP_SONGS* addTopSong(struct TOP_SONGS* head, struct SONG* song);  
struct SONG* createAllSongs(int N);  
struct USER* createUsers(int k);  
void printSongs(struct SONG* songs, int N);  
int isSongInPlaylist(struct PLAYLIST_NODE* head, struct SONG* song);  
void generatePlaylist(struct USER* users, struct SONG* songs, int N, int k);  
void printPlaylist(struct USER* users, int k);  
void simulateListenings(struct USER* users, int k, struct TOP_SONGS** topSongsList);  
int generateRandomJump(int range);  
void sortTopSongs(struct TOP_SONGS** head);  
void printTop10Songs(struct TOP_SONGS* head);  
void freeSongs(struct SONG* songs, int N);  
void freePlaylist(struct PLAYLIST_NODE* head);  
void freeTopSongs(struct TOP_SONGS* head);  
void freeUsers(struct USER* users, int k);  
void freeAll(struct SONG* songs, int N, struct USER* users, int k, struct TOP_SONGS* topSongsList);  

int main(){   
    srand(time(NULL));  // Rastgele sayı üreteci için seed
    int N;  // Şarkı sayısı
    int K;  // Kullanıcı sayısı

    printf("Enter the number of total songs: ");  // Şarkı sayısını kullanıcıdan alma
    scanf("%d", &N);  // Kullanıcıdan şarkı sayısını alma

    printf("Enter the number of total users: ");  // Kullanıcı sayısını kullanıcıdan alma
    scanf("%d", &K);  // Kullanıcıdan kullanıcı sayısını alma

    struct SONG* songs = createAllSongs(N);  // Bütün şarkıları oluşturma
    if (songs == NULL) {
        return 1;  // Bellek tahsisi başarısızsa çıkma
    }
    printSongs(songs, N);  // Bütün şarkıları yazdırma

    struct USER* users = createUsers(K);  // Kullanıcıları oluşturma
    if (users == NULL) {
        free(songs);  // Bellek tahsisi başarısızsa önceden tahsis edilen belleği serbest bırakma
        return 1;  
    }

    struct TOP_SONGS* topSongsList = NULL;  // En iyi şarkılar listesi başlangıcı

    generatePlaylist(users, songs, N, K);  // Çalma listelerini oluşturma

    printPlaylist(users, K);  // Oluşturduğumuz çalma listelerini yazdırma

    simulateListenings(users, K, &topSongsList);  // Dinleme simülasyonunu gerçekleştirme

    sortTopSongs(&topSongsList);  // En iyi şarkıları sıralama
    printTop10Songs(topSongsList);  // En iyi 10 şarkıyı yazdırma

    freeAll(songs, N, users, K, topSongsList);  // Tüm belleği serbest bırakma

    return 0;
}

/*
@brief Girişte verilen şarkı adı ve süresine göre bellek tahsis eder ve yeni bir şarkı oluşturur.

@param name Şarkı adı
@param duration Şarkı süresi (saniye cinsinden)

@return Oluşturulan şarkı yapısına işaretçi döndürür.
*/

struct SONG* createSong(char* name, float duration) {
    struct SONG* newSong = (struct SONG*)malloc(sizeof(struct SONG)); // Yeni şarkı için bellek tahsisi
    if (newSong == NULL) {
        printf("Memory allocation failed\n"); // Bellek tahsisi başarısızsa hata mesajı
        return NULL; // Bellek tahsisi başarısızsa NULL döndürme 
    }
    newSong->name = (char*)malloc(strlen(name) + 1);  // Şarkı adı için bellek tahsisi
    if (newSong->name == NULL) {
        printf("Memory allocation failed\n"); // Bellek tahsisi başarısızsa hata mesajı
        free(newSong);  // Önceden tahsis edilen belleği serbest bırakma
        return NULL;  // Bellek tahsisi başarısızsa NULL döndürme
    }
    strcpy(newSong->name, name);  // Şarkı adını name değişkenine kopyalama
    newSong->duration = duration;  // Şarkı süresini atama
    return newSong; // Oluşturulan şarkı yapısına işaretçi döndürme
}
/*
@brief Oluşturulan şarkıları yazdırır.

@param songs Şarkı dizisi
@param N Şarkı sayısı
*/

void printSongs(struct SONG* songs, int N) {
    int i; // for döngüsü için değişken
    printf("\nSongs:\n");
    for (i = 0; i < N; i++) {
        // Süreyi dakika ve saniye olarak hesaplama
        int minutes = (int)(songs[i].duration / 60);
        int seconds = (int)(songs[i].duration) % 60;
        
        printf("%d. Song Name: %s, Duration: %d:%02d\n", 
               i+1, songs[i].name, minutes, seconds); // Şarkı adı ve süresini yazdırma
    }
    printf("\n");
}

/*
@brief Yeni bir çalma listesi düğümü oluşturur.

@param song Şarkı yapısına işaretçi

@return Oluşturulan çalma listesi düğümüne işaretçi döndürür.
*/
struct PLAYLIST_NODE* createPlaylistNode(struct SONG* song) {
    struct PLAYLIST_NODE* newNode = (struct PLAYLIST_NODE*)malloc(sizeof(struct PLAYLIST_NODE)); // Yeni düğüm için bellek tahsisi
    if (newNode == NULL) {
        printf("Memory allocation failed\n"); // Bellek tahsisi başarısızsa hata mesajı
        return NULL;  // Bellek tahsisi başarısızsa NULL döndürme
    }
    newNode->song = song;  // Şarkıyı ata
    newNode->next = NULL;  // Sonraki düğümü NULL olarak ayarla
    newNode->prev = NULL;  // Önceki düğümü NULL olarak ayarla
    return newNode; // Oluşturulan düğüme işaretçi döndürme
}

/*
@brief Yeni bir şarkıyı çalma listesine ekler.

@param head Çalma listesinin başı
@param song Şarkı yapısına işaretçi

@return Güncellenmiş çalma listesi başına işaretçi döndürür.
*/

PLAYLIST_NODE* addSongToPlaylist(PLAYLIST_NODE* head, SONG* song) {
    PLAYLIST_NODE* newNode = createPlaylistNode(song); // Yeni düğüm oluşturma
    if (newNode == NULL) {
        return head; // Bellek tahsisi başarısızsa başı döndürme
    }
    if (head == NULL) { // Liste boşsa, yeni düğüm baş olur
        newNode->next = newNode;  // Yeni düğüm kendisine işaret eder (dairesel liste)
        newNode->prev = newNode; // Kendisine işaret eder (dairesel liste)
        return newNode;
    }
    PLAYLIST_NODE* tail = head->prev;  // Dairesel listede son düğüm

    newNode->next = head;  // Yeni düğüm başa bağlanır
    newNode->prev = tail;  // Yeni düğüm son düğüme bağlanır
    tail->next = newNode;  // Son düğüm yeni düğüme bağlanır
    head->prev = newNode;  // Baş yeni düğüme bağlanır
    return head; // Güncellenmiş başı döndürme
}

/*
@brief Yeni bir en iyi şarkılar düğümü oluşturur.

@param song Şarkı yapısına işaretçi

@return Oluşturulan en iyi şarkılar düğümüne işaretçi döndürür.
*/
struct TOP_SONGS* createTopSongsNode(struct SONG* song) {
    struct TOP_SONGS* newNode = (struct TOP_SONGS*)malloc(sizeof(struct TOP_SONGS)); // Yeni düğüm için bellek tahsisi
    if (newNode == NULL) {
        printf("Memory allocation failed\n"); // Bellek tahsisi başarısızsa hata mesajı
        return NULL;  // Bellek tahsisi başarısızsa NULL döndürme
    }
    newNode->song = song;  // Şarkıyı atama
    newNode->next = NULL;  // Sonraki düğümü NULL olarak ayarlama
    newNode->totalCount = 0;  // Dinlenme sayısını sıfırlama
    newNode->totalDuration = 0.0;  // Süreyi sıfırlama
    return newNode; // Oluşturulan düğüme işaretçi döndürme
}

/*
@brief Yeni bir şarkıyı en iyi şarkılar listesine ekler.

@param head En iyi şarkılar listesinin başı
@param song Şarkı yapısına işaretçi

@return Güncellenmiş en iyi şarkılar listesi başına işaretçi döndürür.
*/
struct TOP_SONGS* addTopSong(struct TOP_SONGS* head, struct SONG* song) {
    // Şarkı zaten listede mi kontrol etme
    struct TOP_SONGS* current = head; // Mevcut düğümü baş olarak ayarlama
    while (current != NULL) { // Mevcut düğüm NULL değilse devam etme
        if (strcmp(current->song->name, song->name) == 0) { // Şarkı adı eşleşiyorsa
            current->totalCount++; // Dinlenme sayısını arttırma
            current->totalDuration += song->duration; // Süreyi arttırma
            return head; // Güncellenmiş başı döndürme
        }
        current = current->next; // Sonraki düğüme geçme
    }
    
    // Şarkı listede yoksa yeni düğüm oluştur
    struct TOP_SONGS* newNode = createTopSongsNode(song); // Yeni düğüm oluşturma
    if (newNode == NULL) { // Bellek tahsisi başarısızsa hata mesajı
        return head; // Bellek tahsisi başarısızsa başı döndürme
    }
    newNode->totalCount = 1; // Dinlenme sayısını 1 olarak ayarlama
    newNode->totalDuration = song->duration; // Süreyi ayarlama
    
    // Listeye ekle (başa ekleme)
    newNode->next = head; // Yeni düğüm başa bağlanır
    return newNode; // Güncellenmiş başı döndürme
}

/*
@brief Tüm şarkıları oluşturur ve onlara bellek tahsisi yapar.

@param N Şarkı sayısı

@return Oluşturulan şarkı dizisine işaretçi döndürür.
*/

struct SONG* createAllSongs(int N){
    if (N <= 0) {
        printf("Error: Cannot create songs with N <= 0.\n"); // Şarkı sayısı 0 veya daha küçükse hata mesajı
        return NULL;
    }
    struct SONG* songs = (struct SONG*)malloc(N * sizeof(struct SONG)); // Şarkı dizisi için bellek tahsisi
    if (songs == NULL) {
        printf("Memory allocation failed\n"); // Bellek tahsisi başarısızsa hata mesajı
        return NULL;  // Bellek tahsisi başarısızsa NULL döndür
    }
    int i; // for döngüsü için değişken
    for(i=0; i<N; i++){
        songs[i].name = (char*)malloc(20 * sizeof(char));  // Şarkı adı için bellek tahsis et
        if (songs[i].name == NULL) {
            printf("Memory allocation failed\n"); // Bellek tahsisi başarısızsa hata mesajı
            free(songs);  // Bellek tahsisi başarısızsa önceden tahsis edilen belleği serbest bırak
            return NULL;  // NULL döndür
        }
        sprintf(songs[i].name, "S%d", i+1); // Şarkı adını oluştur
        songs[i].duration = (float)(rand() % 270 + 90);  // 90 ile 360 saniye arasında rastgele süre
    }
    return songs; // Oluşturulan şarkı dizisine işaretçi döndür
}

/*
@brief Kullanıcıları oluşturur ve onlara bellek tahsisi yapar.

@param k Kullanıcı sayısı

@return Oluşturulan kullanıcı dizisine işaretçi döndürür.
*/
struct USER* createUsers(int K){
    struct USER* users = (struct USER*)malloc(K * sizeof(struct USER)); // Kullanıcı dizisi için bellek tahsisi
    if (users == NULL) {
        printf("Memory allocation failed\n"); // Bellek tahsisi başarısızsa hata mesajı
        return NULL;  // Bellek tahsisi başarısızsa NULL döndürme
    }
    int i; // for döngüsü için değişken
    for(i=0; i<K; i++){
        users[i].username = (char*)malloc(20 * sizeof(char));  // Kullanıcı adı için bellek tahsis etme
        if (users[i].username == NULL) {
            printf("Memory allocation failed\n"); // Bellek tahsisi başarısızsa hata mesajı
            free(users);  // Bellek tahsisi başarısızsa önceden tahsis edilen belleği serbest bırak
            return NULL;  // NULL döndür
        }
        sprintf(users[i].username, "User%d", i+1); // Kullanıcı adını oluşturma
        users[i].playlistHead = NULL;  // Çalma listesini başlangıçta boş olarak ayarlama
        users[i].playlistSize = 0; // Çalma listesi boyutunu sıfırlama
    }
    return users; // Oluşturulan kullanıcı dizisine işaretçi döndürme
}

/*
@brief Şarkının çalma listesinde olup olmadığını kontrol eder.

@param head Çalma listesinin başı
@param song Şarkı yapısına işaretçi

@return 1: Şarkı listede varsa, 0: Şarkı listede yoksa döndürür.
*/
int isSongInPlaylist(struct PLAYLIST_NODE* head, struct SONG* song) {
    if (head == NULL) return 0;  // Liste boşsa, şarkı listede yok
    
    struct PLAYLIST_NODE* current = head; // Mevcut düğümü baş olarak ayarlama
    do {
        if (current->song == song) { // Şarkı mevcut düğümde varsa
            return 1;  // Şarkı listede var
        }
        current = current->next; // Sonraki düğüme geçme
    } while (current != head);  // Dairesel liste olduğu için başa dönene kadar kontrol et
    
    return 0;  // Şarkı listede yok
}

/*
@brief Rastgele çalma listesi oluşturur.

@param users Kullanıcı dizisi
@param songs Şarkı dizisi
@param N Şarkı sayısı
@param k Kullanıcı sayısı
*/
void generatePlaylist(struct USER* users, struct SONG* songs, int N, int K) {
    int i, j; // Döngü için değişkenler
    if (N == 0) {
        printf("No songs available to create playlists.\n"); // Şarkı yoksa mesaj yazdırma
        return;
    }
    for (i = 0; i < K; i++) {
        int maxTries = N * 2;  // Sonsuz döngüye girmemek için maksimum deneme sayısı
        int numSongs = (N == 1) ? 1 : rand() % (N/2) + 1; // Rastgele şarkı sayısı (M<<N olacak şekilde)

        users[i].playlistSize = 0;  // Çalma listesi boyutunu sıfırlama
        users[i].playlistHead = NULL;  // Çalma listesini başlangıçta boş olarak ayarlama
        
        j = 0; // Başlangıçta eklenen şarkı sayısı
        int tries = 0; // Deneme sayısını sıfırlama
        
        while (j < numSongs && tries < maxTries) {
            int songIndex = rand() % N;  // Rastgele şarkı indeksi
            
            // Şarkı zaten listede var mı kontrol etme
            if (!isSongInPlaylist(users[i].playlistHead, &songs[songIndex])) {
                users[i].playlistHead = addSongToPlaylist(users[i].playlistHead, &songs[songIndex]); // Şarkıyı çalma listesine ekleme
                users[i].playlistSize++;  // Çalma listesi boyutunu arttırma
                j++;  // Başarılı bir ekleme olduğu için sonraki şarkıya geçme
            }
            
            tries++;  // Deneme sayısını artır
        }
    }
}
/*
@brief Kullanıcıların çalma listelerini yazdırır.

@param users Kullanıcı dizisi
@param k Kullanıcı sayısı
*/

void printPlaylist(struct USER* users, int K) {
    int i; // for döngüsü için değişken
    for (i = 0; i < K; i++) {
        printf("Playlist for %s:\n", users[i].username); 
        struct PLAYLIST_NODE* current = users[i].playlistHead; // Mevcut düğümü baş olarak ayarlama
        if (current == NULL) {
            printf("No songs in this playlist.\n"); // Çalma listesi boşsa mesaj yazdırma
        } else {
            int songNumber = 1; // Şarkı numarasını başlatma
            do {
                // Süreyi dakika ve saniye olarak hesaplama
                int minutes = (int)(current->song->duration / 60);
                int seconds = (int)(current->song->duration) % 60;
                
                printf("%d. Song Name: %s, Duration: %d:%02d\n", 
                       songNumber, current->song->name, minutes, seconds); // Şarkı adı ve süresini yazdırma
                
                current = current->next; // Sonraki düğüme geçme
                songNumber++; // Şarkı numarasını arttırma
            } while (current != users[i].playlistHead);  // Dairesel liste olduğu için başa dönene kadar yazdırma
        }
        printf("\n");
    }    
}

/*
@brief Rastgele atlama değerini oluşturur.

@param range Atlama aralığı

@return Rastgele atlama değeri döndürür.
*/
int generateRandomJump(int range) {
    // Listenin küçük olduğu durumları kontrol etme
    if (range <= 1) {
        return 0; // Tek elemanlı liste için her zaman 0 dön
    }
    
    // 1 ile range/2 arasında (veya en az 1) bir sayı üretme
    int maxJump = (range/2 > 0) ? range/2 : 1; // Maksimum atlama değeri
    int jump = rand() % maxJump + 1; // 1 ile maxJump arasında rastgele bir sayı üretme
    
    // %50 ihtimalle negatif yapma
    if (rand() % 2 == 0) {
        jump = -jump;
    }
    
    return jump; // Rastgele atlama değerini döndürme
}
/*
@brief Kullanıcıların dinleme simülasyonunu üretilen rastgele sıçramalara göre gerçekleştirir ve en iyi şarkılar listesini günceller.

@param users Kullanıcı dizisi
@param k Kullanıcı sayısı
@param topSongsList En iyi şarkılar listesi başına işaretçi
*/
void simulateListenings(struct USER* users, int K, struct TOP_SONGS** topSongsList){
    int i, j; // for döngüsü için değişkenler
    printf("\nSimulating listenings...\n");
    for(i=0; i<K; i++){ // Her kullanıcı için dinleme simülasyonu
        if (users[i].playlistSize == 0){
            printf("User %d has an empty playlist. Skipping...\n", i+1); // Çalma listesi boşsa atlama
        } else {
            int randJumpsCount = rand() % users[i].playlistSize + 1;  // Rastgele atlama sayısı
            int *randJumps = malloc(randJumpsCount * sizeof(int));  // Rastgele atlama dizisi için bellek tahsis etme
            if (randJumps == NULL) { 
                printf("Memory allocation failed\n"); // Bellek tahsisi başarısızsa hata mesajı
                return;  // Bellek tahsisi başarısızsa çık
            }
            
            for(j=0; j<randJumpsCount; j++){ // Atlama sayısı kadar döngü
                randJumps[j] = generateRandomJump(users[i].playlistSize);  // Rastgele atlama değerlerini oluşturma
            }
            
            int randStart = rand() % users[i].playlistSize;  // Rastgele başlangıç indeksi
            struct PLAYLIST_NODE* current = users[i].playlistHead; // Mevcut düğümü baş olarak ayarlama
            for(j=0; j<randStart; j++){
                current = current->next;  // Başlangıç noktasına gitme
            }
            
            // Dinleme işlemini simüle etme başlangıcı
            printf("User %d started listening... Started song: %s\n", i+1, current->song->name);
            
            // İlk şarkıyı dinletme ve top10'a ekleme

            // Süreyi dakika ve saniye olarak hesaplama
            int minutes = (int)(current->song->duration / 60);
            int seconds = (int)(current->song->duration) % 60;
            printf("1. %s (%d:%02d)\n", current->song->name, minutes, seconds); // 1. şarkı için adı ve süresini yazdırma
            *topSongsList = addTopSong(*topSongsList, current->song); // En iyi şarkılar listesine ekleme
            
            // Rastgele atlama değerlerine göre diğer şarkıları dinleme
            for(j=0; j<randJumpsCount; j++){
                int jump = randJumps[j]; // Rastgele atlama değeri
                
                // Atlama değerine göre bir sonraki şarkıya gitme
                if (jump > 0) { // Pozitif atlamada
                    jump = (jump > users[i].playlistSize) ? users[i].playlistSize : jump; // Atlama değeri çalma listesi boyutunu geçmemeli

                    int i; // for döngüsü için değişken
                    for (i = 0; i < jump; i++) {
                        current = current->next; // Sonraki şarkıya geçme
                    }
                } else if (jump < 0) { // Negatif atlamada
                    jump = (-jump > users[i].playlistSize) ? -users[i].playlistSize : jump; // Atlama değeri çalma listesi boyutunu geçmemeli

                    int i; // for döngüsü için değişken
                    for (i = 0; i < -jump; i++) {
                        current = current->prev; // Önceki şarkıya geçme
                    }
                }
                
                // Şarkıyı dinletme ve top10'a ekletme

                // Süreyi dakika ve saniye olarak hesaplama
                minutes = (int)(current->song->duration / 60);
                seconds = (int)(current->song->duration) % 60;
                printf("%d. %s (%d:%02d) [Jump: %d]\n", j+2, current->song->name, minutes, seconds, jump); // Şarkı adı ve süresini yazdırma
                *topSongsList = addTopSong(*topSongsList, current->song); // En iyi şarkılar listesine ekleme
            }
            
            printf("\n");
            free(randJumps);  // Belleği serbest bırakma
        }
    }
}
/*
@brief En iyi şarkılar listesini insertion sort algoritması ile sıralar.

@param head En iyi şarkılar listesi başı
*/

void sortTopSongs(struct TOP_SONGS** head){
    struct TOP_SONGS* current = *head; // Mevcut düğümü baş olarak ayarlama
    struct TOP_SONGS* nextNode = NULL; // Sonraki düğümü saklama ve NULL ile başlatma
    struct TOP_SONGS* sortedListHead = NULL;  // Sıralı liste başlangıcı
    
    while (current != NULL) { // Mevcut düğüm NULL değilse devam etme
        nextNode = current->next;  // Sonraki düğümü saklama
        
        if (sortedListHead == NULL || current->totalCount > sortedListHead->totalCount) { // Sıralı liste boşsa veya yeni düğüm baştan büyükse
            current->next = sortedListHead;  // Yeni baş düğüm
            sortedListHead = current; // Baş düğümü güncelleme
        } else if(current->totalCount == sortedListHead->totalCount) { // Dinlenme sayıları eşitse
            if(current->totalDuration > sortedListHead->totalDuration) { // Süreyi karşılaştırma
                current->next = sortedListHead;  // Yeni baş düğüm
                sortedListHead = current; // Baş düğümü güncelleme
            } else { 
                current->next = sortedListHead->next;  // Yeni düğüm başa eklenmezse, sıradaki düğüme bağla
                sortedListHead->next = current; // Baş düğümün sonraki düğümüne bağla
            }
        } else { // Yeni düğüm baştan küçükse
            struct TOP_SONGS* temp = sortedListHead; // Mevcut düğümü baş olarak ayarlama
            // Dinlenme sayısını ve süreyi karşılaştırma
            // Eğer yeni düğüm baştan küçükse, sıradaki düğüme geç
            // Dinlenme sayısı büyükse veya eşitse ve süre büyükse
            // Dinlenme sayısı eşitse ve süre büyükse
            while (temp->next != NULL && 
                (temp->next->totalCount > current->totalCount || 
                 (temp->next->totalCount == current->totalCount && 
                  temp->next->totalDuration > current->totalDuration))) {
              temp = temp->next; // Bir sonraki düğüme geçme
          }
            current->next = temp->next;  // Yeni düğümü ekleme
            temp->next = current; // Önceki düğümün sonraki düğümüne bağla
        }
        
        current = nextNode;  // Sonraki düğüme geçme
    }
    
    *head = sortedListHead;  // Sıralı listeyi başa atama
}

/*
@brief En iyi 10 şarkıyı yazdırır.

@param head En iyi şarkılar listesi başı
*/
void printTop10Songs(struct TOP_SONGS* head) {
    struct TOP_SONGS* current = head; // Mevcut düğümü baş olarak ayarlama
    int count = 0; // Yazdırılan şarkı sayısı
    
    printf("Top 10 Songs:\n");
    
    // Var olan şarkıları yazdırma
    while (current != NULL && count < 10) { // Mevcut düğüm NULL değilse ve 10'dan az şarkı yazdırılmadıysa
        // Süreyi dakika ve saniye olarak hesaplama
        int minutes = (int)(current->totalDuration / 60);
        int seconds = (int)(current->totalDuration) % 60;

        printf("%d. Song Name: %s, Listen Count: %d, Total Duration: %d:%02d\n", 
               count + 1, current->song->name, current->totalCount, minutes, seconds); // Şarkı adı, dinlenme sayısı ve toplam süresini yazdırma
        
        current = current->next; // Sonraki düğüme geçme
        count++; // Yazdırılan şarkı sayısını arttırma
    }
    
    // Eğer 10'dan az şarkı varsa, kalan yerleri doldurma
    while (count < 10) { // 10'dan az şarkı varsa
        printf("%d. Song Not Found\n", count + 1); // Şarkı bulunamadı mesajı yazdırma
        count++; // Yazdırılan şarkı sayısını arttırma
    }
}

// Bellek tahsisi yaptığımız alanları serbest bırakma fonksiyonları

/*
@brief Şarkı dizisini serbest bırakır.

@param songs Şarkı dizisi
@param N Şarkı sayısı
*/
void freeSongs(struct SONG* songs, int N) {
    int i; // for döngüsü için değişken
    for (i = 0; i < N; i++) {
        free(songs[i].name);  // Şarkı adını serbest bırakma
    }
    free(songs);  // Şarkılar dizisini serbest bırakma
}

/*
@brief Çalma listesini serbest bırakır.

@param head Çalma listesinin başı
*/
void freePlaylist(struct PLAYLIST_NODE* head) {
    if (head == NULL) return; // Liste boşsa çıkma
    struct PLAYLIST_NODE* current = head; // Mevcut düğümü baş olarak ayarlama
    struct PLAYLIST_NODE* nextNode; // Sonraki düğümü sakla
    do {
        nextNode = current->next; // Sonraki düğümü saklama
        free(current); // Çalma listesi düğümünü serbest bırakma
        current = nextNode; // Sonraki düğüme geçme
    } while (current != head); // Dairesel liste olduğu için başa dönene kadar döngü devam eder
}

/*
@brief En iyi şarkılar listesini serbest bırakır.

@param head En iyi şarkılar listesinin başı
*/
void freeTopSongs(struct TOP_SONGS* head) {
    struct TOP_SONGS* current = head; // Mevcut düğümü baş olarak ayarlama
    struct TOP_SONGS* nextNode; // Sonraki düğümü saklamak için değişken
    
    while (current != NULL) { // Mevcut düğüm NULL değilse
        nextNode = current->next; // Sonraki düğümü saklama
        free(current); // En iyi şarkılar düğümünü serbest bırakma
        current = nextNode; // Sonraki düğüme geçme
    }
}

/*
@brief Kullanıcı dizisini ve çalma listelerini serbest bırakır.

@param users Kullanıcı dizisi
@param k Kullanıcı sayısı
*/
void freeUsers(struct USER* users, int K) {
    int i; // for döngüsü için değişken
    for (i = 0; i < K; i++) {
        free(users[i].username);  // Kullanıcı adını serbest bırakma
        freePlaylist(users[i].playlistHead);  // Çalma listesini serbest bırakma
    }
    free(users);  // Kullanıcı dizisini serbest bırakma
}

/*
@brief Tüm bellek tahsis fonksiyonlarını çağırarak belleği serbest bırakır.

@param songs Şarkı dizisi
@param N Şarkı sayısı
@param users Kullanıcı dizisi
@param k Kullanıcı sayısı
@param topSongsList En iyi şarkılar listesi başı
*/
void freeAll(struct SONG* songs, int N, struct USER* users, int K, struct TOP_SONGS* topSongsHead) {
    freeSongs(songs, N);  // Şarkıları serbest bırakma
    freeUsers(users, K);  // Kullanıcıları serbest bırakma
    freeTopSongs(topSongsHead);  // En iyi şarkıları serbest bırakma
}




