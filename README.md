# Flutter Projesi
![İstinye Üniversitesi](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPDx-F-jg4WHeC9IQEykC41ZIMYOTQNJo5RQ&s)


## Ekibimiz
- **Danışman:** Keyvan Arasteh [Github](https://github.com/keyvanarasteh)
- **Takım Lideri** Doğukan Şahin [Github](https://github.com/Dogushn)


# ListeGo - Akıllı Alışveriş Listeleri

ListeGo, Flutter ile geliştirilmiş modern ve zengin özelliklere sahip bir alışveriş listesi mobil uygulamasıdır. Yerel bildirimler, veri saklama ve şık bir Material Design 3 arayüzü ile alışveriş listelerinizi kolayca yönetmenizi sağlar.

## Özellikler

### 🛒 Temel Özellikler
- **Liste oluşturma ve yönetme** - Alışverişinizi birden fazla listeyle düzenleyin.
- **Detaylı ürün ekleme** - Her ürün için miktar, not ve hatırlatıcı ekleyin.
- **Alınanları işaretleme** - Alışverişinizdeki ilerlemenizi takip edin.
- **Tamamlanan listeleri arşivleme** - Aktif listelerinizi temiz ve düzenli tutun.
- **Liste kopyalama** - Sık kullandığınız alışveriş listelerini kolayca yeniden oluşturun.

### 🔔 Akıllı Bildirimler
- **Ürün hatırlatıcıları** - Belirli ürünler için hatırlatıcılar kurun.
- **Liste tamamlama bildirimleri** - Bir listeyi tamamladığınızda bildirim alın.
- **Özelleştirilebilir bildirim ayarları** - Bildirimleri ne zaman ve nasıl alacağınızı kontrol edin.

### 🎨 Modern Arayüz ve Kullanıcı Deneyimi
- **Material Design 3** - Google'ın tasarım kurallarına uygun, modern ve şık arayüz.
- **Koyu/Açık tema desteği** - İstediğiniz temayı seçin veya sistem ayarlarını takip edin.
- **Tüm ekran boyutlarına uyumlu** - Farklı ekran boyutlarında sorunsuz çalışır.
- **Akıcı animasyonlar** - Keyifli bir kullanıcı deneyimi için akıcı geçişler.

### 💾 Veri Yönetimi
- **Yerel veri saklama** - Verileriniz Hive veritabanı kullanılarak cihazınızda güvende kalır.
- **Çevrimdışı çalışma** - İnternet bağlantısı olmadan da çalışır.
- **Veri yedekleme/geri yükleme** - Alışveriş listelerinizi yedekleyin ve geri yükleyin (yakında eklenecek).

## Ekranlar

1.  **Açılış Ekranı**
    - Uygulamaya hoş bir animasyonlu giriş.
    - Gerekli servisleri başlatır ve verileri yükler.

2.  **Ana Ekran**
    - Tüm alışveriş listelerine genel bir bakış.
    - Toplam liste, ürün ve tamamlanma oranını gösteren istatistikler.
    - Hızlı yeni liste oluşturma butonları.

3.  **Liste Detay Ekranı**
    - Belirli bir listedeki ürünleri görüntüleme ve yönetme.
    - Görsel ilerleme takibi.
    - Ürün ekleme, düzenleme ve silme.

4.  **Liste Ekleme Ekranı**
    - İsim ve açıklama ile yeni alışveriş listeleri oluşturma.
    - Yaygın liste türleri için hızlı şablonlar.

5.  **Ürün Ekleme Ekranı**
    - Miktar, not ve hatırlatıcı ile ürün ekleme.
    - Hatırlatıcılar için tarih/saat seçimi.

6.  **Ayarlar Ekranı**
    - Bildirim, tema ve görünüm tercihleri.
    - Liste ve veri yönetimi araçları.


## Demo Video
https://github.com/user-attachments/assets/979e1cb2-70ce-4f47-b078-69f66757a77c


## Ekran Görüntüleri
<img src="https://github.com/Dogushn/listego/blob/main/ScreenShots/Screenshot_20250728_221146.png" width="200" height="400" />
<img src="https://github.com/Dogushn/listego/blob/main/ScreenShots/Screenshot_20250728_221225.png" width="200" height="400" />
<img src="https://github.com/Dogushn/listego/blob/main/ScreenShots/Screenshot_20250728_221259.png" width="200" height="400" />
<img src="https://github.com/Dogushn/listego/blob/main/ScreenShots/Screenshot_20250728_221319.png" width="200" height="400" />
<img src="https://github.com/Dogushn/listego/blob/main/ScreenShots/Screenshot_20250728_221351.png" width="200" height="400" />
<img src="https://github.com/Dogushn/listego/blob/main/ScreenShots/Screenshot_20250728_221458.png" width="200" height="400" />
<img src="https://github.com/Dogushn/listego/blob/main/ScreenShots/Screenshot_20250728_221522.png" width="200" height="400" />
<img src="https://github.com/Dogushn/listego/blob/main/ScreenShots/Screenshot_20250728_221532.png" width="200" height="400" />
<img src="https://github.com/Dogushn/listego/blob/main/ScreenShots/Screenshot_20250728_221542.png" width="200" height="400" />
### Proje Yapısı
`lib/`
`├── models/           # Veri modelleri`
`├── providers/        # Durum yönetimi (Provider)`
`├── screens/          # Arayüz ekranları`
`├── services/         # Servisler ve iş mantığı`
`├── utils/            # Yardımcı fonksiyonlar`
`└── widgets/          # Tekrar kullanılabilir arayüz bileşenleri`


### Kullanılan Teknolojiler
- **Flutter 3.16+** - Platformlar arası mobil uygulama geliştirme.
- **Material Design 3** - Modern arayüz tasarım sistemi.
- **Hive** - Hafif ve hızlı bir yerel veritabanı.
- **Provider** - Durum yönetimi çözümü.
- **flutter_local_notifications** - Yerel bildirim sistemi.
- **intl** - Uluslararasılaştırma ve tarih formatlama.
- **timezone** - Bildirimler için zaman dilimi desteği.

### Veri Modelleri
- **ShoppingItem** - Ad, miktar, not gibi özelliklere sahip tekil ürünler.
- **ShoppingList** - Ürün koleksiyonları ve tamamlama durumu takibi.
- **AppSettings** - Kullanıcı tercihleri ve uygulama ayarları.

### Servisler
- **DatabaseService** - Tüm veritabanı işlemlerini yönetir.
- **NotificationService** - Yerel bildirimleri ve hatırlatıcıları yönetir.

## Başlarken (Geliştiriciler İçin)

### Gereksinimler
- Flutter SDK 3.16.0 veya üstü
- Dart SDK 3.8.0 veya üstü

### Kurulum

1.  **Projeyi klonlayın**
    ```bash
    git clone <repository-url>
    cd listego
    ```

2.  **Bağımlılıkları yükleyin**
    ```bash
    flutter pub get
    ```

3.  **Hive adaptörlerini oluşturun**
    ```bash
    flutter packages pub run build_runner build
    ```

4.  **Uygulamayı çalıştırın**
    ```bash
    flutter run
    ```

## Geliştirme

Veri modellerinde bir değişiklik yaptığınızda, Hive'ın kodlarını yeniden oluşturmak için şu komutu çalıştırın:
```bash
flutter packages pub run build_runner build
```

## İletişim
- Proje bağlantısı: https://github.com/Dogushn/listego.git
- İstinye Üniversitesi: https://www.istinye.edu.tr/

