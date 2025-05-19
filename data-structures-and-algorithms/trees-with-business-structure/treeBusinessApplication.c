// Ali Mert Temizsoy G3 23011018 MAG
// // Video linki: https://youtu.be/-yV9rUf80A0

// Kullandığımız kütüphaneler
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Ağaç veri yapısı için kullanılan struct
// Bu struct, çalışanların bilgilerini tutar ve ağaç yapısını oluşturur.
// Her çalışanın adı, yaşı, maaşı, çocuk sayısı ve ebeveyn bilgileri bulunur.
// Ayrıca, çalışanın çocuklarını tutmak için bir diziye işaretçi içerir.
// Bu struct, ağaç yapısının düğümlerini temsil eder.
typedef struct Employee{
    char *name; // Çalışanın adı
    int age; // Çalışanın yaşı
    float salary; // Çalışanın maaşı
    int childCount; // Çalışanın çocuk sayısı
    struct Employee *parent; // Çalışanın ebeveyni
    struct Employee **childrens; // Çalışanın çocuklarını tutan dizi
}Employee;

// Fonksiyon prototipleri
int readEmployeeInfo(struct Employee **employeeTemp, char** managerNames, const char* filename);
struct Employee* createEmployee(char *name, int age, float salary);
void addChild(struct Employee *parent, struct Employee *child);
struct Employee* createTree(struct Employee **employeeTemp, char** managerNames, int N); 
int calculateTreeHeight(struct Employee *ceo);
int employeeCountAtLevel(struct Employee *ceo, int level);
struct Employee* empWithMostChildrenByLevel(struct Employee *ceo, int level);
int calculateTotalAge(struct Employee *ceo, int *employeeCount);
float calculateTotalSalary(struct Employee *ceo);
void freeTree(struct Employee *ceo);
void freeEmployeeInfo(struct Employee **employeeTemp); 
void freeManagerNames(char **managerNames, int N);
void freeAll(struct Employee *ceo, struct Employee **employeeTemp, char **managerNames, int N); 

int main(){
    int N; // Çalışan sayısını tutan değişken
    const char* filename = "personel.txt"; // Okunacak dosyanın adı
    
    // Dosyanın ilk satırı okunur (çalışan sayısını almak için)
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        printf("Dosya acilamadi: %s\n", filename); // Dosya açılamadıysa hata mesajı yazdırır
        return 1;
    }
    
    fscanf(file, "%d", &N); // İlk satırdan çalışan sayısını okur
    fclose(file); // Dosyayı kapatır
    
    printf("Calisan sayisi: %d\n", N);

    // Çalışan bilgilerini tutacak dizileri tanımlar
    struct Employee **employeeTemp = (struct Employee**)malloc(sizeof(struct Employee*) * N);
    char **managerNames = (char**)malloc(sizeof(char*) * N);

    // Dosyadan tüm çalışan bilgilerini okur ve dizilere atar
    readEmployeeInfo(employeeTemp, managerNames, filename);
    
    // Çalışanları ağaç yapısına dönüştürür
    struct Employee* ceo = createTree(employeeTemp, managerNames, N);

    if(ceo != NULL){ // Eğer CEO bulunursa
        int height = calculateTreeHeight(ceo); // Ağaç yüksekliğini hesaplar
        printf("- Ilgili sirketin personel agaci %d seviyeden olusmaktadir.\n", height);

        printf("- ");
        int i;
        for(i = 1; i <= height; i++){
            int count = employeeCountAtLevel(ceo, i); // Her seviyedeki çalışan sayısını hesaplar
            printf("Seviye %d: %d", i, count);
            if (i < height) printf(", "); // Son seviyeden önce virgül ekler
        }

        printf("\n");

        int j;
        for(j = 1; j <= height; j++){
            // Her seviyedeki en fazla çocuğa sahip çalışanı bulur
            struct Employee *mostChildren = empWithMostChildrenByLevel(ceo, j); 
            if(mostChildren != NULL){ // Eğer en fazla çocuğa sahip çalışan bulunursa
                printf("- i=%d ise %d. seviyede en fazla calisana sahip olan kisi %d kisi ile %s'dir.\n", j, j, mostChildren->childCount, mostChildren->name);
            }
        }

        int employeeCount = 0; // Toplam çalışan sayısını tutan değişken
        float totalAge = calculateTotalAge(ceo, &employeeCount); // Toplam yaş hesaplanır

        // Fonksiyon recursive olarak çağrıldığı için yaş ortalamasını hesaplamak için toplam yaş ve çalışan sayısı kullanılır
        printf("- Tum calisanlarin yas ortalamasi: %.2f\n", totalAge / employeeCount);

        float totalSalary = calculateTotalSalary(ceo); // Toplam maaşı hesaplar
        printf("- Sirketin odedigi aylik personel maasi: %.2f\n", totalSalary);
    }
    else{ // Eğer CEO bulunamazsa
        printf("CEO bulunamadi.\n");
    }

    // Belleği serbest bırakma işlemleri
    freeAll(ceo, employeeTemp, managerNames, N);

    return 0;
}

