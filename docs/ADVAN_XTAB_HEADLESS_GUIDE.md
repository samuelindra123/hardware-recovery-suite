# Rekayasa Transformasi Headless Android 13 (Advan XTab)

**Author / Hardware Engineer:** Samuel Indra Bastian  
**Project:** Mobile Hardware Recovery & Embedded Systems Forensics  
**Target Platform:** Advan XTab (Model: 8004 / Unisoc Tiger T310 / Android 13 - SDK 33)  
**System Architecture:** Headless Zero-Cable Wireless Computing Appliance  

---

## 1. Latar Belakang & Tantangan Rekayasa

Sebuah unit tablet **Advan XTab** mengalami kerusakan fisik total pada modul layar kaca LCD (layar mati, gelap gulita, pecah, dan lapisan sentuh digitizer fisik tidak berfungsi). Namun seluruh subsistem inti:
- SoC Unisoc Tiger T310 (1x Cortex-A75 @ 2.0 GHz + 3x Cortex-A55 @ 1.8 GHz)
- Memori 4GB LPDDR4X RAM & 64GB Penyimpanan Internal
- Wi-Fi 802.11 a/b/g/n/ac & Bluetooth
- Baterai dan subsistem manajemen daya Type-C

berada dalam kondisi normal 100%.

### Objektif Proyek:
Merancang dan mengimplementasikan sistem agar tablet ini dapat berfungsi sebagai **mesin komputasi mandiri tanpa layar (*Headless Computing Node*)**, beroperasi secara **100% nirkabel tanpa kabel (*Zero-Cable Operation*)**, dan dapat dikendalikan penuh dari jarak jauh (*multi-network remote desktop*).

---

## 2. Fase 1: Otorisasi Kriptografi ADB Tanpa Layar (Blind ADB Pairing)

Tantangan awal pada perangkat dengan layar mati adalah dialog keamanan sistem Android yang meminta persetujuan otorisasi kunci RSA: *"Izinkan USB Debugging dari komputer ini?"*.

### Rekayasa Sinyal HID via USB OTG:
Kami memanfaatkan protokol Human Interface Device (HID) USB untuk menginjeksikan sinyal perangkat keras keyboard mentah langsung ke subsistem kernel Linux Android:

```cmd
scrcpy.exe --otg
```

Urutan eksekusi penekanan tombol buta (*Blind Key Sequence*):
1. **[TAB]** $\rightarrow$ Memindahkan fokus elemen UI ke kotak centang *"Selalu izinkan dari komputer ini"*.
2. **[SPACE]** $\rightarrow$ Mengaktifkan centang permanen untuk menyimpan kunci publik RSA laptop ke direktori sistem `/data/misc/adb/adb_keys`.
3. **[TAB]** $\rightarrow$ Menggeser fokus kursor ke tombol aksi *"Izinkan / OK"*.
4. **[ENTER]** $\rightarrow$ Menyetujui otorisasi.

**Hasil:** Otorisasi tersimpan permanen di memori perangkat, menghasilkan status `device` resmi tanpa perlu interaksi layar fisik.

---

## 3. Fase 2: Pengerasan Kernel & Subsistem Android (Keep-Alive Hardening)

Agar tablet tetap siaga (*always-on*) selama terhubung ke sumber daya charger dan tidak masuk ke mode tidur mendalam yang mematikan stack jaringan:

```bash
# 1. Konfigurasi CPU & Display State saat terhubung ke catu daya
adb shell "svc power stayon true"
adb shell "settings put global stay_on_while_plugged_in 3"

# 2. Perpanjangan batas waktu timeout layar ke batas maksimum sistem (24.8 hari)
adb shell "settings put system screen_off_timeout 2147483647"

# 3. Menonaktifkan layar kunci Android (Bypass Lockscreen)
adb shell "locksettings set-disabled true"
adb shell "settings put secure lockscreen.disabled 1"

# 4. Membuka port ADB TCP/IP nirkabel pada port standar 5555
adb tcpip 5555
```

---

## 4. Fase 3: Arsitektur Remote Nirkabel Multi-Jaringan (AnyDesk + AD1)

Untuk memungkinkan pengendalian tablet dari luar rumah (lintas jaringan publik/seluler):

### Tantangan 1: Proteksi Anti-Tapjacking Android 13 (MediaProjection)
Android 13 secara bawaan memblokir klik mouse virtual pada pop-up dialog sistem izin perekaman layar (*MediaProjection Permission Activity*).
- **Solusi Rekayasa:** Injeksi izin level AppOps via shell:
  ```bash
  adb shell "appops set com.anydesk.anydeskandroid PROJECT_MEDIA allow"
  ```
  Perintah ini mengunci izin secara permanen di database sistem, meniadakan dialog persetujuan berulang selamanya.

### Tantangan 2: Pembatasan Akses Input Sentuhan (View-Only Bypass)
Sistem keamanan Android membatasi injeksi event sentuh/mouse dari aplikasi pihak ketiga tanpa service aksesibilitas.
- **Solusi Rekayasa:**
  1. Pemasangan modul kontrol resmi: **AnyDesk Control Plugin AD1** (`com.anydesk.adcontrol.ad1`).
  2. Pendaftaran dan pengikatan (*binding*) service aksesibilitas:
     ```bash
     adb shell "settings put secure enabled_accessibility_services com.anydesk.adcontrol.ad1/com.anydesk.adcontrol.AccService"
     adb shell "settings put secure accessibility_enabled 1"
     ```
  3. Pembebasan pembatasan baterai (*Doze Mode Whitelist*) agar koneksi tidak tertutup saat idle:
     ```bash
     adb shell "dumpsys deviceidle whitelist +com.anydesk.anydeskandroid"
     adb shell "dumpsys deviceidle whitelist +com.anydesk.adcontrol.ad1"
     adb shell "appops set com.anydesk.anydeskandroid SYSTEM_ALERT_WINDOW allow"
     adb shell "appops set com.anydesk.adcontrol.ad1 SYSTEM_ALERT_WINDOW allow"
     ```

---

## 5. Arsitektur Operasional Mandiri (Dual Connection Routing)

Sistem ini mendukung dua mode akses yang saling melengkapi:

```
[ ADVAN XTAB HEADLESS APPLIANCE ] (Ditenagai Charger Tembok 24/7 di Sudut Ruangan)
           │
           ├── [1] LOCAL HIGH-SPEED PATH (Wi-Fi Lokal Rumah)
           │   ├── Protokol: scrcpy wireless via adb connect <IP_TABLET>:5555
           │   └── Performa: 60 FPS, Latensi ~0ms, Resolusi Asli 800x1280.
           │
           └── [2] GLOBAL WAN REMOTE PATH (Akses Dari Mana Saja via Internet)
               ├── Protokol: AnyDesk Cloud Relay
               └── Performa: Dapat diakses dari smartphone (Android/iOS) atau PC luar kota
                   menggunakan koneksi kuota seluler (4G/5G).
```

---

*Laporan teknis ini disusun secara independen sebagai dokumentasi rekayasa perangkat headless Android oleh Samuel Indra Bastian.*
