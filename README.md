# Mobile Hardware Recovery & Embedded Systems Forensics Lab

[![Author](https://img.shields.io/badge/Engineer-Samuel%20Indra%20Bastian-blue.svg)](#)
[![Target Platforms](https://img.shields.io/badge/SoC-MediaTek%20MT6765%20%7C%20Unisoc%20T310-orange.svg)](#)
[![Architecture](https://img.shields.io/badge/Architecture-ARM%20Cortex--A53%20%7C%20Cortex--A75-purple.svg)](#)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](#)

> **Laporan Resmi Rekayasa Perangkat Keras, Forensik Protokol Tingkat Rendah, dan Transformasi Sistem Headless**  
> Disusun dan dikembangkan oleh **Samuel Indra Bastian** sebagai portofolio dokumentasi teknis mendalam dalam menangani perangkat keras mobile dengan kerusakan ekstrem.

---

## 📑 Daftar Isi
1. [Ikhtisar Proyek (Project Overview)](#-ikhtisar-proyek-project-overview)
2. [Bagian 1: Forensik Realme C2 (MT6765) & Rencana SMD Rework](#-bagian-1-forensik-realme-c2-mt6765--rencana-smd-rework)
3. [Bagian 2: Transformasi Headless Advan XTab (Unisoc T310)](#-bagian-2-transformasi-headless-advan-xtab-unisoc-t310)
4. [Arsip Skrip Otomasi & Struktur Repositori](#-arsip-skrip-otomasi--struktur-repositori)
5. [Referensi Perintah Kunci Sistem (Technical Commands)](#-referensi-perintah-kunci-sistem-technical-commands)

---

## 🔬 Ikhtisar Proyek (Project Overview)

Repositori ini merangkum dua studi kasus rekayasa perangkat keras (*hardware engineering*) dan sistem operasi embedded:

1. **Studi Kasus 1 (Realme C2 / MT6765):** Mendiagnosis smartphone mati total (*hard-bricked*) melalui eksploitasi Boot ROM (BROM) dan eksekusi payload di SRAM internal, membuktikan kerusakan fisik pada chip memori terintegrasi (eMCP), serta menyusun peta jalan perbaikan tingkat komponen (*BGA SMD Rework*).
2. **Studi Kasus 2 (Advan XTab / Unisoc T310):** Menyelamatkan tablet dengan modul LCD pecah dan digitizer mati total, mentransformasikannya menjadi perangkat komputasi mandiri tanpa layar (*Headless Appliance*) yang beroperasi 100% tanpa kabel (*Zero-Cable Operation*) melalui internet.

---

## 🛠️ Bagian 1: Forensik Realme C2 (MT6765) & Rencana SMD Rework

Laporan teknis lengkap: [`docs/REALME_C2_HARDWARE_DIAGNOSTICS.md`](docs/REALME_C2_HARDWARE_DIAGNOSTICS.md)

### 1. Diagnostik Forensik Tingkat Rendah
- **Stabilisasi Daya:** Mengatasi baterai 0V dengan injeksi catu daya DC eksternal 4.40V paralel dengan kapasitor elektrolit peredam riak tegangan.
- **Handshake BROM & Injeksi SRAM:** Menggunakan kerentanan *Kamakiri*, payload DA1 berhasil diinjeksikan langsung ke dalam **128KB Internal SRAM** MT6765. Hal ini membuktikan silikon CPU, USB PHY, dan osilator 26 MHz normal.
- **Identifikasi Titik Kegagalan:** Pengontrol memori gagal berkomunikasi dengan chip memori internal (eMCP). Pembacaan partisi boot (`dumppreloader`) dan tabel partisi GPT (`printgpt`) mengembalikan status *I/O timeout*.
- **Kesimpulan:** Terjadi kerusakan fisik pada chip eMCP internal (keausan sel NAND flash / solder ball fracture).

### 2. Rencana Kerja Rekayasa Lanjutan (BGA SMD Rework Roadmap)
Ketika fasilitas peralatan rework tingkat lanjut telah tersedia (Hot Air Blower, mikroskop, stensil BGA, dan alat pemrograman JTAG), langkah restorasi perangkat keras akan dieksekusi:

```
[ Pre-heating & Pembersihan Lem Underfill (150°C - 180°C) ]
                         │
                         ▼
[ Desoldering IC eMCP BGA-153/221 Rusak Menggunakan Hot Air Blower (350°C - 380°C) ]
                         │
                         ▼
[ Pembersihan & Perataan Pad Motherboard (Solder Wick + Fluks Amtech NC-559-ASM) ]
                         │
                         ▼
[ Pemrograman IC eMCP Baru via EasyJTAG Plus / UFI Box (RPMB Key & Boot Bus Config) ]
                         │
                         ▼
[ Reballing IC Baru Menggunakan Stensil BGA & Pasta Timah Sn63Pb37 (183°C) ]
                         │
                         ▼
[ Reflow Soldering IC Baru pada Motherboard & Scatter Flashing via MTK BROM ]
```

---

## ⚡ Bagian 2: Transformasi Headless Advan XTab (Unisoc T310)

Laporan teknis lengkap: [`docs/ADVAN_XTAB_HEADLESS_GUIDE.md`](docs/ADVAN_XTAB_HEADLESS_GUIDE.md)

### Rekayasa Arsitektur Headless Android 13:
1. **Otorisasi Buta Tanpa Layar (Blind HID Sequence):**
   Memanfaatkan emulasi hardware keyboard `scrcpy --otg` untuk menyetujui kunci RSA komputer tanpa layar:
   `[TAB]` $\rightarrow$ `[SPASI]` (Centang Selalu Izinkan) $\rightarrow$ `[TAB]` $\rightarrow$ `[ENTER]` (Klik OK).
2. **Pengerasan Kernel (Keep-Alive Hardening):**
   - `stay_on_while_plugged_in = 3`: Menjamin CPU tidak pernah masuk deep sleep saat dicolok charger.
   - `screen_off_timeout = 2147483647`: Menyetel waktu mati layar ke batas maksimum sistem.
   - `lockscreen.disabled = 1`: Menghilangkan layar kunci Android.
3. **Bypass Keamanan Android 13 (Anti-Tapjacking & Input Injection):**
   - Bypass blokir klik virtual pada konfirmasi rekam layar via AppOps:  
     `appops set com.anydesk.anydeskandroid PROJECT_MEDIA allow`
   - Mengaktifkan plugin kontrol sentuh remote via accessibility service:  
     `settings put secure enabled_accessibility_services com.anydesk.adcontrol.ad1/com.anydesk.adcontrol.AccService`
   - Mendaftarkan aplikasi ke whitelist Doze Mode agar koneksi remote standby 24 jam.
4. **Hasil Operasional:**
   Tablet dicolok charger di sudut ruangan, berfungsi mandiri tanpa kabel, dan dapat dikendalikan dari smartphone atau laptop melalui jaringan seluler maupun Wi-Fi lokal.

---

## 📁 Arsip Skrip Otomasi & Struktur Repositori

```
hardware-recovery-suite/
├── README.md                              <-- Laporan utama rekayasa sistem
├── docs/
│   ├── REALME_C2_HARDWARE_DIAGNOSTICS.md  <-- Laporan forensik MT6765 & peta jalan SMD rework
│   └── ADVAN_XTAB_HEADLESS_GUIDE.md       <-- Panduan arsitektur headless Android 13
├── keys/
│   ├── adbkey                             <-- Kunci privat otentikasi RSA
│   ├── adbkey.pub                         <-- Kunci publik otentikasi RSA
│   ├── BACA_PETUNJUK.txt                  <-- Panduan teknis integritas kunci
│   └── RESTORE_ADB_KEYS.bat               <-- Skrip restorasi kunci otomatis 1-klik
└── scripts/
    ├── advan-xtab/
    │   ├── BUKA_LAYAR_TABLET.bat          <-- Pemanggil display mirroring scrcpy
    │   ├── KLIK_IZINKAN_OTOMATIS.bat      <-- Injektor sinyal HID OTG untuk otorisasi buta
    │   ├── KONEKSI_WIRELESS_WIFI.bat      <-- Pemanggil koneksi scrcpy nirkabel lokal
    │   ├── SETUP_HEADLESS_PERMANEN.bat    <-- Skrip pengerasan status siaga kernel
    │   └── AKTIFKAN_ANYDESK_KONTROL.bat   <-- Skrip aktivasi service aksesibilitas remote
    └── realme-c2/
        ├── BACA_MESIN.bat                 <-- Eksekusi bypass DA1 via MTKClient
        ├── BUKA_GUI.bat                   <-- Peluncur GUI MTKClient
        ├── COBA_PRELOADER.bat             <-- Pengujian aneka preloader pabrikan
        ├── DUMP_PRELOADER.bat             <-- Dump preloader dari sektor boot
        └── SEDOT_DARI_RAM.bat             <-- Dump preloader dari SRAM chip
```

---

## 💻 Referensi Perintah Kunci Sistem (Technical Commands)

```bash
# Menyetel Keep-Awake Permanen pada Sumber Daya
adb shell "svc power stayon true"
adb shell "settings put global stay_on_while_plugged_in 3"

# Menonaktifkan Layar Kunci (Lockscreen Bypass)
adb shell "locksettings set-disabled true"
adb shell "settings put secure lockscreen.disabled 1"

# Bypass Proteksi MediaProjection Android 13
adb shell "appops set com.anydesk.anydeskandroid PROJECT_MEDIA allow"

# Mengaktifkan Layanan Aksesibilitas Plugin Kontrol
adb shell "settings put secure enabled_accessibility_services com.anydesk.adcontrol.ad1/com.anydesk.adcontrol.AccService"
adb shell "settings put secure accessibility_enabled 1"

# Mendaftarkan Aplikasi ke Whitelist Manajemen Daya (Doze Mode Whitelist)
adb shell "dumpsys deviceidle whitelist +com.anydesk.anydeskandroid"
adb shell "dumpsys deviceidle whitelist +com.anydesk.adcontrol.ad1"
```

---

*Laporan proyek dan seluruh konfigurasi dalam repositori ini disusun secara mandiri oleh Samuel Indra Bastian.*