/*
@brief dosyadan çalışan bilgilerini okuyan ve bunları geçici dizilere atayan fonksiyon

@param employeeTemp çalışan bilgilerini tutacak geçici dizi
@param managerNames yöneticilerin isimlerini tutacak geçici dizi
@param filename okunacak dosya adı

@return başarı durumunda çalışan sayısını, başarısızlık durumunda -1 döndürür
*/
int readEmployeeInfo(struct Employee **employeeTemp, char** managerNames, const char* filename){
    FILE *file = fopen(filename, "r"); // Dosyayı okuma modunda açar
    if (file == NULL) {
        printf("Dosya acilamadi: %s\n", filename); // Dosya açılamadıysa hata mesajı yazdırır
        return -1;
    }
    
    int N; // Çalışan sayısını tutacak değişken
    fscanf(file, "%d", &N); // İlk satırdan çalışan sayısını okur
    
    int i; // for döngüsü için değişken
    for(i = 0; i < N; i++){
        char *name =  (char*)malloc(50 * sizeof(char)); // Çalışanın adını tutacak dizi
        int age; // Çalışanın yaşını tutacak değişken
        float salary; // Çalışanın maaşını tutacak değişken
        char *managerName = (char*)malloc(50 * sizeof(char)); // Yöneticinin adını tutacak dizi
        
        // Dosyadan çalışan bilgilerini oku (format: isim yaş maaş yönetici)
        fscanf(file, "%s %d %f %s", name, &age, &salary, managerName);
        
        // Çalışan bilgileri alındıktan sonra createEmployee fonksiyonu ile çalışan yapısı oluşturulur
        employeeTemp[i] = createEmployee(name, age, salary);
        
        // Yöneticinin adını managerNames dizisine kopyalar
        managerNames[i] = (char*)malloc(strlen(managerName) + 1);
        strcpy(managerNames[i], managerName);
        free(managerName); // Yöneticinin adını serbest bırakır
    }
    
    fclose(file);
    return N;
}

/*
@brief Alınan çalışan bilgilerini kullanarak yeni bir çalışan yapısı oluşturan fonksiyon

@param name Çalışanın adı
@param age Çalışanın yaşı
@param salary Çalışanın maaşı

@return Oluşturulan çalışan yapısına işaretçi döndürür.
*/
struct Employee* createEmployee(char *name, int age, float salary){
    // Yeni bir çalışan yapısı oluşturur ve bellek tahsisi yapar
    struct Employee *newEmployee = (struct Employee*)malloc(sizeof(struct Employee));
    
    // Çalışanın adı için bellek tahsisi yapar ve ismi kopyalar
    newEmployee->name = (char*)malloc(strlen(name) + 1);
    strcpy(newEmployee->name, name);

