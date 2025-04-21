
-- Worksheet 6 - Stored Procedures dan Stored Functions

-- 1. Procedure: pro_naikan_harga
DELIMITER $$

CREATE PROCEDURE pro_naikan_harga(
    IN jenis_produk INT,
    IN persentasi_kenaikan INT
)
BEGIN
    UPDATE produk
    SET harga_jual = harga_jual + (harga_jual * persentasi_kenaikan / 100)
    WHERE jenis_produk_id = jenis_produk;
END $$

DELIMITER ;

-- 2. Function: umur
DELIMITER $$

CREATE FUNCTION umur(tgl_lahir DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE umur INT;
    SET umur = YEAR(CURDATE()) - YEAR(tgl_lahir);
    RETURN umur;
END $$

DELIMITER ;

-- 3. Function: kategori_harga
DELIMITER $$

CREATE FUNCTION kategori_harga(harga DOUBLE)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE kategori VARCHAR(20);

    IF harga <= 500000 THEN
        SET kategori = 'Murah';
    ELSEIF harga > 500000 AND harga <= 3000000 THEN
        SET kategori = 'Sedang';
    ELSEIF harga > 3000000 AND harga <= 10000000 THEN
        SET kategori = 'Mahal';
    ELSE
        SET kategori = 'Sangat Mahal';
    END IF;

    RETURN kategori;
END $$

DELIMITER ;



-- Worksheet 7 - Triggers

-- 1. Menambahkan kolom status_pembayaran di tabel pembayaran
ALTER TABLE pembayaran
ADD COLUMN status_pembayaran VARCHAR(25);

-- 2. Trigger: cek_pembayaran
DELIMITER $$

CREATE TRIGGER cek_pembayaran
BEFORE INSERT ON pembayaran
FOR EACH ROW
BEGIN
    DECLARE total_bayar DECIMAL(10, 2);
    DECLARE total_pesanan DECIMAL(10, 2);

    SELECT IFNULL(SUM(jumlah), 0) INTO total_bayar
    FROM pembayaran
    WHERE pesanan_id = NEW.pesanan_id;

    SELECT total INTO total_pesanan
    FROM pesanan
    WHERE id = NEW.pesanan_id;

    IF total_bayar + NEW.jumlah >= total_pesanan THEN
        SET NEW.status_pembayaran = 'Lunas';
    ELSE
        SET NEW.status_pembayaran = 'Belum Lunas';
    END IF;
END $$

DELIMITER ;

-- 3. Insert contoh data ke tabel pembayaran
INSERT INTO pembayaran (no_kuitansi, tanggal, jumlah, ke, pesanan_id, status_pembayaran)
VALUES ('KWI001', '2023-03-03', 200000, 1, 1, NULL);

-- 4. Stored Procedure: kurangi_stok
DELIMITER $$

CREATE PROCEDURE kurangi_stok(
    IN produk_id INT,
    IN jumlah INT
)
BEGIN
    UPDATE produk
    SET stok = stok - jumlah
    WHERE id = produk_id;
END $$

DELIMITER ;

-- 5. Trigger: trig_kurangi_stok
DELIMITER $$

CREATE TRIGGER trig_kurangi_stok
AFTER INSERT ON pesanan_items
FOR EACH ROW
BEGIN
    CALL kurangi_stok(NEW.produk_id, NEW.jumlah);
END $$

DELIMITER ;
