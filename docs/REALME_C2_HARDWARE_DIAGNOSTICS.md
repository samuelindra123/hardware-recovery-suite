# Realme C2 (MT6765 / RMX1941) Hardware Diagnostics & SMD Rework Report

**Author / Hardware Engineer:** Samuel Indra Bastian  
**Project:** Mobile Hardware Recovery & Embedded Systems Forensics  
**Target Platform:** Realme C2 (RMX1941 / Oppo A1k / platform `cereus`)  
**Architecture:** MediaTek MT6765V Helio P22 (Octa-core Cortex-A53) + BGA eMCP Storage  

---

## 1. Ringkasan Eksekutif (Executive Summary)

Laporan teknis ini mendokumentasikan investigasi forensik tingkat rendah (*low-level protocol forensics*) terhadap satu unit smartphone **Realme C2 (RMX1941)** yang mengalami kondisi *Hard Brick* total. 

Pengujian diagnostik berbasis perangkat keras membuktikan secara definitif bahwa:
1. **SoC MediaTek MT6765 (CPU, osilator 26MHz, USB PHY, internal 128KB SRAM) berada dalam kondisi normal.**
2. **Chip memori terintegrasi (eMCP BGA-153/221) mengalami kerusakan perangkat keras permanen (*Physical Flash Memory Failure*).**
3. Pemulihan unit ini membutuhkan intervensi fisik tingkat lanjut berupa **BGA SMD Rework** (pengangkatan IC, *reballing*, penggantian IC eMCP baru, dan penulisan partisi RPMB via alat pemrogram JTAG).

---

## 2. Analisis Arsitektur Perangkat Keras

| Parameter | Spesifikasi Teknis |
| :--- | :--- |
| **Model Perangkat** | Realme C2 (RMX1941 / platform `cereus`) |
| **System-on-Chip (SoC)** | MediaTek MT6765V (Helio P22, arsitektur 12nm FinFET) |
| **CPU Core** | Octa-core ARM Cortex-A53 (4x 2.0 GHz + 4x 1.5 GHz) |
| **Mask ROM (BROM)** | 32KB on-die Mask ROM tertanam di dalam silikon prosesor |
| **Internal SRAM** | 128KB on-chip L1/L2 High-speed Scratchpad RAM |
| **Storage & RAM** | eMCP (embedded Multi-Chip Package): eMMC 5.1 + LPDDR3/LPDDR4X DRAM |
| **Antarmuka USB** | USB VCOM CDC Serial Protocol (Vendor ID: `0e8d`, Product ID: `0003`) |

---

## 3. Investigasi Catu Daya & Stabilisasi Rel Tegangan

1. **Pengukuran Baterai Awal:**
   - Tegangan sel baterai bawaan terukur **0.00V** (kondisi *deep-discharge* di bawah batas minimum proteksi BMS).
   - Pengisian daya standar lewat jalur VBUS Micro-USB tidak mampu membangkitkan PMIC (Power Management IC).
2. **Intervensi Catu Daya Eksternal:**
   - Injeksi tegangan DC eksternal diterapkan langsung pada rel baterai (VBAT dan GND) sebesar **4.40V**.
   - Kapasitor elektrolit dipasang secara paralel pada rel VBAT untuk meredam riak tegangan (*voltage ripple*) dan menyuplai lonjakan arus sesaat (*transient current spikes*) saat inisialisasi Boot ROM berlangsung.
   - Hasil: Jalur VBUS dan USB D+/D- langsung mendeteksi koneksi MediaTek USB Port (BROM mode).

---

## 4. Eksploitasi Protokol BROM & Forensik Internal SRAM

Menggunakan *toolkit* protokol tingkat rendah berbasis Python (`mtkclient`), komunikasi langsung dilakukan terhadap Mask ROM (BROM) MT6765:

### A. Handshake USB BROM
- Perangkat berhasil merespons sequence sinkronisasi serial `0xA0 0x0A 0x50 0x05`.
- **Hasil:** **100% SUKSES**.
- **Indikator Hardware:**
  1. Jalur diferensial USB D+ dan D- berfungsi tanpa cacat impedansi.
  2. Osilator kristal referensi 26 MHz aktif dan stabil.
  3. Inti prosesor ARM Cortex-A53 mampu mengeksekusi instruksi Mask ROM internal.

### B. Injeksi Payload Bypass SLA / DAA
- Kerentanan *Kamakiri* dieksekusi untuk melewati mekanisme verifikasi kriptografi pabrikan (*Secure Boot SLA/DAA*).
- Kode biner DA1 (Download Agent Tahap 1) diinjeksikan langsung ke dalam **128KB Internal SRAM** MT6765.
- **Hasil:** **Eksekusi Payload di SRAM Berhasil**.
- **Indikator Hardware:** Internal SRAM MT6765 berfungsi sempurna tanpa adanya sel memori yang korup.

---

## 5. Bukti Kerusakan Fisik Chip eMCP

Setelah DA1 aktif di dalam SRAM prosesor, DA1 bertugas menginisialisasi jalur bus memori eksternal (pengontrol DRAM dan pengontrol bus eMMC) menggunakan konfigurasi Preloader biner resmi (`0766_preloader_cereus_3C2D76D046.bin`, `oppo6762_18540.bin`, dll).