    newEmployee->age = age; // Çalışanın yaşını atar
    newEmployee->salary = salary; // Çalışanın maaşını atar
    newEmployee->childCount = 0; // Çalışanın çocuk sayısını sıfırlar
    newEmployee->childrens = NULL; // Çalışanın çocuk dizisini başta NULL olarak ayarlar 
    newEmployee->parent = NULL; // Çalışanın ebeveynini başta NULL olarak ayarlar   
    return newEmployee; // Oluşturulan çalışan yapısına işaretçi döndürür
}

/*
@brief Çalışanın çocuk sayısını arttıran ve çocuğu ebeveynine ekleyen fonksiyon

@param parent Ebeveyn çalışan
@param child Çocuk çalışan
*/
void addChild(struct Employee *parent, struct Employee *child){
    parent->childCount++; // Ebeveynin çocuk sayısını arttırır

    // Ebeveynin çocuk dizisini yeniden boyutlandırır
    parent->childrens = (struct Employee**)realloc(parent->childrens, sizeof(struct Employee*) * parent->childCount);
    parent->childrens[parent->childCount - 1] = child; // Çocuğu ebeveynin çocuk dizisine ekler
}
/*
@brief Daha önce diziye eklenmiş olan çalışanları kullanarak ağaç yapısını oluşturan fonksiyon

@param employeeTemp Çalışanları bilgileriyle tutan geçici dizi
@param managerNames Yöneticilerin isimlerini tutan geçici dizi
@param N Çalışan sayısı

@return Oluşturulan ağaç yapısının köküne işaretçi döndürür.
*/
struct Employee* createTree(struct Employee **employeeTemp, char** managerNames, int N){
    
    // CEO'yu tutacak değişken aynı zamanda ağaç yapısının kökünü temsil eder
    // En başta değişkeni tanımlanıp NULL yapılır
    Employee *ceo = NULL; 
    
    int i; // for döngüsü için değişken

    for(i = 0; i < N; i++){
        if(strcmp(managerNames[i], "NULL") == 0){ // Eğer yöneticinin ismi "NULL" ise bu çalışan CEO'dur
            ceo = employeeTemp[i]; // CEO'yu atar
        }
        else{ // Eğer yöneticinin ismi "NULL" değilse
            int j; // for döngüsü için değişken
            int flag = 0; // Yöneticinin bulunup bulunmadığını kontrol etmek için flag değişkeni
            // Yöneticinin ismi geçici dizideki çalışanların isimleriyle karşılaştırılır
            for(j = 0; j < N && flag != 1; j++){ // Eğer yöneticinin ismi geçici dizideki çalışanların isimleriyle eşleşirse
                if(strcmp(managerNames[i], employeeTemp[j]->name) == 0){  // Yöneticinin ismi bulunursa
                    employeeTemp[i]->parent = employeeTemp[j]; // Çalışanın ebeveynini atar
                    addChild(employeeTemp[j], employeeTemp[i]); // Çalışanı ebeveynine ekler
                    flag = 1; // Yöneticinin bulunduğunu belirtir
                }
            }
        }
    }
    return ceo; // CEO'yu döndürür
}

/*
@brief Ağaç yapısının yüksekliğini hesaplayan fonksiyon

@param ceo Ağaç yapısının kökü (CEO)

@return Ağaç yapısının yüksekliğini döndürür.
*/
int calculateTreeHeight(struct Employee *ceo){
    if(ceo == NULL){ // Eğer ağaç yapısı boşsa
        return 0; // Yükseklik 0'dır
    }
    int maxHeight = 0; // Maksimum yüksekliği tutan değişken
    int i; // for döngüsü için değişken
    for(i = 0; i < ceo->childCount; i++){ // Çalışanın çocukları arasında döngü yapar
        // rekürsif olarak her çocuğun yüksekliğini hesaplar
        int height = calculateTreeHeight(ceo->childrens[i]); 
        if(height > maxHeight){ // Eğer çocuğun yüksekliği maksimum yükseklikten büyükse
            maxHeight = height; // Maksimum yüksekliği günceller
        }
    }
    return maxHeight + 1; // Her çocuğun yüksekliğine 1 ekler (kendi yüksekliği)
    // Bu sayede ağaç yapısının yüksekliğini hesaplar
}

