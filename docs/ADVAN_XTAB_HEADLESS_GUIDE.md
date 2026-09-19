# Panduan Lengkap Transformasi Headless Advan XTab (Android 13)

**Developer:** Samuel Indra Bastian  
**Email:** comdonate9@gmail.com  
**Project:** Hardware Recovery Suite  
**Date:** September 2026  

---

## 1. Latar Belakang & Tantangan Rekayasa

Sebuah unit tablet **Advan XTab (Model: 8004 / Unisoc Tiger T310 / Android 13 - SDK 33)** mengalami kerusakan fisik total pada modul layar LCD (layar mati / gelap gulita / pecah, dan fungsi layar sentuh fisik mati). Meskipun demikian, seluruh subsistem internal:
- Motherboard dan prosesor Unisoc T310
- Memori RAM 4GB dan penyimpanan internal eMMC
- Modul nirkabel Wi-Fi & Bluetooth
- Baterai dan subsistem pengisian daya USB Type-C

berada dalam kondisi **100% sehat dan berfungsi normal**.

### Tujuan Proyek:
Mengubah tablet berlayar rusak ini menjadi **perangkat komputasi mandiri tanpa kepala (*Headless Computing Appliance*)** yang dapat dioperasikan secara **100% nirkabel tanpa kabel (*zero-cable operation*)** dari mana saja melalui internet menggunakan HP atau komputer.

---

## 2. Fase 1: Otorisasi ADB Tanpa Layar (Blind ADB Pairing)

Tantangan terbesar pada perangkat Android dengan layar mati adalah dialog keamanan Android yang meminta konfirmasi: *"Izinkan USB Debugging dari komputer ini? [ ] Selalu izinkan dari komputer ini [Batal] [Izinkan]"*.

### Solusi Rekayasa: Emulasi Keyboard OTG
Kami memanfaatkan kemampuan *scrcpy* dalam mode Human Interface Device (HID/OTG) yang menginjeksikan sinyal keyboard USB mentah langsung ke kernel Linux Android:

```cmd
scrcpy.exe --otg
```

Urutan tombol pintas buta (*blind key sequence*):
1. **[TAB]** $\rightarrow$ Memindahkan fokus kursor ke kotak centang *"Selalu izinkan dari komputer ini"*.
2. **[SPACE]** $\rightarrow$ Mencentang kotak persetujuan permanen.
3. **[TAB]** $\rightarrow$ Memindahkan fokus ke tombol *"Izinkan / OK"*.
4. **[ENTER]** $\rightarrow$ Mengeksekusi persetujuan.

**Hasil:** Otorisasi kunci kriptografi RSA laptop tersimpan permanen di dalam partisi sistem Android (`/data/misc/adb/adb_keys`), menghasilkan status `A8004ST310CT044549 device`.

---

## 3. Fase 2: Pengerasan Sistem Headless (Keep-Alive Hardening)

Agar tablet dapat beroperasi 24/7 tanpa terkunci atau tertidur saat ditinggalkan tanpa pengawasan, serangkaian perintah sistem dieksekusi via ADB:

```bash
# 1. Menjaga CPU dan sistem grafis tetap aktif saat terhubung ke sumber daya
adb shell "svc power stayon true"
adb shell "settings put global stay_on_while_plugged_in 3"

# 2. Menyetel batas waktu mati layar ke nilai maksimum Integer 32-bit (24.8 hari)
adb shell "settings put system screen_off_timeout 2147483647"

# 3. Menonaktifkan sistem penguncian layar (Lockscreen Bypass)
adb shell "locksettings set-disabled true"
adb shell "settings put secure lockscreen.disabled 1"

# 4. Membuka port ADB nirkabel TCP/IP di port standar
adb tcpip 5555
```

---

## 4. Fase 3: Arsitektur Remote Nirkabel Multi-Jaringan (AnyDesk + AD1)

Agar tablet dapat diakses dari jaringan mana saja (bahkan di luar rumah menggunakan paket data seluler tanpa kabel), kami mengonfigurasi **AnyDesk Android v9.0.0**:

- **ID Unik AnyDesk Tablet:** **`1 748 101 943`**

### Rintangan 1: Proteksi Anti-Tapjacking Android 13 (MediaProjection)
Android 13 memiliki proteksi ketat yang memblokir klik mouse virtual pada pop-up dialog sistem *"Mulai merekam atau melakukan transmisi dengan AnyDesk?"*.
- **Solusi:** Injeksi izin level AppOps melalui ADB:
  ```bash
  adb shell "appops set com.anydesk.anydeskandroid PROJECT_MEDIA allow"
  ```
  Perintah ini mengunci izin transmisi layar secara permanen, menghilangkan pop-up konfirmasi berulang selamanya.

### Rintangan 2: Keterbatasan View-Only (Remote Input Blocking)
Secara bawaan, Android melarang aplikasi remote desktop menginjeksikan klik atau sentuhan tanpa plugin aksesibilitas berizin khusus.
- **Solusi:**
  1. Memasang plugin resmi: **AnyDesk Control Plugin AD1** (`com.anydesk.adcontrol.ad1`).
  2. Mengaktifkan layanan aksesibilitas via shell:
     ```bash
     adb shell "settings put secure enabled_accessibility_services com.anydesk.adcontrol.ad1/com.anydesk.adcontrol.AccService"
     adb shell "settings put secure accessibility_enabled 1"
     ```
  3. Mendaftarkan AnyDesk ke dalam Whitelist Penghemat Baterai (*Doze Mode Whitelist*):
     ```bash
     adb shell "dumpsys deviceidle whitelist +com.anydesk.anydeskandroid"
     adb shell "dumpsys deviceidle whitelist +com.anydesk.adcontrol.ad1"
     adb shell "appops set com.anydesk.anydeskandroid SYSTEM_ALERT_WINDOW allow"
     adb shell "appops set com.anydesk.adcontrol.ad1 SYSTEM_ALERT_WINDOW allow"
     ```

---

## 5. Arsitektur Operasional Harian (Dual Access Mode)

Tablet ini kini memiliki dua jalur akses mandiri:

```
[ ADVAN XTAB HEADLESS UNIT ] (Tersambung ke Charger Listrik 24/7 di Sudut Rumah)
           │
           ├── JALUR 1: LOKAL WI-FI (High-Speed Latency Rendah)
           │   └── Jalur: scrcpy wireless via adb connect 192.168.1.15:5555
           │   └── Karakteristik: 60 FPS, Latensi ~0ms, Jernih tanpa kompresi internet.
           │
           └── JALUR 2: GLOBAL WAN / INTERNET (Akses Dari Mana Saja)
               └── Jalur: AnyDesk Cloud Server via ID 1 748 101 943
               └── Karakteristik: Dapat dibuka dari smartphone Android/iOS atau Laptop
                   menggunakan koneksi 4G/5G di mana pun Anda berada.
```

---

*Dokumentasi ini membuktikan bahwa keterbatasan fisik hardware layar pecah dapat diatasi secara elegan melalui rekayasa sistem operasi dan protokol remote nirkabel.*