### Data Forensik Kegagalan:
1. **Bus eMMC Tidak Merespons:**
   - Sinyal Command (`CMD`), Clock (`CLK`), dan Data (`DAT0-DAT7`) pada bus eMMC tidak memberikan respon terhadap register OCR (Operation Conditions Register).
   - Controller mengembalikan status nilai nol (`0x00000000`) atau *timeout*.
2. **Kegagalan Pembacaan Sektor Fisik:**
   - Pembacaan partisi boot sistem (`boot0` dan `boot1`) via `dumppreloader` menghasilkan kegagalan pembacaan (*I/O error*).
   - Pembacaan tabel partisi GPT (`printgpt`) pada LBA 1 mengembalikan nilai *Buffer Empty / Read Failure*.
3. **Kesimpulan:** 
   Silikon CPU normal, namun chip eMCP internal telah mati secara fisik akibat ausnya gerbang oksida sel NAND (*NAND flash endurance exhaustion*), kerusakan kontroler internal kemasan BGA, atau retaknya bola solder BGA di bawah chip.

---

## 6. Rencana Kerja Rekayasa Lanjutan: BGA SMD Rework & Penggantian IC

Untuk menghidupkan kembali motherboard Realme C2 ini ke status fungsional penuh, langkah perbaikan tingkat komponen (*chip-level repair*) akan dilakukan saat fasilitas peralatan SMD telah lengkap:

### A. Kebutuhan Peralatan (Tooling Requirements)
1. **Hot Air Blower Rework Station** (Suhu terkontrol dengan nozzle presisi, misal Quick 861DW atau sekelasnya).
2. **Soldering Station & T12/JBC Precision Tips** (Ujung pisau K-type untuk pembersihan pad).
3. **Stereomicroscope** (Perbesaran optik 7X - 45X untuk inspeksi jalur dan bola solder).
4. **BGA Reballing Stencil BGA-153 / BGA-221** khusus platina MTK/eMCP.
5. **Pasta Timah Solder (Solder Paste)** bertitik leleh sedang (Sn63Pb37 / 183°C).
6. **Fluks Kualitas Tinggi** (Amtech NC-559-ASM atau sejenisnya tanpa residu korosif).
7. **BGA Underfill Epoxy Remover Liquid** untuk melunakkan lem pabrik di sekitar chip.
8. **JTAG Programmer Box** (EasyJTAG Plus, UFI Box, atau Medusa Pro II).

### B. Prosedur Kerja BGA Rework (Step-by-Step Roadmap)

```
[ 1. Pre-heating & Underfill Removal ]
  └── Panaskan motherboard pada suhu 150°C - 180°C.
  └── Bersihkan lem underfill di sekeliling IC eMCP dengan pisau skrap khusus.
               │
[ 2. Desoldering Chip eMCP Rusak ]
  └── Aplikasikan fluks NC-559 pada sisi IC.
  └── Arahkan semburan udara panas merata pada suhu 350°C - 380°C (Airflow 60-70%).
  └── Angkat chip eMCP secara hati-hati menggunakan pinset tanpa merusak pad PCB.
               │
[ 3. Pembersihan & Restorasi Pad PCB ]
  └── Berikan timah bertitik leleh rendah untuk menurunkan titik leleh residu timah pabrik.
  └── Bersihkan seluruh pad motherboard menggunakan solder wick tembaga dan ujung solder K.
  └── Inspeksi mikroskopik: Pastikan seluruh jalur VCC, VCCQ, CLK, CMD, dan DAT0-7 utuh.
               │
[ 4. Pemrograman IC Pengganti (JTAG Box) ]
  └── Siapkan IC eMCP baru/donor (BGA-153 / BGA-221) yang kompatibel dengan MT6765.
  └── Hubungkan ke EasyJTAG Plus / UFI Box socket adapter.
  └── Konfigurasi Boot Partition (Boot Bus Config = 8-bit dual data rate, Boot1 enable).
  └── Tulis ulang partisi firmware cadangan (preloader, boot, vbmeta, recovery).
  └── Konfigurasi kunci otentikasi RPMB sesuai spesifikasi keamanan platform MediaTek.
               │
[ 5. Reballing & Pemasangan IC Baru ]
  └── Pasang plat cetak stensil BGA-153/221 pada IC baru.
  └── Ratakan pasta timah solder Sn63Pb37 dan panaskan pada suhu 280°C - 300°C.
  └── Posisikan IC pada motherboard dengan presisi panduan garis silkscreen.
  └── Reflow solder pada suhu 350°C hingga IC terlihat mengapung dan sejajar (*self-aligning*).
               │
[ 6. Uji Kelayakan & Flashing Akhir ]
  └── Bersihkan sisa fluks dengan cairan Isopropil Alkohol (IPA 99%).
  └── Ukur nilai resistansi/impedansi terhadap ground pada rel VCC (3.3V) dan VCCQ (1.8V).
  └── Sambungkan motherboard ke komputer via USB dan lakukan *scatter flashing* via SP Flash Tool.
```

---

*Laporan ini disusun secara independen sebagai dokumentasi teknis forensik perangkat keras dan panduan perbaikan chip-level oleh Samuel Indra Bastian.*