/*
@brief Belirli bir seviyedeki çalışan sayısını hesaplayan fonksiyon

@param ceo Ağaç yapısının kökü (CEO)
@param level Hesaplanacak seviye

@return Belirli bir seviyedeki çalışan sayısını döndürür.
*/
int employeeCountAtLevel(struct Employee *ceo, int level){
    if(ceo == NULL){ // Eğer ağaç yapısı boşsa
        return 0; // Çalışan sayısı 0'dır
    }
    if(level == 1){ // Eğer seviye 1 ise
        return 1; // Bu seviyede sadece ceo vardır yani 1 çalışan vardır
    }
    int count = 0; // Çalışan sayısını tutan değişken
    int i; // for döngüsü için değişken
    for(i = 0; i < ceo->childCount; i++){ // Çalışanın çocukları arasında döngü yapar
        // Rekürsif olarak her çocuğun seviyesini hesaplar
        // ve toplam çalışan sayısını arttırır
        // Bu sayede belirli bir seviyedeki çalışan sayısını hesaplar
        count += employeeCountAtLevel(ceo->childrens[i], level - 1);
    }
    return count; // Belirli bir seviyedeki çalışan sayısını döndürür
}

/*
@brief Belirli bir seviyedeki en fazla çocuğa sahip çalışanı bulan fonksiyon

@param ceo Ağaç yapısının kökü (CEO)
@param level Belirli seviye

@return En fazla çocuğa sahip çalışanı döndürür.
*/
struct Employee* empWithMostChildrenByLevel(struct Employee *ceo, int level){
    if(ceo == NULL){ // Eğer ağaç yapısı boşsa
        return NULL; // En fazla çocuğa sahip çalışan yoktur
    }
    if(level == 1){ // Eğer seviye 1 ise
        return ceo; // Ceo'yu döndürür
    }

    // En fazla çocuğa sahip çalışanı tutacak değişken
    // Başlangıçta NULL yapılır
    struct Employee *mostChildren = NULL;
    int maxChildren = -1; // En fazla çocuğa sahip çalışan sayısını tutan değişken

    int i; // for döngüsü için değişken
    for(i = 0; i < ceo->childCount; i++){ // Çalışanın çocukları arasında döngü yapar
        // Rekürsif olarak her çocuğun seviyesini hesaplar
        // ve en fazla çocuğa sahip çalışanı bulur
        struct Employee *child = empWithMostChildrenByLevel(ceo->childrens[i], level - 1);
        // Eğer çocuğun çocuk sayısı maksimum çocuğa sahip çalışandan büyükse
        // veya en fazla çocuğa sahip çalışan NULL ise
        if(child != NULL && child->childCount > maxChildren){
            mostChildren = child; // En fazla çocuğa sahip çalışanı günceller
            maxChildren = child->childCount; // En fazla çocuğa sahip çalışan sayısını günceller
        }
    }
    return mostChildren; // En fazla çocuğa sahip çalışanı döndürür
}

