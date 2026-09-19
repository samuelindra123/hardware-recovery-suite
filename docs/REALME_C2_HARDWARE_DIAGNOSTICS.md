# Realme C2 (MT6765 / RMX1941) Hardware Diagnostics & Forensics Report

**Developer:** Samuel Indra Bastian  
**Email:** comdonate9@gmail.com  
**Project:** Hardware Recovery Suite  
**Date:** September 2026  

---

## 1. Ringkasan Eksekutif (Executive Summary)

Penyelidikan mendalam dilakukan terhadap satu unit ponsel cerdas **Realme C2 (Model: RMX1941 / Oppo A1k / cereus)** yang berada dalam kondisi *Hard Brick* (layar hitam total, tidak ada respon terhadap tombol power, tidak ada indikator getar atau pengisian daya).

Eksperimen diagnostik tingkat rendah (*low-level protocol forensics*) berhasil membuktikan secara ilmiah dan matematis bahwa **silikon prosesor (MediaTek MT6765 SoC) berada dalam kondisi prima**, namun **chip memori internal (eMCP BGA-153/221) telah mengalami kerusakan fisik permanen (*Physical Flash Memory Hardware Failure*)**. Temuan ini memvalidasi secara objektif diagnosis teknisi hardware (Timorritel) mengenai status *Beyond Economical Repair* (BER).

---

## 2. Spesifikasi Arsitektur Perangkat Keras

| Komponen | Spesifikasi Teknis |
| :--- | :--- |
| **Model Perangkat** | Realme C2 (RMX1941 / Oppo CPH1923 / platform `cereus`) |
| **Chipset / SoC** | MediaTek MT6765V (Helio P22, 12nm FinFET) |
| **CPU Core** | Octa-core ARM Cortex-A53 (4x 2.0 GHz + 4x 1.5 GHz) |
| **Boot ROM (BROM)** | On-die 32KB Mask ROM terintegrasi langsung di dalam silicon die |
| **Internal SRAM** | 128KB On-chip L1/L2 High-speed Scratchpad RAM |
| **Memori Penyimpanan** | eMCP (embedded Multi-Chip Package): Kombinasi eMMC 5.1 + LPDDR3/4X DRAM |
| **Protokol USB** | MediaTek USB VCOM / USB DA (VID: `0e8d`, PID: `0003`) |

---

## 3. Investigasi Daya & Intervensi Fisik

1. **Kondisi Baterai Awal:**
   - Tegangan baterai fisik terukur **0.00V** (sel baterai telah terkuras habis di bawah ambang batas proteksi BMS).
   - Pengisian daya standar lewat port Micro-USB gagal membangkitkan PMIC (Power Management IC).
2. **Injeksi Daya Eksternal:**
   - Tegangan eksternal diinjeksi langsung ke pinout VBAT dan GND menggunakan catu daya DC terukur pada **4.40V**.
   - Kapasitor elektrolit eksternal dipasang paralel pada rel tegangan VBAT untuk menyaring riak tegangan (*voltage ripple*) dan mengantisipasi *transient current spikes* saat inisialisasi BROM.
   - Hasil: Port USB pada motherboard langsung mendeteksi koneksi MediaTek USB Port (BROM mode).

---

## 4. Eksploitasi Protokol BROM & Injeksi SRAM

Dengan menggunakan *suite* alat forensik `mtkclient` berbasis Python, kami melakukan komunikasi langsung dengan Mask ROM (BROM) MT6765:

### A. Handshake BROM (Boot ROM Handshake)
- Port komunikasi: `COM` via USB CDC Serial (`VID:0e8d PID:0003`).
- Mask ROM merespons sequence sinkronisasi `0xA0 0x0A 0x50 0x05`.
- **Hasil:** **100% BERHASIL**.
- **Kesimpulan Hardware:**
  1. Jalur transmisi data USB D+ dan D- berfungsi sempurna.
  2. Kristal osilator sistem (26 MHz) aktif dan berosilasi normal.
  3. Inti prosesor ARM Cortex-A53 mampu mengeksekusi instruksi dari Mask ROM internal.

