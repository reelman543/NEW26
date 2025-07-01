---
title: Tvproxy
emoji: 👀
colorFrom: gray
colorTo: green
sdk: docker
pinned: false
---

Check out the configuration reference at https://huggingface.co/docs/hub/spaces-config-reference
# tvproxy 📺

**Flask** ve **Requests** tabanlı, kısıtlamaları aşmak ve M3U/M3U8 akışlarına sorunsuz bir şekilde erişmek için tasarlanmış hafif, dockerize edilmiş bir proxy sunucusu.

- 📥 `.m3u` ve `.m3u8` akışlarını anında **indirin ve düzenleyin**.
- 🔁 **Proxy `.ts` segmentleri** özel başlıkları korurken.
- 🚫 `Referer`, `User-Agent` vb. gibi yaygın kısıtlamaları **atlayın**.
- 🐳 Herhangi bir makine, sunucu veya bulut platformunda **kolayca dockerize edilebilir**.
- 🧪 Gerçek zamanlı yönetim ve izleme için **tam özellikli web panosu**.

---

## 📚 İçindekiler

- Kimlik Doğrulama Kurulumu
- 1 GB RAM'li Sunucu Kurulumu
- Dağıtım Platformları
- Render
- HuggingFace
- Yerel Kurulum
- Docker
- Termux (Android)
- Python
- Yönetim Panosu
- Proxy Kullanımı
- Proxy Yapılandırması
- Docker Yönetimi

---

## 🔐 Kimlik Doğrulama Kurulumu (ZORUNLU)

### Güvenlik Ortamı Değişkenleri

| Değişken | Açıklama | Gerekli | Varsayılan |
|------------------|------------------------------------------------------------------------|---------------|
| `ADMIN_PASSWORD` | Yönetim panosuna erişim için parola | **YES** | `password123` |
| `SECRET_KEY` | Flask oturumları için gizli anahtar (benzersiz ve güvenli olmalıdır) | **YES** | Yok |
| `ADMIN_USERNAME` | Oturum açma kullanıcı adı (web kullanıcı arayüzünden yapılandırılabilir) | Hayır | `admin` |
| `ALLOWED_IPS` | İzin verilen IP'lerin virgülle ayrılmış listesi | Hayır | Tüm IP'ler |

> ⚠️ **Gerekli**: `ADMIN_PASSWORD` **ve** `SECRET_KEY`'i ayarlayın.
> 🔑 `SECRET_KEY` için benzersiz bir değer kullanın, örneğin şu şekilde üretilir:
> `openssl rand -hex 32`
> veya:
> `python -c 'import secrets; print(secrets.token_hex(32))'`

---

### 🐳 Docker örneği

```bash
docker run -d -p 7860:7860 \
-e ADMIN_PASSWORD="güvenli_şifreniz" \
-e SECRET_KEY="1f4d8e9a6c57bd2eec914d93cfb7a3efb9ae67f2643125c89cc3c50e75c4d4c3" \
--name tvproxy tvproxy
```

---

### 📦 Örnek `.env` (Termux / Python)

```dotenv
ADMIN_PASSWORD="your_secure_password"
SECRET_KEY="1f4d8e9a6c57bd2eec914d93cfb7a3efb9ae67f2643125c89cc3c50e75c4d4c3"
```

---

## 💾 Sınırlı RAM'li Sunucu için Yapılandırma (1 GB)

### 📃 `.env` optimize edildi

```dotenv
# GEREKLİ
ADMIN_PASSWORD="your_secure_password"
SECRET_KEY="generated_secret_key"

# Optimizasyonlar bellek
REQUEST_TIMEOUT=60
KEEP_ALIVE_TIMEOUT=120
MAX_KEEP_ALIVE_REQUESTS=100
POOL_CONNECTIONS=5
POOL_MAXSIZE=10

# Önbellek azaltıldı
CACHE_TTL_M3U8=2
CACHE_TTL_TS=60
CACHE_TTL_KEY=60
CACHE_MAXSIZE_M3U8=50
CACHE_MAXSIZE_TS=200
CACHE_MAXSIZE_KEY=50
```

---

## 🚫 Doğrudan Akış için Önbelleği Devre Dışı Bırak

Önbelleği **tamamen devre dışı bırakmak** istiyorsanız (örneğin, doğrudan akış ve her zaman güncel içerik için), bunu `.env` dosyanıza veya web'den bu satırı ekleyerek yapabilirsiniz arayüz:

```
CACHE_ENABLED=False

```

---

## ☁️ Dağıtım Platformları

### ▶️ Oluştur

1. Projeler → **Yeni → Web Hizmeti** → *Genel Git Deposu*.
2. Depo: `https://github.com/nzo66/tvproxy` → **Bağlan**.
3. Bir ad seçin, **Örnek Türü** `Ücretsiz` (veya daha yüksek).
4. **Ortam** alanına `ADMIN_PASSWORD` ve `SECRET_KEY` değişkenlerini ekleyin.
5. (İsteğe bağlı) `SOCKS5_PROXY`, `HTTP_PROXY`, `HTTPS_PROXY` ekleyin.
6. **Web Hizmeti Oluştur**.

### 🤖 HuggingFace Alanları

1. Yeni bir **Alan** oluşturun (SDK: *Docker*).
2. `DockerfileHF`'yi `Dockerfile` olarak yükleyin.
3. **Ayarlar → Sırlar**'a gidin ve `ADMIN_PASSWORD` ve `SECRET_KEY`'i ekleyin.
4. (İsteğe bağlı) `HTTP_PROXY` + `HTTPS_PROXY` ekleyin (SOCKS5 HF'de desteklenmez).
5. Değişkenlerdeki her değişiklikten sonra **Fabrika Yeniden Oluşturma** yapın.

#### **HuggingFace için Optimize Edilmiş Yapılandırma**

**HuggingFace Alanları** için bu optimize edilmiş yapılandırmanın kullanılması önerilir. Aşağıdaki değişkenleri Alanınızın **Sırlarına** ekleyin:

```dotenv
# REQUIRED
ADMIN_PASSWORD="your_secure_password"
SECRET_KEY="generated_secret_key"
CACHE_TTL_M3U8=5
CACHE_MAXSIZE_M3U8=500
CACHE_TTL_TS=600
CACHE_MAXSIZE_TS=8000
CACHE_TTL_KEY=600
CACHE_MAXSIZE_KEY=1000
POOL_CONNECTIONS=50
POOL_MAXSIZE=300
MAX_KEEP_ALIVE_REQUESTS=5000
KEEP_ALIVE_TIMEOUT=900
REQUEST_TIMEOUT=60
```

**Bu yapılandırma neden?**
- **Optimize Edilmiş Önbellek**: Sık video akışlarını daha iyi işlemek için daha yüksek değerler
- **Havuz Geliştirilmiş Bağlantılar**: Bulut ortamında birden fazla eşzamanlı bağlantıyı yönetir
- **Dengeli Zaman Aşımları**: Uzun süreli bağlantılar için kararlılık ve performans arasında denge

---

## 🚫 Doğrudan Akış için Önbelleği Devre Dışı Bırak

Önbelleği **tamamen devre dışı bırakmak** istiyorsanız (örneğin doğrudan akış ve her zaman güncel içerik için), bunu `.env` dosyanıza veya web arayüzünden şu satırı ekleyerek yapabilirsiniz:

```
CACHE_ENABLED=False

```

---

## 💻 Yerel Kurulum

### 🐳 Docker

```bash
git clone https://g
