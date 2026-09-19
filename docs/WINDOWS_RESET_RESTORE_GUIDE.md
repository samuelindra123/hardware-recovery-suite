# Panduan Pemulihan Setelah Komputer / Windows Di-Reset (Post-Reset Manual)

**Developer:** Samuel Indra Bastian  
**Email:** comdonate9@gmail.com  
**Project:** Hardware Recovery Suite  
**Date:** September 2026  

---

## 1. Pendahuluan

Dokumen ini adalah instruksi darurat langkah-demi-langkah bagi **Samuel Indra Bastian** ketika komputer / laptop ini telah selesai di-*install ulang* (Fresh Install Windows). 

Dengan mengikuti panduan ini, Anda hanya membutuhkan waktu **kurang dari 3 menit** untuk memulihkan seluruh akses ke Advan XTab tanpa perlu mengatur ulang dari nol.

---

## 2. Langkah 1: Kloning Repositori Ini Kembali ke Laptop

Setelah Windows baru selesai di-install dan terhubung ke internet:
1. Pasang **Git** dan **GitHub CLI** (atau download zip dari GitHub):
   ```cmd
   gh repo clone samuelindra123/hardware-recovery-suite
   ```
2. Buka folder repositori yang baru di-download.

---

## 3. Langkah 2: Pulihkan Kunci Identitas ADB (1 Klik Saja)

Tablet Advan XTab Anda telah menyimpan kunci kriptografi RSA laptop lama Anda. Agar laptop baru Anda langsung dikenali tanpa memunculkan dialog persetujuan:

1. Buka folder `keys/`.
2. Klik kanan file **`RESTORE_ADB_KEYS.bat`** $\rightarrow$ pilih **Run as Administrator** (atau dobel klik).
3. Script akan otomatis membuat folder `C:\Users\<Nama_User>\.android\` dan menyalin file `adbkey` serta `adbkey.pub`.

**Hasil:** Laptop baru Anda sekarang memiliki identitas kriptografi yang 100% identik dengan laptop sebelum di-reset.

---

## 4. Langkah 3: Unduh Ulang Perkakas Minimal

Pasang dua perkakas ringan berikut (bisa disimpan di folder `C:\`):

1. **Android Platform Tools (ADB):**
   - Download: [Google Platform Tools Official](https://dl.google.com/android/repository/platform-tools-latest-windows.zip)
   - Ekstrak ke `C:\platform-tools-latest-windows\platform-tools\`
   - Tambahkan ke System PATH lingkungan Windows (opsional tapi disarankan).
2. **scrcpy (Display Mirroring):**
   - Download: [scrcpy Release Resmi di GitHub](https://github.com/Genymobile/scrcpy/releases)
   - Ekstrak ke `C:\scrcpy\scrcpy-win64-v2.4\`

---

## 5. Langkah 4: Cara Akses Tablet Sekarang

### Opsi A: Akses Lewat AnyDesk (Paling Praktis Tanpa Kabel)
1. Download aplikasi AnyDesk untuk Windows di laptop baru Anda.
2. Masukkan ID Tablet: **`1 748 101 943`**.
3. Klik **Connect** $\rightarrow$ masukkan sandi yang pernah Anda atur.
4. Anda langsung terhubung secara nirkabel!

### Opsi B: Akses Lewat scrcpy Kabel
1. Colokkan kabel USB Type-C dari tablet ke laptop.
2. Dobel klik file: `scripts\advan-xtab\BUKA_LAYAR_TABLET.bat`.
3. Layar tablet langsung tampil jernih di monitor komputer Anda pada 60 FPS tanpa jeda!

### Opsi C: Akses Lewat scrcpy Wireless (Satu Wi-Fi Rumah)
1. Pastikan tablet hidup dan terhubung ke Wi-Fi rumah.
2. Dobel klik file: `scripts\advan-xtab\KONEKSI_WIRELESS_WIFI.bat`.
3. Layar langsung terbuka nirkabel tanpa colokan kabel sama sekali!

---

*Dengan repositori GitHub ini, data, konfigurasi, dan seluruh perjuangan eksperimen Anda aman selamanya.*