### B. Payload Injection (Bypass SLA / DAA)
- Mengeksekusi eksploitasi kerentanan *Kamakiri* untuk melewati proteksi *Secure Boot* MediaTek (SLA/DAA).
- Payload biner diinjeksikan langsung ke dalam **128KB Internal SRAM** MT6765.
- **Hasil:** **Payload Berhasil Dijalankan di SRAM**.
- **Kesimpulan Hardware:** Internal SRAM MT6765 bebas dari *bad cells* dan mampu menampung kode eksekusi tingkat rendah.

---

## 5. Titik Kegagalan Fatal: Investigasi eMCP Flash Storage

Setelah Download Agent Tahap 1 (DA1) aktif di dalam internal SRAM, DA1 berusaha menginisialisasi pengontrol memori eksternal (DRAM controller & eMMC bus controller) menggunakan beragam konfigurasi *Preloader* biner pabrikan:

- `0766_preloader_cereus_3C2D76D046.bin` (Firmware resmi Realme C2)
- `preloader_oppo6762_18540.bin` (Oppo A1k platform identik)
- `0766_preloader_oppo6765_19451_94B0482E99.bin`
- `preloader_Vivo_6762_Y8X_k62v1_64_bsp.bin`

### Bukti Forensik Kegagalan:

1. **Kegagalan Inisialisasi Bus eMMC:**
   - Sinyal Command (`CMD`), Clock (`CLK`), dan Data (`DAT0-DAT7`) pada bus eMMC tidak merespons respon inisialisasi OCR (Operation Conditions Register).
   - Pengontrol memori mengembalikan status nilai nol (`0x00000000`) atau `Timeout waiting for device`.
2. **Kegagalan Pembacaan Sektor Fisik:**
   - Perintah `dumppreloader` gagal membaca partisi `boot0` dan `boot1` pada memori eMMC.
   - Perintah `printgpt` (pembacaan GUID Partition Table pada sektor LBA 1) mengembalikan nilai *Read Error / Buffer Empty*.
   - Pembacaan alamat memori mentah pada register `0x00000000` mengalami *bus stall*.

---

## 6. Kesimpulan Diagnostik & Analisis Finansial

1. **Penyebab Utama Kematian HP:**
   - **Kerusakan Fisik Total pada eMCP IC.** Penyebab teknis:
     - Ausnya gerbang oksida sel NAND flash (*NAND flash endurance exhaustion*).
     - Rusaknya mikrokontroler internal eMMC di dalam kemasan BGA.
     - Keretakan bola solder BGA (*solder ball fracture*) di bawah chip akibat benturan mekanis atau panas berlebih.
2. **Status Perbaikan (BER - Beyond Economical Repair):**
   - Perbaikan unit ini **tidak dapat diselesaikan melalui software, flashing, atau modifikasi kabel**.
   - Satu-satunya metode perbaikan fisik adalah:
     1. Pengangkatan chip eMCP menggunakan *Hot Air Rework Station* (BGA rework).
     2. Pembersihan pad PCB dan *reballing*.
     3. Penggantian IC eMCP baru yang sudah diisi partisi RPMB (*Replay Protected Memory Block*) dan kunci kriptografi yang cocok dengan CPU MT6765 via *EasyJTAG Plus / UFI Box*.
   - Biaya perbaikan tersebut jauh melampaui nilai pasaran unit bekas Realme C2, sehingga keputusan untuk menghentikan proyek dan memindahkan fokus ke unit fungsional lain adalah keputusan rekayasa yang paling tepat dan rasional.

---

*Laporan ini disusun sebagai dokumentasi teknis forensik perangkat keras oleh Samuel Indra Bastian.*
