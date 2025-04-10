
-- Worksheet 2 - Simple SELECTs

-- 2.2.1
SELECT * FROM produk WHERE stok=3 OR stok=10;

-- 2.2.2
SELECT * FROM produk WHERE harga_jual < 5000000 AND harga_jual > 500000;

-- 2.2.3
SELECT * FROM produk WHERE min_stok > stok;

-- 2.2.4
SELECT * FROM pelanggan ORDER BY tgl_lahir DESC;

-- 2.2.5
SELECT * FROM pelanggan WHERE tmp_lahir='jakarta' AND jk='P';

-- 2.2.6
SELECT * FROM pelanggan WHERE id IN (2,4,6);

-- 2.2.7
SELECT * FROM produk WHERE harga_jual >= 500000 AND harga_jual <= 6000000;

-- 2.3.1
SELECT * FROM produk WHERE kode LIKE 'K%' OR kode LIKE 'M%';

-- 2.3.2
SELECT * FROM produk WHERE kode NOT LIKE 'M%';

-- 2.3.3
SELECT * FROM produk WHERE nama LIKE '%TV%';

-- 2.3.4
SELECT * FROM pelanggan WHERE nama LIKE '%SA%';

-- 2.3.5
SELECT * FROM pelanggan WHERE tmp_lahir != 'Jakarta' AND nama LIKE '%yo%';

-- 2.3.6
SELECT * FROM pelanggan WHERE nama LIKE '_A%';

-- 2.4.1
SELECT * FROM produk ORDER BY harga_beli DESC LIMIT 2;

-- 2.4.2
SELECT * FROM produk ORDER BY harga_beli ASC LIMIT 1;

-- 2.4.3
SELECT * FROM produk ORDER BY stok DESC LIMIT 1;

-- 2.4.4
SELECT * FROM produk ORDER BY stok ASC LIMIT 2;

-- 2.4.5
SELECT * FROM pelanggan ORDER BY tgl_lahir DESC LIMIT 1;

-- 2.4.6
SELECT * FROM pelanggan ORDER BY tgl_lahir ASC LIMIT 1;


-- Worksheet 3 - Advanced SELECTs

-- 3.1.1
SELECT * FROM produk WHERE harga_beli * stok > 20000000;

-- 3.1.2
SELECT nama, stok, min_stok, (stok - min_stok) AS selisih FROM produk;

-- 3.1.3
SELECT SUM(harga_beli * stok) AS total_asset FROM produk;

-- 3.1.4
SELECT * FROM pelanggan WHERE YEAR(tgl_lahir) BETWEEN 1980 AND 1990;

-- 3.1.5
SELECT * FROM pelanggan WHERE YEAR(tgl_lahir) = 1998;

-- 3.1.6
SELECT * FROM pelanggan WHERE MONTH(tgl_lahir) = 8;

-- 3.1.7
SELECT nama, tmp_lahir, tgl_lahir, (YEAR(CURDATE()) - YEAR(tgl_lahir)) AS umur FROM pelanggan;


-- 3.2.1
SELECT COUNT(*) AS jumlah_pelanggan FROM pelanggan WHERE YEAR(tgl_lahir) = 1998;

-- 3.2.2
SELECT COUNT(*) AS jumlah_pelanggan FROM pelanggan WHERE jk = 'P' AND tmp_lahir = 'Jakarta';

-- 3.2.3
SELECT SUM(stok) AS total_stok FROM produk WHERE harga_jual < 10000;

-- 3.2.4
SELECT COUNT(*) AS jumlah_produk FROM produk WHERE kode LIKE 'K%';

-- 3.2.5
SELECT AVG(harga_jual) AS rata_rata_harga FROM produk WHERE harga_jual > 1000000;

-- 3.2.6
SELECT MAX(stok) AS stok_terbesar FROM produk;

-- 3.2.7
SELECT COUNT(*) AS jumlah_produk FROM produk WHERE stok < min_stok;

-- 3.2.8
SELECT SUM(harga_beli * stok) AS total_asset FROM produk;


-- 3.3.1
SELECT id, nama, stok,
  CASE
    WHEN stok <= min_stok THEN 'Segera belanja'
    ELSE 'Stok aman'
  END AS status_stok
FROM produk;

-- 3.3.2
SELECT id, nama, (YEAR(CURDATE()) - YEAR(tgl_lahir)) AS umur,
  CASE
    WHEN (YEAR(CURDATE()) - YEAR(tgl_lahir)) < 17 THEN 'Muda'
    WHEN (YEAR(CURDATE()) - YEAR(tgl_lahir)) BETWEEN 17 AND 55 THEN 'Dewasa'
    ELSE 'Tua'
  END AS kategori_umur
FROM pelanggan;

-- 3.3.3
SELECT id, kode, nama,
  CASE
    WHEN kode = 'TV01' THEN 'DVD Player'
    WHEN kode = 'K001' THEN 'Rice Cooker'
    ELSE 'Tidak Ada'
  END AS bonus
FROM produk;


-- 3.4.1
SELECT tmp_lahir, COUNT(*) AS jumlah_pelanggan FROM pelanggan GROUP BY tmp_lahir;

-- 3.4.2
SELECT jenis_produk, COUNT(*) AS jumlah_produk FROM produk GROUP BY jenis_produk;

-- 3.4.3
SELECT id, nama, (YEAR(CURDATE()) - YEAR(tgl_lahir)) AS umur
FROM pelanggan
WHERE (YEAR(CURDATE()) - YEAR(tgl_lahir)) < (
  SELECT AVG(YEAR(CURDATE()) - YEAR(tgl_lahir)) FROM pelanggan
);

-- 3.4.4
SELECT id, nama, harga_jual FROM produk
WHERE harga_jual > (SELECT AVG(harga_jual) FROM produk);

-- 3.4.5
SELECT pelanggan.id, pelanggan.nama, kartu.nama AS nama_kartu, kartu.iuran
FROM pelanggan
JOIN kartu ON pelanggan.kartu_id = kartu.id
WHERE kartu.iuran > 90000;

-- 3.4.7
SELECT pelanggan.id, pelanggan.nama, kartu.nama AS nama_kartu, kartu.diskon
FROM pelanggan
JOIN kartu ON pelanggan.kartu_id = kartu.id
WHERE kartu.diskon > 3;