/*
@brief Ağaç yapısındaki tüm çalışanların yaşlarını toplar ve onun sayısını döndürür

@param ceo Ağaç yapısının kökü (CEO)
@param employeeCount Toplam çalışan sayısını tutan işaretçi

@return Toplam yaşı döndürür
*/
int calculateTotalAge(struct Employee *ceo, int *employeeCount){
    if(ceo == NULL){ // Eğer ağaç yapısı boşsa
        return 0; // Toplam yaş 0'dır
    }
    int totalAge = ceo->age; // Ceo'nun yaşını alır
    (*employeeCount)++; // Toplam çalışan sayısını arttırır

    int i; // for döngüsü için değişken
    for(i = 0; i < ceo->childCount; i++){ // Çalışanın çocukları arasında döngü yapar
        // Rekürsif olarak her çocuğun yaşını toplar
        // ve toplam yaşı günceller
        totalAge += calculateTotalAge(ceo->childrens[i], employeeCount);
    }
    return totalAge; // Toplam yaşı döndürür
}

/*
@brief Ağaç yapısındaki tüm çalışanların maaşlarını toplar ve toplam maaşı döndürür

@param ceo Ağaç yapısının kökü (CEO)

@return Toplam maaşı döndürür
*/
float calculateTotalSalary(struct Employee *ceo){
    if(ceo == NULL){ // Eğer ağaç yapısı boşsa
        return 0; // Toplam maaş 0'dır
    }
    float totalSalary = ceo->salary; // Ceo'nun maaşını alır

    int i; // for döngüsü için değişken
    for(i = 0; i < ceo->childCount; i++){ // Çalışanın çocukları arasında döngü yapar
        // Rekürsif olarak her çocuğun maaşını toplar
        // ve toplam maaşı günceller
        totalSalary += calculateTotalSalary(ceo->childrens[i]);
    }
    return totalSalary; // Toplam maaşı döndürür
}

// Bellek tahsisi yaptığımız alanları serbest bırakma fonksiyonları

/*
@brief Ağaç yapısını ve geçici dizileri serbest bırakan fonksiyon

@param ceo Ağaç yapısının kökü (CEO)
*/
void freeTree(struct Employee *ceo){
    if(ceo == NULL){ // Eğer ağaç yapısı boşsa
        return; // Çıkış yapar
    }

    int i; // for döngüsü için değişken
    for(i = 0; i < ceo->childCount; i++){ // Çalışanın çocukları arasında döngü yapar
        freeTree(ceo->childrens[i]); // Rekürsif olarak her çocuğu serbest bırakır
    }
    free(ceo->name); // Çalışanın adını serbest bırakır
    free(ceo->childrens); // Çalışanın çocuk dizisini serbest bırakır
    free(ceo); // Ceo'yu serbest bırakır
}

/*
@brief Geçici employee dizisini serbest bırakan fonksiyon

@param employeeTemp Geçici çalışan dizisi
*/
void freeEmployeeInfo(struct Employee **employeeTemp){
    free(employeeTemp); // Geçici çalışan dizisini serbest bırakır
}

/*
@brief Geçici managerNames dizisini serbest bırakan fonksiyon

@param managerNames Geçici yöneticilerin isimlerini tutan dizi
@param N Çalışan sayısı
*/
void freeManagerNames(char **managerNames, int N){
    int i; // for döngüsü için değişken
    for(i = 0; i < N; i++){
        free(managerNames[i]); // Yöneticinin ismini serbest bırakır
    }
    free(managerNames); // Geçici yöneticilerin isimlerini tutan diziyi serbest bırakır
}

/*
@brief Üstteki fonksiyonları çağırarak tüm bellek tahsislerini serbest bırakan fonksiyon

@param ceo Ağaç yapısının kökü (CEO)
@param employeeTemp Geçici çalışan dizisi
@param managerNames Geçici yöneticilerin isimlerini tutan dizi
@param N Çalışan sayısı
*/
void freeAll(struct Employee *ceo, struct Employee **employeeTemp, char **managerNames, int N){
    freeTree(ceo); // Ağaç yapısını serbest bırakır
    freeEmployeeInfo(employeeTemp); // Geçici çalışan dizisini serbest bırakır
    freeManagerNames(managerNames, N); // Geçici yöneticilerin isimlerini tutan diziyi serbest bırakır
}