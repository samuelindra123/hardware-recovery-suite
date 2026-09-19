# Hardware Recovery & Headless Device Engineering Suite

[![Developer](https://img.shields.io/badge/Developer-Samuel%20Indra%20Bastian-blue.svg)](mailto:comdonate9@gmail.com)
[![Contact](https://img.shields.io/badge/Email-comdonate9%40gmail.com-red.svg)](mailto:comdonate9@gmail.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](#)
[![Platforms](https://img.shields.io/badge/Targets-MediaTek%20MT6765%20%7C%20Unisoc%20T310-orange.svg)](#)

> **Repositori Resmi Rekayasa Perangkat Keras & Otomasi Sistem Headless**  
> Disusun dan dikembangkan oleh **Samuel Indra Bastian** sebagai catatan forensik teknis, arsip skrip otomatisasi, dan panduan pemulihan menyeluruh dari perjalanan eksplorasi perangkat keras mobile.

---

## 🌟 Daftar Isi
1. [Kronik Perjuangan: Dari Pagi Hingga Malam](#-kronik-perjuangan-dari-pagi-hingga-malam)
2. [Proyek 1: Realme C2 (MediaTek MT6765) Forensics](#-proyek-1-realme-c2-mediatek-mt6765-forensics)
3. [Proyek 2: Advan XTab (Unisoc T310) Headless Transformation](#-proyek-2-advan-xtab-unisoc-t310-headless-transformation)
4. [Struktur Repositori & Arsip Skrip](#-struktur-repositori--arsip-skrip)
5. [Panduan Cepat Pemulihan Setelah Windows Di-Reset](#-panduan-cepat-pemulihan-setelah-windows-di-reset)
6. [Arsitektur Teknis & Perintah Penting](#-arsitektur-teknis--perintah-penting)

---

## ⏳ Kronik Perjuangan: Dari Pagi Hingga Malam

Perjalanan rekayasa ini diawali dari ambisi untuk membangkitkan dua perangkat keras dengan kondisi ekstrem tanpa biaya penggantian komponen (*zero-budget hardware engineering*):

1. **Pagi hingga Sore: Pertarungan Forensik Realme C2 (MT6765)**  
   Menghadapi unit ponsel dalam kondisi mati total (*hard brick* / baterai 0V). Kami merancang sistem injeksi tegangan 4.4V dengan filter kapasitor elektrolit, menembus proteksi *Boot ROM (BROM)* MediaTek melalui kerentanan *Kamakiri*, mengeksekusi payload di dalam 128KB SRAM internal, hingga membuktikan secara pasti matinya chip memori internal eMCP pada tingkat register silikon.
2. **Sore hingga Malam: Kebangkitan & Transformasi Headless Advan XTab (T310)**  
   Beralih ke tablet Advan XTab yang mengalami kerusakan total pada layar kaca LCD (gelap gulita, tanpa respon sentuh fisik). Melalui emulasi keyboard OTG buta (*blind key sequence*), pengerasan kernel Android 13, aktivasi AnyDesk v9.0 unattended access, bypass proteksi *anti-tapjacking MediaProjection*, hingga instalasi plugin kontrol AD1, tablet berlayar rusak ini berhasil disulap menjadi **perangkat komputasi mandiri nirkabel 100% tanpa kabel (*Zero-Cable Headless Appliance*)**.

---

## 🔬 Proyek 1: Realme C2 (MediaTek MT6765) Forensics

Laporan lengkap: [`docs/REALME_C2_HARDWARE_DIAGNOSTICS.md`](docs/REALME_C2_HARDWARE_DIAGNOSTICS.md)

### Analisis Kerusakan:
- **CPU:** MediaTek MT6765V Helio P22 (Octa-core Cortex-A53).
- **Hasil Pengujian BROM:**
  - Handshake USB BROM (`VID:0e8d PID:0003`) **BERHASIL**.
  - Injeksi DA1 ke 128KB internal SRAM **BERHASIL**.
  - Osilator kristal 26 MHz dan jalur USB D+/D- **NORMAL**.
- **Hasil Pengujian Storage (eMCP):**
  - Pembacaan bus eMMC dan DRAM controller mengembalikan status *Zero / Timeout*.
  - Pemanggilan partisi `boot0`/`boot1` via `dumppreloader` gagal.
  - Pembacaan tabel partisi GPT (`printgpt`) gagal.
- **Kesimpulan Akhir:** Chip eMCP (kombinasi eMMC 5.1 flash + DRAM) rusak secara fisik (*Physical Hardware Dead*). Status unit: **Beyond Economical Repair (BER)** tanpa penggantian IC dan reballing BGA via EasyJTAG.

---

## 🚀 Proyek 2: Advan XTab (Unisoc T310) Headless Transformation

Laporan lengkap: [`docs/ADVAN_XTAB_HEADLESS_GUIDE.md`](docs/ADVAN_XTAB_HEADLESS_GUIDE.md)

### Solusi Rekayasa Headless Android 13:
1. **Otorisasi Kunci Kriptografi RSA Buta:**
   Menggunakan `scrcpy --otg` dan urutan tombol:
   `[TAB]` $\rightarrow$ `[SPASI]` (Centang Selalu Izinkan) $\rightarrow$ `[TAB]` $\rightarrow$ `[ENTER]` (Klik OK).
2. **Pengerasan Sistem Standby:**
   - `stay_on_while_plugged_in = 3` (Tidak pernah tidur saat dicas).
   - `screen_off_timeout = 2147483647` (Batas waktu layar maksimum).
   - `lockscreen.disabled = 1` (Menghilangkan lockscreen).
3. **Bypass Keamanan Android 13:**
   - Mengatasi blokir klik mouse pada konfirmasi rekam layar (*Anti-Tapjacking*) via `appops set com.anydesk.anydeskandroid PROJECT_MEDIA allow`.
   - Mengatasi batasan *View-Only* AnyDesk dengan menginstal `com.anydesk.adcontrol.ad1` dan mengaktifkan `com.anydesk.adcontrol.AccService`.
4. **Operasional 100% Bebas Kabel:**
   - **ID AnyDesk Tablet:** **`1 748 101 943`** (Akses dari mana saja lewat HP via jaringan internet 4G/5G).
   - **Jalur Lokal Wi-Fi:** `adb connect 192.168.1.15:5555` $\rightarrow$ scrcpy nirkabel (60 FPS tanpa lag).

---

## 📂 Struktur Repositori & Arsip Skrip

```
hardware-recovery-suite/
├── README.md                          <-- Dokumentasi utama rekayasa sistem
├── docs/
│   ├── REALME_C2_HARDWARE_DIAGNOSTICS.md  <-- Laporan forensik hardware MT6765
│   ├── ADVAN_XTAB_HEADLESS_GUIDE.md       <-- Panduan operasional headless tablet
│   └── WINDOWS_RESET_RESTORE_GUIDE.md     <-- Panduan restorasi pasca-reset Windows
├── keys/
│   ├── adbkey                         <-- Kunci privat RSA identitas laptop
│   ├── adbkey.pub                     <-- Kunci publik RSA identitas laptop
│   ├── BACA_PETUNJUK.txt              <-- Instruksi manual salin kunci
│   └── RESTORE_ADB_KEYS.bat           <-- Skrip otomatis restorasi kunci 1-klik
└── scripts/
    ├── advan-xtab/
    │   ├── BUKA_LAYAR_TABLET.bat          <-- Buka scrcpy kabel
    │   ├── KLIK_IZINKAN_OTOMATIS.bat      <-- Otorisasi buta via scrcpy OTG
    │   ├── KONEKSI_WIRELESS_WIFI.bat      <-- Buka scrcpy nirkabel via Wi-Fi lokal
    │   ├── SETUP_HEADLESS_PERMANEN.bat    <-- Skrip pengaturan keep-alive sistem
    │   └── AKTIFKAN_ANYDESK_KONTROL.bat   <-- Skrip aktivasi remote kontrol AnyDesk
    └── realme-c2/
        ├── BACA_MESIN.bat                 <-- Injeksi bypass DRAM DA1 via MTKClient
        ├── BUKA_GUI.bat                   <-- Antarmuka grafis MTKClient
        ├── COBA_PRELOADER.bat             <-- Pengujian beragam preloader pabrikan
        ├── DUMP_PRELOADER.bat             <-- Dump preloader dari boot block
        └── SEDOT_DARI_RAM.bat             <-- Dump preloader langsung dari SRAM chip
```

---

## ⚡ Panduan Cepat Pemulihan Setelah Windows Di-Reset

Panduan lengkap: [`docs/WINDOWS_RESET_RESTORE_GUIDE.md`](docs/WINDOWS_RESET_RESTORE_GUIDE.md)

1. **Clone Repositori:**
   ```cmd
   gh repo clone samuelindra123/hardware-recovery-suite
   ```
2. **Jalankan Restorasi Kunci Identitas:**
   Masuk ke folder `keys/` lalu klik dua kali file **`RESTORE_ADB_KEYS.bat`**.
3. **Selesai!**
   Laptop baru Anda langsung dikenali oleh Advan XTab tanpa perlu otorisasi ulang. Anda bisa langsung membuka AnyDesk atau menghubungkan kabel USB kapan saja.

---

## 💻 Arsitektur Teknis & Perintah Penting

### Perintah Kunci ADB Shell:
```bash
# Menyetel Keep-Awake Permanen Saat Dicas
adb shell "svc power stayon true"
adb shell "settings put global stay_on_while_plugged_in 3"

# Menonaktifkan Kunci Layar (Bypass Lockscreen)
adb shell "locksettings set-disabled true"
adb shell "settings put secure lockscreen.disabled 1"

# Bypass Proteksi MediaProjection Android 13
adb shell "appops set com.anydesk.anydeskandroid PROJECT_MEDIA allow"

# Mengaktifkan Layanan Aksesibilitas Plugin Kontrol AnyDesk AD1
adb shell "settings put secure enabled_accessibility_services com.anydesk.adcontrol.ad1/com.anydesk.adcontrol.AccService"
adb shell "settings put secure accessibility_enabled 1"

# Mendaftarkan ke Whitelist Baterai / Doze Mode
adb shell "dumpsys deviceidle whitelist +com.anydesk.anydeskandroid"
adb shell "dumpsys deviceidle whitelist +com.anydesk.adcontrol.ad1"
```

---

## 👤 Profil Pengembang (Developer Profile)

- **Nama:** Samuel Indra Bastian  
- **Email:** [comdonate9@gmail.com](mailto:comdonate9@gmail.com)  
- **GitHub:** [@samuelindra123](https://github.com/samuelindra123)  
- **Fokus Rekayasa:** Embedded Hardware Forensics, Low-Level Protocol Exploitation, Reverse Engineering, and IoT Systems.

---

*Hak Cipta © 2026 Samuel Indra Bastian. Seluruh hak cipta dilindungi undang-undang.*
